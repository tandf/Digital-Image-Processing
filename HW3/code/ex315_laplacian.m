close all
% I = imread('..\data\bobby_blur.bmp');
I = imread('..\data\Fig0338(a)(blurry_moon).tif');
I = im2double(I);

h1 = [0 1 0; 1 -4 1; 0 1 0];
h2 = [1 1 1; 1 -8 1; 1 1 1];

J1 = imfilter(I,h1);
J2 = imfilter(I,h2);

figure(1),imshow(I);ax(1)=gca;
figure(2),imshow(J1,[]);ax(2)=gca;
figure(3),imshow(J2,[]);ax(3)=gca;
figure(4),imshow(I-J1);ax(4)=gca;% ≤ªƒ‹”√imshow(I-J1,[])
figure(5),imshow(I-J2);ax(5)=gca;
linkaxes(ax)
