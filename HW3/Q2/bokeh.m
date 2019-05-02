% 读入图片
I = imread(['./0.jpg']);

% 转换为二值图像，并手动选取区域
Ibw1 = imbinarize(I,mean2(I)/255.0); % 以全局平均值做分界线转换
[x, y, I2, rect] = imcrop(Ibw1);
rect=uint16(rect); % 获得选取区域

% 取出区域中的图像
mask=false(size(Ibw1));
mask(rect(2):rect(4)+rect(2), rect(1):rect(3)+rect(1))=true;
Ibw2=zeros(size(Ibw1));
Ibw2(mask)=Ibw1(mask);

%对图像进行闭运算，得到封闭区域
se=strel('disk',80);
target = imclose(Ibw2, se);
target=logical(target)

% 对图像作高斯模糊处理
Ig = imgaussfilt(I, 40);
Ig(target) = I(target); % 选定区域用原图代替
imshow(Ig);
imwrite(Ig, "blur.jpg", "jpg");
