close all
I=imread('..\data\Fig0320(1)(top_left).tif');
h = imhist(I,256);
h = h/sum(h);
ch = cumsum(h);
figure(1),imshow(I);
figure(2),bar(h);
axis tight
figure(3),plot([0:255],ch*255),axis tight,xlabel('输入灰度'),ylabel('输出灰度')

J = histeq(I);
figure(4),imshow(J);
h = imhist(J,256);
h = h/sum(h);
figure(5),bar(h);
