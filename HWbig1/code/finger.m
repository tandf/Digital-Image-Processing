close all;

% 读取图片
img1 = im2double(imread('../FTIR.bmp'));
img2 = im2double(imread('../phone.bmp'));
img3 = im2double(imread('../latent.bmp'));

% 对三张图片进行处理并显示结果

[loimg1, lfimg1, lmimg1, mask1, filtered1] = finger_print(img1);
figure;
s1(1) = subplot(2, 3, 1);imshow(img1);
s1(2) = subplot(2, 3, 2);imshow(imresize(lfimg1, 8), []);
s1(3) = subplot(2, 3, 3);imshow(imresize(lmimg1, 8), []);
s1(4) = subplot(2, 3, 4);imshow(imresize(mask1, 8));
s1(5) = subplot(2, 3, 5);imshow(loimg1);
s1(6) = subplot(2, 3, 6);imshow(filtered1);
linkaxes(s1, 'xy');
imwrite(imresize(normalize(lfimg1), 8), "lf1.jpg");
imwrite(imresize(normalize(lmimg1), 8), "lm1.jpg");
imwrite(imresize(mask1, 8), "mask1.jpg");
imwrite(loimg1, "lo1.jpg");
imwrite(filtered1, "filtered1.jpg");

[loimg2, lfimg2, lmimg2, mask2, filtered2] = finger_print(img2);
figure;
s2(1) = subplot(2, 3, 1);imshow(img2);
s2(2) = subplot(2, 3, 2);imshow(imresize(lfimg2, 8), []);
s2(3) = subplot(2, 3, 3);imshow(imresize(lmimg2, 8), []);
s2(4) = subplot(2, 3, 4);imshow(imresize(mask2, 8));
s2(5) = subplot(2, 3, 5);imshow(loimg2);
s2(6) = subplot(2, 3, 6);imshow(filtered2);
linkaxes(s2, 'xy');
imwrite(imresize(normalize(lfimg2), 8), "lf2.jpg");
imwrite(imresize(normalize(lmimg2), 8), "lm2.jpg");
imwrite(imresize(mask2, 8), "mask2.jpg");
imwrite(loimg2, "lo2.jpg");
imwrite(filtered2, "filtered2.jpg");

[loimg3, lfimg3, lmimg3, mask3, filtered3] = finger_print(img3);
figure;
s3(1) = subplot(2, 3, 1);imshow(img3);
s3(2) = subplot(2, 3, 2);imshow(imresize(lfimg3, 8), []);
s3(3) = subplot(2, 3, 3);imshow(imresize(lmimg3, 8), []);
s3(4) = subplot(2, 3, 4);imshow(imresize(mask3, 8));
s3(5) = subplot(2, 3, 5);imshow(loimg3);
s3(6) = subplot(2, 3, 6);imshow(filtered3);
linkaxes(s3, 'xy');
imwrite(imresize(normalize(lfimg3), 8), "lf3.jpg");
imwrite(imresize(normalize(lmimg3), 8), "lm3.jpg");
imwrite(imresize(mask3, 8), "mask3.jpg");
imwrite(loimg3, "lo3.jpg");
imwrite(filtered3, "filtered3.jpg");


function [local_orient, local_freq, local_mag, mask, filtered] = finger_print(img)
% 指纹处理函数
% 输入指纹图像，输出分别为方向图、频率图、
% 赋值图、用于分离指纹的蒙版、处理后的指纹增强图

    [width, height] = size(img); % 获取大小

    % 计算方向图等各特征数据矩阵的大小，大小为原图的1/8
    % 由于对每个8*8大小的区域做傅里叶变换时，变换所取区域大小为32*32，
    % 故特征数据矩阵比总大小除8要小3（ (32 - 8) / 8 = 3）
    M = floor(width/8) - 3;
    N = floor(height/8) - 3;

    angs = zeros(M, N);
    local_freq = zeros(M, N);
    local_mag = zeros(M, N);
    local_orient = zeros(M*8, N*8);
    filtered = zeros(M*8, N*8);

    for i = 1 : M
        for j = 1 : N   
            dft = fftshift(fft2(img(8*i-7:8*i+24, 8*j-7:8*j+24), 32, 32)); % 对每个32*32区域做离散傅里叶变换
            dft = abs(dft);

            [maxi, maxj] = maxpoint(dft); % 找出傅里叶变换结果中，幅值最大的点，代表此区域的主要特征
            local_freq (i, j) = sqrt((maxi - 17)^2 + (maxj - 17)^2); % 计算此点距中心的距离，代表了区域的主要频率
            local_mag (i, j) = dft(maxi, maxj); % 计算此点的幅值，代表了区域的主要频率的幅值
            
            ang = atan((maxj-17)/(maxi-17)); % 计算此点对应的角度
            angs(i, j) = complex(cos(2 * ang), sin(2 * ang)); % 角度转换为复数，方便低通滤波
        end
    end
    angs = lpf(angs); % 对角度进行低通滤波
	local_freq = lpf(local_freq);
	local_mag = lpf(local_mag);

    mask = zeros(size(local_freq));
    % 用于分离前背景的蒙版，根据频率图的频率和幅值进行区分
    mask(local_mag > mean2(local_mag) * 0.85 - 0.2 * std2(local_mag) - 4 ...
        & local_freq < 8 & local_freq > 25 - 8.7 * mean2(local_freq)) = 1;

    % 对蒙版进行开、闭操作
    se=strel('disk', 3);
    mask=imopen(mask, se);
    se=strel('disk', 15);
    mask=imclose(mask, se);

    img = histeq(img); % 对图像进行直方图均衡，便于gabor滤波
    for i = 1 : M
        for j = 1 : N
            % 仅对蒙版中包含的区域做处理
            if mask(i, j)
                % 绘制方向图
                line = zeros(8, 8);
                line(4:5, :) = 1;
                ang = 0.5 * angle(angs(i, j)) * 180 / pi;
                line = imrotate(line, ang, 'bicubic', 'crop');
                local_orient (8*i-7:8*i, 8*j-7:8*j) = line;

                % 对角度处理，确保在0 - 360 范围内
                ang = ang - 90;
                if ang < 0
                    ang = ang + 360;
                end
                % gabor滤波
                [mag, phase] = imgaborfilt(img(8*i-7:8*i+24, 8*j-7:8*j+24), ...
                    max(2 * local_freq(i, j), 7), ang);
                filtered(8*i-7:8*i, 8*j-7:8*j) = mag(13:20, 13:20) .* cos(phase(13:20, 13:20));
            end
        end
    end
    % 对滤波结果进行低通滤波
    filtered = lpf(filtered);
    
end

function [maxi, maxj] = maxpoint(F)
% 寻找dft结果中幅值最大的点
    F(16:18, 16:18) = 0; % 去除图片中直流及低频量
    [maxi, maxj] = find(F == max(F(:)));
    maxi = maxi(1);
    maxj = maxj(1);
end

function result = lpf(img) 
% 低通滤波
    h = fspecial('gaussian', 5, 1);
    result = imfilter(img, h,'replicate');
end
