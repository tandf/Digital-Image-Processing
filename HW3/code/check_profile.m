close all, clear all
I = imread('..\data\bobby_blur.bmp');
Show(1, I);
n = 20;
[cx,cy,p1,xi,yi] = improfile(n);
figure(3), plot(1:n,p1,'b-')
% radius = 10;
% x1 = min(round(xi));
% x2 = max(round(xi));
% y1 = min(round(yi));
% y2 = max(round(yi));
% sub = I(y1-radius:y2+radius,x1-radius:x2+radius);
% figure(4), subplot(1,2,1), imshow(sub), hold on, line(xi-x1+radius, yi-y1+radius)
x0 = round(mean(xi));
y0 = round(mean(yi));
radius = 50;
sub = I(y0-radius:y0+radius,x0-radius:x0+radius);
figure(4), subplot(1,2,1), imshow(sub), hold on, plot(xi-x0+radius+1, yi-y0+radius+1,'b-')

I = imread('..\data\bobby_sharp.bmp');
Show(2, I);
[cx,cy,p2,xi,yi] = improfile(n);
figure(3), hold on, plot(1:n,p2,'r-')
x0 = round(mean(xi));
y0 = round(mean(yi));
sub = I(y0-radius:y0+radius,x0-radius:x0+radius);
figure(4), subplot(1,2,2), imshow(sub), hold on, plot(xi-x0+radius+1, yi-y0+radius+1, 'r-')
