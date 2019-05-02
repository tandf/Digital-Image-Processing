function output = tracking(videonum)
% Trun of warnings.
warning('off', 'Images:initSize:adjustingMag');
warning('off', 'images:imfindcircles:warnForSmallRadius');
warning('off', 'images:imfindcircles:warnForLargeRadiusRange');
warning('off', 'MATLAB:colon:nonIntegerIndex');

close all

videoname = ['videos/', num2str(videonum), '.mp4'];
obj = VideoReader(videoname);

%% caculate motion mask
% Using a predetector to detect all motion through the video. Find 
% motions that lasts a long time. They are not the ball, for the ball
% stays in a position only for a short time.
predetector = vision.ForegroundDetector(...
    'NumTrainingFrames', 10, 'InitialVariance', 1000);
ballgrounds = [];

% Training data.
for i = 1: 10
	predetector(readFrame(obj));
end
obj.CurrentTime = 0;

while obj.CurrentTime < obj.Duration
    motionDetected = predetector(readFrame(obj));
    ballgrounds(length(ballgrounds) + 1).motion = motionDetected;
end

global motionMask;
motionMask = ballgrounds(1).motion;
for i = 2:length(ballgrounds)
    motionMask = motionMask + ballgrounds(i).motion; 
end
motionMask = (motionMask / length(ballgrounds)) > 0.1;
motionMask = imerode(motionMask, strel('square', 3));
motionMask = imclose(motionMask, strel('disk', 10));
motionMask = ~motionMask;
figure;imshow(motionMask); title('motionMask');

%% Locate the ball
% Detect motion from the first frame, and filter it using motionMask.
% If no motion is left, move to the next frame, until a motion is 
% detected. We can assume that the motion marks the ball.
detector = vision.ForegroundDetector(...
    'NumTrainingFrames', 15, 'InitialVariance', 5000);

obj.CurrentTime = 0;
% Training data.
for i = 1: 15
	frame = readFrame(obj);
    detector(frame);
end

% Try to locate the ball
obj.CurrentTime = 0;
frame = readFrame(obj);
motionDetected = detector(frame);
ballground = motionDetected & motionMask;
ballground = imopen(ballground, strel('disk', 2));
[x,y] = calcenter(ballground);
failcount = 0;

% Detect using the next frame when failing to detect the ball.
while x == 0 && y == 0
    frame = readFrame(obj);
    motionDetected = detector(frame);
    ballground = motionDetected & motionMask;
    ballground = imopen(ballground, strel('disk', 2));
    [x,y] = calcenter(ballground);
    failcount = failcount + 1;
end

% Show the fail count.
disp(['fail count: ', num2str(failcount)]);
% Draw the first detected location of the ball.
figure; imshow(min(frame, uint8(~ballground * 255)));
hold on; plot(x, y, 'b*');
title('first ball location detected');
initialLocation = [x, y];

%%
% 记录下初始坐标并存入lines中
count = 1;
lines = [];
lines(count,:) = [x,y];

%% Initialization
frame = readFrame(obj);
maxMetric = 0;
ballRadius = 0;
kalmanFilter = configureKalmanFilter('ConstantAcceleration', ...
    initialLocation, 1E5 * ones(1, 3), [25, 10, 10], 1000);

%% Track football
figure;
while obj.CurrentTime < obj.Duration
    % 对读入的每帧进行处理，结合上一帧的足球坐标（x,y），得到足球的分割前景图
	ballground = segment(frame, x, y, detector);

	for i = 1:3
		per_frame = frame(:,:,i);
		per_frame(ballground>0) = 255;
		frame(:,:,i)= per_frame;
	end
    figure(3);subplot(1, 2, 2);
    imshow(frame);

    % Try to find circles in the area.
	[centers, radii, metric] = imfindcircles(ballground, [1, 6], ...
		'ObjectPolarity', 'bright');
	hold on;
	if ~isempty(metric)
        % If a circle is found, draw it.
		viscircles(centers(1, :), radii(1), 'EdgeColor','y', ...
			'LineWidth', 1, 'LineStyle', '-');
	end

    % 根据足球前景图确定足球的中心
    [x,y] = calcenter(ballground);

    % If ball center is not detected, use the last x y.
	if x == 0 && y == 0
		[x,y] = deal(lines(count, 1), lines(count, 2));
	end

    % Correct using kalman filter.
    predict(kalmanFilter);
	corrected = correct(kalmanFilter, [x, y]);
    [x, y] = deal(corrected(1), corrected(2));
    count = count + 1;

    % 记录下坐标存入lines中，并画图
	lines(count,:) = [x,y];
    plot(lines(:,1),lines(:,2),'r-');
	drawnow;
    hold off

    % If a circle is detected, check whether the circle is better 
    % than history. Store the value if it's better.
	if ~isempty(metric) && metric(1) > maxMetric
		ballRadius = radii(1);
		maxMetric = metric(1);
	end

    % 滚动处理下一帧，直到结束
    frame = readFrame(obj);
end

% Output values.
output.lines = lines;
output.ballRadius = ballRadius;
output.metric= maxMetric;

%%
% 下面是最终展示足球框的代码，可忽略
ballground = segment(frame, x, y, detector);
for i = 1:3
    per_frame = frame(:,:,i);
    per_frame(ballground>0) = 255;
    frame(:,:,i)= per_frame;
end
fig=figure;imshow(frame)
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
saveas(fig, ['./result/track', num2str(videonum), '.png']);
end

%% Functions
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

function ballground = segment(frame,x,y,detector)
    % 你需要在这里完成每一帧的足球前景分割
    h = 8;
    w = 8;
    mask = zeros(size(frame(:, :, 1)));
    % Because the ball is flying from left to right, set the mask
    % area accordingly.
    mask(y-h:y+h,x-w/2:x+w) = 1;
    % Use detector to detect motion.
    motionDetected = detector(frame);
    global motionMask;
    % Use mask to filter positions far from the last position.
    % Use motionMask to filter positions that is not the ball.
	ballground = mask & motionDetected & motionMask;
	ballground = imclose(ballground, strel('disk', 5));
    figure(3);subplot(1, 2, 1);
    imshow(motionDetected);
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
