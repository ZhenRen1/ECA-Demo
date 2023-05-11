% Fourier convention shift function
% (shift along 3 spatial dimensions, at each time)

function [A] = ifftshift2d(A)

A = ifftshift(ifftshift(A,1),2);

end