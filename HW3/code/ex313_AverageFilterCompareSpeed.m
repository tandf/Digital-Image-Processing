close all
I = imread('..\data\Fig0333(a)(test_pattern_blurring_orig).tif');
sizes = 35:10:135;% filter size

times = zeros(length(sizes),2);
for i = 1:length(sizes)
    tic
    J = imfilter(I,ones(sizes(i),sizes(i))/(sizes(i)*sizes(i)));% imfilter内部会特别处理可分离滤波器
    times(i,1) = toc;
end

for i = 1:length(sizes)
    tic
    intImage = integralImage(I);
    avgH = integralKernel([1 1 sizes(i) sizes(i)], 1/(sizes(i)*sizes(i)));
    J = integralFilter(intImage, avgH);
    I = uint8(J);
    times(i,2) = toc;
end

times