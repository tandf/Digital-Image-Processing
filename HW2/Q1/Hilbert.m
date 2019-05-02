function y = Hilbert(n, method)
if method == 1
    y = Hilbert_for(n);
elseif method == 2
    y = Hilbert_vector(n);
else
    y = Hilbert_mex(n);
end
end

function value = Hilbert_for(n)
[y, x] = meshgrid(1:n, 1:n);
value = 1 ./ (y + x - 1);
end

function value = Hilbert_vector(n)
value = zeros(n, n);
for y = 1:n
    for x = 1:n
        value(x, y) = 1 / (y + x -1);
    end
end
end
