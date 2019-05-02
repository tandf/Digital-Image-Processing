close all
I = imread('..\data\Fig0335(a)(ckt_board_saltpep_prob_pt05).tif');
J1 = imfilter(I,ones(3,3)/9);
J2 = medfilt2(I,[3 3]);
figure(1),clf
ax(1)=subplot(1,3,1); imshow(I);
ax(2)=subplot(1,3,2); imshow(J1);
ax(3)=subplot(1,3,3); imshow(J2);
linkaxes(ax);