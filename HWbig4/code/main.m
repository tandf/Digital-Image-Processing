close all;
I = imread('../pic/lena_std.tif');
quality = [1, 5, 10, 20]

for i = 1:4
    q = quality(i);

    b = 0;
    for ii = 1:3
        J1(ii) = im2jpeg_lpc(I(:,:,ii), q);
        b = b + bytes(J1(ii));
    end

    for ii = 1:3
        I1(:,:,ii) = jpeg2im_lpc(J1(ii));
    end

    rmse1 = CompareImages(I, I1);
    ratio1 = b / bytes(I);

    Iycbcr = rgb2ycbcr(I);
    J2Y = im2jpeg_lpc(Iycbcr(:,:,1), q);
    J2Cb = im2jpeg_lpc(imresize(Iycbcr(:, :, 2), 0.5), q);
    J2Cr = im2jpeg_lpc(imresize(Iycbcr(:, :, 3), 0.5), q);
    b = bytes(J2Y) + bytes(J2Cb) + bytes(J2Cr);

    I2 = I;
    I2(:,:,1) = jpeg2im_lpc(J2Y);
    I2(:,:,2) = imresize(jpeg2im_lpc(J2Cb), 2);
    I2(:,:,3) = imresize(jpeg2im_lpc(J2Cr), 2);
    I2 = ycbcr2rgb(I2);

    rmse2 = CompareImages(I, I2);
    ratio2 = b / bytes(I);

    fprintf(['q: ', num2str(q), '\n'])
    fprintf(['rgb:\trmse:', num2str(rmse1), ' \tratio:\t', num2str(ratio1), '\n'])
    fprintf(['ycbcr:\trmse:', num2str(rmse2), ' \tratio:\t', num2str(ratio2), '\n\n'])
    figure(i);
    ax(1) = subplot(1,3,1);imshow(I);
    ax(2) = subplot(1,3,2);imshow(I1);
    ax(3) = subplot(1,3,3);imshow(I2);
    linkaxes(ax);
    imwrite(I1, ['..\pic\', num2str(q), 'rgb.png'])
    imwrite(I2, ['..\pic\', num2str(q), 'ycbcr.png'])
end
