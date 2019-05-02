close all
I = cell(1,6);
I{1} = imread('..\data\Fig0333(a)(test_pattern_blurring_orig).tif');
sizes = [3 5 9 15 35];

intImage = integralImage(I{1});
for i = 1:5
tic
    avgH = integralKernel([1 1 sizes(i) sizes(i)], 1/(sizes(i)*sizes(i)));
    I{i+1} = integralFilter(intImage, avgH);
    I{i+1} = uint8(I{i+1});
toc
end

figure(1),clf
ax = zeros(1,6);
for i = 1:6
    ax(i)=subplot(2,3,i);imshow(I{i});
end
linkaxes(ax);