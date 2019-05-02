close all;
img = im2double(imread('car.bmp'));
mask = imread('mask.bmp') == 0;
len = 50;
[height, width] = size(img);

h = 2 * fspecial('motion',len * 2,0);
h(len+2:end) = 0;
motion = imfilter(img, h, 'circular');
figure(1);imshow(motion);

% 误差程度
vars = [0, 0.00001, 0.0001, 0.001, 0.01, 0.1];

for variance = vars
    name = num2str(variance);   
    noise = variance*randn(height, width);
    g = imnoise(motion, 'gaussian', 0, variance);
    subplot(1, 3, 1);imshow(g);
    G = fft2(g, height, width);
    
    H = fft2(h, height, width);
    n = 0.00002;
    H(abs(H) < n) = n;
    R = ones(height, width)./H;
    F2 = G .* R;
    invH = abs(ifft2(F2));
    figure;sgtitle("var = " + name);
    subplot(1, 3, 2);imshow(invH);
    
    estimated_nsr = variance / var(img(:));
    wnr1 = deconvwnr(g, h, estimated_nsr);
	% 维纳滤波结果有平移，消除这部分平移
	wnr = zeros(size(wnr1));
    wnr(:, 1:end-len) = wnr1(:, len+1:end);
    wnr(:, end-len+1:end) = wnr1(:, 1: len);
    subplot(1, 3, 3);imshow(wnr);
	
    imwrite(invH, "invH" + name + ".jpg", "jpg");
    imwrite(wnr, "wnr" + name + ".jpg", "jpg");
end
