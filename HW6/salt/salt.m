I = imread('binzhou.bmp');
I = im2double(I);

I2 = I;
for k = 1:3
    I2(:,:,k) = imnoise(I(:,:,k),'salt & pepper',0.1);
end

J = I2;
for k = 1:3
    J(:,:,k) = medfilt2(I2(:,:,k),[3 3]);
end

figure;
ax1(1)=subplot(1,3,1);imshow(I),title('I')
ax1(2)=subplot(1,3,2);imshow(I2),title('I2')
ax1(3)=subplot(1,3,3);imshow(J),title('J')
linkaxes(ax1);
