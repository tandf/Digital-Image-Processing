% ex312_LocalEnhance

close all
I = imread('..\data\Fig0327(a)(tungsten_original).tif');
figure(1),imshow(I),set(gcf,'name','Original');

%% Global histogram equalization
J1 = histeq(I);
figure(2),imshow(J1),set(gcf,'name','Global histogram equalization');

%% Enhancement using local histogram statistics
I = double(I);
mean_global = mean2(I);
std_global = std2(I);

% 计算局部平均值
tic
fun1 = @(x) mean2(x);
mean_local_o = nlfilter(I,[3 3],fun1);% slow
toc
tic
newI = zeros(size(I) + [2 2]); % 向图像四周填充0，以得到nlfilter同样的效果
newI(2:end-1,2:end-1) = I;
intI = integralImage(newI); % 获得积分图像
H = integralKernel([1 1 3 3], 1/9); % 定义积分核
mean_local = integralFilter(intI,H); % 计算得到局部平均值
toc
max(max(abs(mean_local-mean_local_o))) % 计算与原方法最大误差

tic
fun2 = @(x) std2(x);
std_local_o = nlfilter(I,[3 3],fun2);% slow
toc
tic
std_local = stdfilt(newI);
std_local = std_local(2:end-1, 2:end-1);
toc
max(max(abs(std_local - std_local))) % 计算与原方法的最大误差

figure(3),imshow(uint8(mean_local)),set(gcf,'name','Local mean');
figure(4),imshow(uint8(std_local)),set(gcf,'name','Local standard deviation');

% 计算得到mask
% mask 中的部分需满足条件：局部平均值足够小、局部方差足够大
% 控制局部平均值，选取灰度值低的部分进行处理
% 控制局部方差，选中方差在一定范围内的图像，即有充足的细节信息的部分进行处理
% k0 定义了平均值最小值（以全局平均值作为参考）
% k1 和 k2 定义了方差所在的范围（以全局方差作为参考）
k0 = 0.4; k1 = 0.02; k2 = 0.4; E = 4;
mask = (mean_local<=k0*mean_global) & (std_local>=k1*std_global) & (std_local<=k2*std_global);

J2 = I;
J2(mask) = I(mask)*E;
figure(5),imshow(mask),set(gcf,'name','MASK');
figure(6),imshow(uint8(J2)),set(gcf,'name','Enhancement by local statistics');
