close all
I = cell(1,6);
I{1} = imread('..\data\Fig0333(a)(test_pattern_blurring_orig).tif');
sizes = [3 5 9 15 35];

for i = 1:5
tic
I{i+1} = imfilter(I{1},ones(sizes(i),sizes(i))/(sizes(i)*sizes(i)));
toc
end

figure(1),clf
ax = zeros(1,6);
for i = 1:6
    ax(i)=subplot(2,3,i);imshow(I{i});
end
linkaxes(ax);