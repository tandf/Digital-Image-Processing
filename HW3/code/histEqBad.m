I=imread('..\data\zidane1.jpg');
% I=imread('..\data\ºÕ±¾.jpg');
I=rgb2gray(I);
figure(1),imshow(I);
figure(2),imhist(I);
J=histeq(I);
figure(3),imshow(J);
figure(4),imhist(J);
