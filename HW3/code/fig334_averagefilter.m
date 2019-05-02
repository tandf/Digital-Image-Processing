close all
I = imread('..\data\Fig0334(a)(hubble-original).tif');
J1 = imfilter(I,ones(15,15)/(15*15));
threshold = 0.25*max(J1(:));
J2 = J1>threshold;
figure(1),clf
ax(1)=subplot(1,3,1); imshow(I);
ax(2)=subplot(1,3,2); imshow(J1);
ax(3)=subplot(1,3,3); imshow(J2);
linkaxes(ax);