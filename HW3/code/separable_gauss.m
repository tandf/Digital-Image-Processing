% 2018.10.2

twoDimensionalFilter = fspecial('gauss',41,10);
[isseparable,hcol,hrow] = isfilterseparable(twoDimensionalFilter);
hcol = -hcol;
hrow = -hrow;

I = imread('cameraman.tif');
I = im2double(I);

if 0
    % imfilter内部会特别处理可分离滤波器，为了测速度，改为不可分离的
    h = rand(size(twoDimensionalFilter));
    tic
    J = imfilter(I, h);
    toc
else
    % 速度并不慢
    tic
    J = imfilter(I, twoDimensionalFilter);
    toc
end

Show(1, I);
Show(2, J);

tic
J1 = imfilter(I, hcol);
J2 = imfilter(J1,hrow);
toc
Show(3, J1);
Show(4, J2);

diff = J2 - J;
mean(diff(:))