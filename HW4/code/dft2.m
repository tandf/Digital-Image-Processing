function F = dft2(img)
    temp = zeros(size(img));
    F = zeros(size(img));
    [n, m] = size(img);

    for i = (1:m)
        temp(:,i) = dft(img(:,i));
    end

    for j = (1:n)
        F(j,:) = dft(temp(j,:)');
    end
end

function [F] = dft(input)
    % 1-D dft
    N=length(input); 
    n = 0:1:N-1;
    k = 0:1:N-1;
    WN = exp(-1j*2*pi/N);
    nk = n'*k;
    WNnk = WN .^ nk;
    F = (WNnk*input); 
end
