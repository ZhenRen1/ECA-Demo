% Fourier transform function
% (transform along 3 spatial dimensions, at each time)

function [A] = fft2d(A)

A = fftshift2d(fft(fft(ifftshift2d(A),[],1),[],2));

end