I = imread('..\data\Fig0309(a)(washed_out_aerial_image).tif');
% I = imread('..\data\Fig0308(a)(fractured_spine).tif');
I = im2double(I);
gamma = 5;
I2 = I.^gamma;
figure(1),imshow(I);
figure(2),imshow(I2);