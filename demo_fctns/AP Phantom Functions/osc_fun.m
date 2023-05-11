function [sig] = osc_fun(A,a,b,x)

if b < 0
    sig = A.*sin(pi*a*x) + b*x + A - b*max(x);
else
    sig = A.*sin(2*pi*a*x) + b*x + A;
end

end