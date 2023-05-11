% Fourier convention shift function
% (shift along 3 spatial dimensions, at each time)

function [A] = fftshift2d(A)

A = fftshift(fftshift(A,1),2);

end