% encoding: utf-8

function y = AddNoiseBatch(path)
files = dir(fullfile([path '*.jpg'])); %获取目录中文件
fileslength = length(files);
for i = 1 : fileslength
    imgfullpath = strcat(path, files(i).name); %获取完整文件名
    disp(['Processing ' imgfullpath]);
    l1 = imread(imgfullpath); %读入图像
    l2 = rgb2gray(l1); %转换为灰度图
    l2size = size(l2); %获取大小，便于计算目标大小
    l3height = floor(1000 * l2size(1) / l2size(2)); %计算目标高度
    l3 = imresize(l2, [l3height 1000], 'bicubic'); %插值得到l3
    dl3 = im2double(l3); %转为double
    noise = randn(size(l3)); %生成噪声
    l4 = dl3 + noise; %叠加噪声
    minl4 = min(min(l4));
    maxl4 = max(max(l4));
    ll4 = (l4 - minl4)/(maxl4 - minl4); %线性拉伸
    figure; %显示图像
    ax(1) = subplot(1, 3, 1); imshow(l3); title('l3');
    ax(2) = subplot(1, 3, 2); imshow(noise); title('noise');
    ax(3) = subplot(1, 3, 3); imshow(l4); title('l4');
    linkaxes(ax, 'xy'); %坐标系关联
    [ans imgname ans] = fileparts(imgfullpath);
    imwrite(l4, [path imgname '.bmp']); %保存为.bmp
end
end
