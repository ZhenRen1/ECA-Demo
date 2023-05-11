%convert signal to concentration (EMM only)
function [con] = sig2con_EMM(S,varargin)
p = inputParser;

addParameter(p,'FA',10*pi/180)
addParameter(p,'TR',3.2)
addParameter(p,'TE',1.6)

parse(p,varargin{:})

FA = p.Results.FA; %flip angle (rad)
TR = p.Results.TR; %repetition time (ms)

if FA > pi
    FA = FA*pi/180; %ensures FA is expressed in radians and not degrees
end

r1 = 3.4/1000; %(mmol*ms)^-1
R10 = 1/1.8/1000; %inverse native T1 (ms^-1)
% R1 = R10 + r1*con; %ms^-1
% T1 = 1./R1; %T1 relaxation time (ms)
% T1(R1 == 0) = 0;
T10 = 1/R10;
% S_c = exp(-TR./T1);
S_c0 = exp(-TR./T10);
% S_c(T1 == 0) = 0;
Omega = TR*r1;
% T2_st = 250; %relaxation time (ms)
% TE = 1.6; %echo time (ms)
% p = 1;
D = 1-S_c0;
B = -S_c0*(cos(FA)-1);

con = 1/Omega*log((S*D*cos(FA)*S_c0 - B)./(S*D-B));

end