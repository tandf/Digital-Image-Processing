close all
I = imread('..\data\Fig0326(a)(embedded_square_noisy_512).tif');
figure(1),imshow(I),set(gcf,'name','Original');

%% Global histogram equalization
tic
J1 = histeq(I);
time1 = toc
figure(2),imshow(J1),set(gcf,'name','Global histogram equalization');

%% Local histogram equalization (pixelwise)
if 0
    tic
    n = 1;% neighborhood size (2*n+1)*(2*n+1)
    J2 = I;
    [H, W] = size(I);
    for r = 1+n:H-n
        for c = 1+n:W-n
            local_image = I(r-n:r+n,c-n:c+n);
            new_local_image = histeq(local_image);
            J2(r,c) = new_local_image(n+1,n+1);
        end
        % Show progress
%         clc,fprintf('%d%%',round(100*r/H));
    end
    time2 = toc
    figure(3),imshow(J2),set(gcf,'name','Pixelwise local histogram equalization');
end

%% Local histogram equalization (blockwise)
if 1
    tic
    h = @(block_struct) histeq(block_struct.data);
    J3 = blockproc(I,[10 10],h);
    time3 = toc
    figure(4),imshow(J3),set(gcf,'name','Blockwise local histogram equalization');
end
