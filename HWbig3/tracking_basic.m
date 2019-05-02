function tracking_basic(videoname)

close all
if nargin == 0
	videoname = 'videos/5.mp4';
end
obj = VideoReader(videoname);
obj.CurrentTime = 15/obj.FrameRate;
firstFrame = readFrame(obj);
previousFrame = firstFrame;
figure, imshow(previousFrame);
title('点选球的中心点并回车')
[x,y] = initial();

maxMetric = 0;

%%
% 记录下初始坐标并存入lines中
count = 1;
lines = [];
lines(count,:) = [x,y];

%%
segs = [];
frame = readFrame(obj);
while obj.CurrentTime < obj.Duration
    % 对读入的每帧进行处理，结合上一帧的足球坐标（x,y），得到足球的分割前景图
	ballground = segment(frame, previousFrame, x, y);

	[centers, radii, metric] = imfindcircles(ballground, [1, 5], ...
		'ObjectPolarity', 'bright');

	for i = 1:3
		per_frame = frame(:,:,i);
		per_frame(ballground>0) = 255;
		frame(:,:,i)= per_frame;
	end
	
	imshow(frame);
	
	hold on;
	if ~isempty(metric)
		viscircles(centers(1, :), radii(1), 'EdgeColor','y', ...
			'LineWidth', 1, 'LineStyle', '-');
	end

    % 根据足球前景图确定足球的中心
    [x,y] = calcenter(ballground);
    % 记录下坐标存入lines中，并画图
    % 记录下这一帧的足球前景图，并存入segs中
    count = count + 1;
    lines(count,:) = [x,y];

    plot(lines(:,1),lines(:,2),'r-');
	drawnow;
    hold off

	if ~isempty(metric) && metric(1) > maxMetric
		ballRadius = radii(1);
		maxMetric = metric(1);
	end

    segs(count-1,:,:) = ballground;

    % 滚动处理下一帧，直到结束
    previousFrame = frame;
    frame = readFrame(obj);
end
%%
% 处理完每一帧后，根据保存的足球分割图集segs，结合一些先验知识，计算足球面积、估算球速等
speed = calspeed(lines, 0.215 / 2 / ballRadius);
assignin('base', 'speed', speed)
assignin('base', 'lines', lines)

%%
% 下面是最终展示足球框的代码，可忽略
ballground = segment(frame,previousFrame,x,y);
for i = 1:3
    per_frame = frame(:,:,i);
    per_frame(ballground>0) = 255;
    frame(:,:,i)= per_frame;
end
figure;imshow(frame)
[x,y] = calcenter(ballground);
count = count+1;
hold on
lines(count,:) = [x,y];
plot(lines(:,1),lines(:,2),'r-');
[x_min,x_max,y_min,y_max] = calbbox(ballground);
draw_lines(x_min,x_max,y_min,y_max)
viscircles([x, y], ballRadius,'EdgeColor','y', 'LineWidth', 1, 'LineStyle', '-');
hold on
title('红色为轨迹/白色为足球分割结果/蓝色为足球检测框/黄色为足球检测结果')

end
function draw_lines(x_min,x_max,y_min,y_max)
    hold on
    liness = [x_min,x_min,x_max,x_max,x_min;y_min,y_max,y_max,y_min,y_min];
    plot(liness(1,:),liness(2,:))
    hold off;
end

function [x_min,x_max,y_min,y_max] = calbbox(I)
    [rows,cols] = size(I); 
    x = ones(rows,1) * (1:cols);
    y = (1:rows)' * ones(1,cols);   
    rows = I.*x;
    x_max = max(rows(:))+2;
    rows(rows==0) = x_max;
    x_min = min(rows(:))-2;
    rows = I.*y;
    y_max = max(rows(:))+2;
    rows(rows==0) = y_max;
    y_min = min(rows(:))-2;
end

%%
function [x,y] = initial()
    % 你需要在这里完成足球点的初始化
    [x,y] = ginput();
	[x, y] = deal(x(end), y(end));
    x = int16(x);
    y = int16(y);
end

function ballground = segment(frame,previousFrame,x,y)
    % 你需要在这里完成每一帧的足球前景分割

    h = 10;
    w = 10;
    bw = rgb2gray(previousFrame);
    bw2 = rgb2gray(frame);
    mask = zeros(size(bw2));
    mask(y-h:y+h,x-w/2:x+w) = 1;
    %mask(y-h:y+h,x-w:x+w) = 1;
	ballground = mask & ((bw2 > 240) | abs(bw2 - bw) > 10);
	%ballground = mask & ((bw2 > 200) | abs(bw2 - bw) > 20);
	%ballground = imopen(ballground, strel('disk', 3));
	ballground = imclose(ballground, strel('disk', 10));
end

function [meanx,meany] = calcenter(I)
    % 你需要在这里完成足球中心点的计算，根据前景图
    [rows,cols] = size(I); 
    x = ones(rows,1) * (1:cols);
    y = (1:rows)' * ones(1,cols);   
    area = sum(sum(I)); 
    meanx = int16(sum(sum(I.*x))/area); 
    meany = int16(sum(sum(I.*y))/area);
end

function speed = calspeed(lines, proportion)
    % 你需要在这里完成足球面积的计算和球速的估算
	for i = 1 : length(lines) - 1
		dis = sqrt(sum((lines(i) - lines(i + 1)).^2));
		speed(i) = dis * proportion * 240;
	end
end
