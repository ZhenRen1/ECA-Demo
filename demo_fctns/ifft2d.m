% Fourier transform function
% (transform along 2 spatial dimensions, at each time)

function [A] = ifft2d(A)

A = fftshift2d(ifft(ifft(ifftshift2d(A),[],1),[],2));

end