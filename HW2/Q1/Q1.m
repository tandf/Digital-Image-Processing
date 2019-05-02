echo off
% 运行十次求平均时间

disp('for method')
T = 0;
for i = 1:10
tic; Hilbert(100, 1); T = toc + T;
end
disp(['N=100 time:' num2str(T/10)])
T = 0;
for i = 1:10
tic; Hilbert(1000, 1); T = toc + T;
end
disp(['N=1000 time:' num2str(T/10)])
T = 0;
for i = 1:10
tic; Hilbert(10000, 1); T = toc + T;
end
disp(['N=10000 time:' num2str(T/10)])

disp('vector method')
T = 0;
for i = 1:10
tic; Hilbert(100, 2); T = toc + T;
end
disp(['N=100 time:' num2str(T/10)])
T = 0;
for i = 1:10
tic; Hilbert(1000, 2); T = toc + T;
end
disp(['N=1000 time:' num2str(T/10)])
T = 0;
for i = 1:10
tic; Hilbert(10000, 2); T = toc + T;
end
disp(['N=10000 time:' num2str(T/10)])

disp('mex method')
T = 0;
for i = 1:10
tic; Hilbert(100, 3); T = toc + T;
end
disp(['N=100 time:' num2str(T/10)])
T = 0;
for i = 1:10
tic; Hilbert(1000, 3); T = toc + T;
end
disp(['N=1000 time:' num2str(T/10)])
T = 0;
for i = 1:10
tic; Hilbert(10000, 3); T = toc + T;
end
disp(['N=10000 time:' num2str(T/10)])

