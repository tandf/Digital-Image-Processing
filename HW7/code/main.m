close all
files = dir(fullfile('../LV_data/*.txt'));
fileslength = length(files);

% 读取数据
for i = 1 : fileslength
    fullPath = strcat('../LV_data/', files(i).name);
    fileID = fopen(fullPath,'r');

    formatSpec = '%f %f %f';
    sizeA = [3 Inf];

    tri = fscanf(fileID, formatSpec, sizeA);
    TrainingData(i).Vertices = tri';
	fclose(fileID);
end

% 对齐并进行主成分分析
[ShapeData, TrainingData] = ASM_MakeShapeModel3D(TrainingData);

% 改变系数，观察前三个主成分的意义
for i = 1:3
    for ii = -1000 : 10 : 1000
        V = ii * ShapeData.Evectors(:, i) + ShapeData.x_mean;
        V = reshape(V, 86, 3);
        Show(V);
        drawnow;
    end
    pause
end

% 不同主成分重建
itemId = 1;
for j = 1:3
    x = [TrainingData(itemId).CVertices(:,1)', ...
        TrainingData(itemId).CVertices(:,2)', ...
        TrainingData(itemId).CVertices(:,3)']';
    re(j).Vertices = ((x-ShapeData.x_mean)' * ...
        ShapeData.Evectors(:,1: power(5, j-1)) * ...
        ShapeData.Evectors(:,1:power(5, j-1))')' + ShapeData.x_mean;
    for ii = 1:3
        re(j).Vertices = reshape(re(j).Vertices, 86, 3);
    end
end

ax1 = subplot(1, 4, 1); Show(re(1).Vertices);
ax2 = subplot(1, 4, 2); Show(re(2).Vertices);
ax3 = subplot(1, 4, 3); Show(re(3).Vertices);
subplot(1, 4, 4); Show(TrainingData(itemId).CVertices);
Link = linkprop([ax1, ax2, ax3],{'CameraUpVector', 'CameraPosition',...
    'CameraTarget', 'XLim', 'YLim', 'ZLim'});
setappdata(gcf, 'StoreTheLink', Link);
