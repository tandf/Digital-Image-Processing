close all, clear all
I = imread('..\data\bobby_blur.bmp');
% I = imread('..\data\Fig0340(a)(dipxe_text).tif');
I = im2double(I);

h = fspecial('gaussian',5,3);
I_blur = imfilter(I,h);
I_mask = I-I_blur;
J1 = I+1*I_mask;
J2 = I+5*I_mask;

figure(1),imshow(I);ax(1)=gca;
figure(2),imshow(I_blur,[]);ax(2)=gca;
figure(3),imshow(I_mask,[]);ax(3)=gca;
figure(4),imshow(J1);ax(4)=gca;
figure(5),imshow(J2);ax(5)=gca;
linkaxes(ax)

% figure(1),
% ax(1)=subplot(5,1,1); imshow(I);
% ax(2)=subplot(5,1,2); imshow(I_blur);
% ax(3)=subplot(5,1,3); imshow(I_mask,[]);
% ax(4)=subplot(5,1,4); imshow(J1);
% ax(5)=subplot(5,1,5); imshow(J2);
% linkaxes(ax);
% 
% y=100;x=20:50;
% idx = sub2ind(size(I),y*ones(size(x)),x);
% figure(6),
% subplot(5,1,1),plot(x,I(idx));ylim([0 1.5])
% subplot(5,1,2),plot(x,I_blur(idx));ylim([0 1.5])
% subplot(5,1,3),plot(x,I_mask(idx));ylim([-0.75 0.75])
% subplot(5,1,4),plot(x,J1(idx));ylim([0 1.5])
% subplot(5,1,5),plot(x,J2(idx));ylim([0 1.5])