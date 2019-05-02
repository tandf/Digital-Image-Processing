imRGB = imread('..\data\bobby_DSLR2.tif');
Show(1, imRGB)
imLAB = rgb2lab(imRGB);
degreeOfSmoothing = 10;
spatialSigma = 3;
nFigure = 1;
for k = 1:20
    fprintf('%d,',k)
    imLAB = imbilatfilt(imLAB,degreeOfSmoothing,spatialSigma);
    if k==1 || mod(k,5)==0
        smoothedRBG = lab2rgb(imLAB,'Out','uint8');
        nFigure = nFigure + 1;
        Show(nFigure, smoothedRBG, num2str(k));
    end
end
