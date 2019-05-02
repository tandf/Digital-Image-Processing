close all;

% 读取图片并获得汽车部分的mask
img = im2double(imread('car.bmp'));
mask = imread('mask.bmp');
carmask = (mask == 0);
subplot(2, 4, 1);imshow(carmask);title("mask");

% 取出汽车
car = zeros(size(img));
car(carmask) = img(carmask);
subplot(2, 4, 2);imshow(car);title("car");

% 得到向左移动的滤波器
len = 100;
carh = 2 * fspecial('motion',len * 2,0);
carh(len+2:end) = 0;

% 对仅有汽车的图片做滤波，非零的部分则为汽车扫过的区域
carblur = imfilter(car,carh,'replicate');
subplot(2, 4, 3);imshow(carblur);title("carblur");
carblurmask = (carblur > 0);
subplot(2, 4, 4);imshow(carblurmask);title("carblur mask");

% 对汽车扫过的区域做滤波，其他部分不变?
carmotion = img;
carblur = imfilter(img, carh, 'replicate');
carmotion(carblurmask) = carblur(carblurmask);
subplot(2, 4, 5);imshow(carmotion);title("car motion");

% 为使得结果更加逼真，将汽车区域结果与原图做平均
carmotion(carmask) = img(carmask) * 0.5 + carmotion(carmask) * 0.5;
subplot(2, 4, 6);imshow(carmotion);title("car enhanced");

% 向右移动滤波器
bgh = 2 * fspecial('motion',len * 2,0);
bgh(1: len) = 0;

% 对图片背景部分做滤波
bgmotion = imfilter(img,bgh,'replicate');
subplot(2, 4, 7);imshow(bgmotion);title("bg motion all");
bgmotion(carmask) = img(carmask);
subplot(2, 4, 8);imshow(bgmotion);title("bg motion after mask");

imwrite(carmotion, "carmotion.jpg");
imwrite(bgmotion, "bgmotion.jpg");
