close all, clear all
I = imread('..\data\Fig0342(a)(contact_lens_original).tif');
I = im2double(I);

hy = [-1 -2 -1; 0 0 0; 1 2 1];
hx = [-1 0 1; -2 0 2; -1 0 1];

gx = imfilter(I, hx);
gy = imfilter(I, hy);
M = sqrt(gx.^2+gy.^2);

figure(1),
ax(1)=subplot(1,2,1); imshow(I);
ax(2)=subplot(1,2,2); imshow(M);
linkaxes(ax);