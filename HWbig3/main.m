close all;

%% Get data
% read data from file or calculate data from video
dataFromVideo = true;

if dataFromVideo
    output = [];
    for i = 1:8
        disp(['operating', num2str(i)])
        if isempty(output)
            output = tracking(i);
        else
            output = [output, tracking(i)];
        end
    end
    data = output;
else
    load('./result/data.mat', 'data');
end

close all;

%% Calculate speed
for i = 1:8
    disp(['*** video ', num2str(i), ' ***']);
    data(i).speed = calspeed(data(i).lines,...
        0.215 / 2 / data(i).ballRadius);

    % Remove outliers
    flag = true;
    while std(data(i).speed) > 2 && flag
        speedstd = std(data(i).speed);
        outlier = abs(data(i).speed - mean(data(i).speed)) > ...
            2 * speedstd;
        flag = sum(outlier);
        data(i).speed(outlier) = [];
    end
    avaliableSpeedNum = ['avaliable speed num ', ...
        num2str(length(data(i).speed))];
    meanSpeed = ['mean speed ', num2str(mean(data(i).speed))];
    maxSpeed = ['max speed ', ...
        num2str(max(data(i).speed))];
    disp(avaliableSpeedNum)
    disp(meanSpeed);
    disp(maxSpeed);

    % Show speed histogram
    fig = figure; histogram(data(i).speed); 
    title(['speed histogram of video ', num2str(i)]);
    annotation('textbox', 'String', ...
        {avaliableSpeedNum, meanSpeed, maxSpeed})
    saveas(fig, ['./result/hist', num2str(i), '.png']);
end

save('./result/data.mat', 'data');

%% Calculate speed using lines.
function speed = calspeed(lines, proportion)
	for i = 1 : length(lines) - 1
		dis = sqrt(sum((lines(i) - lines(i + 1)).^2));
		speed(i) = dis * proportion * 240;
	end
end

