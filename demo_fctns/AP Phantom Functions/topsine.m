function [sig] = topsine(A,maxf,x)

sig = A.*sin(50*A./(1/maxf+abs(x)));

end