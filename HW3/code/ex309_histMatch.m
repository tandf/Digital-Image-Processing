close all
I = imread('..\data\Fig0323(a)(mars_moon_phobos).tif');
figure(1), 
ax(1)=subplot(2,3,1); imshow(I), title('Original image (I)');

[J1, T1] = histeq(I);  
ax(2)=subplot(2,3,2); imshow(J1), title('Histogram-equalized image (J1)');

% 为什么直方图均衡效果不好？0附近的像素比例太高，被映射到比较亮的灰度值，导致整体变亮。
subplot(2,3,4), imhist(I), title('Histogram of I');
subplot(2,3,5), imhist(J1), title('Histogram of J1');
subplot(2,3,6), plot(0:255, 255*T1), xlim([0 255]), ylim([0 255]), title('Transformation function');

% 原始的直方图比较像双模正态分布，分别对应暗和亮。希望把黑的调亮一些。
% 0.15对应255*0.15=
p = manualhist; 
%the following arguments were typed at the prompt  
% 0.15 0.05 0.75 0.05 1 0.1 0.002  - input is looped, don't forget to end with x 
[J2, T2] = histeq(I, p);  

figure(2), 
ax(1)=subplot(1,3,1); imshow(I), title('Original image (I)');
ax(2)=subplot(1,3,2); imshow(J1), title('Histogram-equalized image (J1)');
ax(3)=subplot(1,3,3); imshow(J2), title('Histogram-matching image (J2)');
linkaxes(ax);

figure(3),
subplot(2,2,1), imhist(I), title('Histogram of I');
subplot(2,2,2), stem(0:255,p, 'Marker', 'none'), title('Specified histogram');
subplot(2,2,3), imhist(J2), title('Histogram of J2');
subplot(2,2,4), plot(0:255, 255*T2), xlim([0 255]), ylim([0 255]), title('Transformation function');
