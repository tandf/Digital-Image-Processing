I = imread('..\data\bobby_DSLR1.tif');
figure(1), imshow(I)
degreeOfSmoothing = 10;
spatialSigma = 3;
J = I;
for k = 1:5
    J = imbilatfilt(J,degreeOfSmoothing,spatialSigma);
end
figure(2), imshow(J)
