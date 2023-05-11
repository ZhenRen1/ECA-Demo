% t is parameter time and should be given in units of milliseconds; however, time
% units in the AIF function parameters are evaluated in minutes, so 't' is
% re-scaled within the function (t = t/60).

function [con,maxcon] = AIF(t,varargin)
t = (t/6e4).*(t>0); %convert from seconds to minutes

% popG1p = {0.809,.04,.1005};  
% popG2p = {.33, .132,.365}; 
% popSp  = {1.05, .1985, 38.078, 0.783}; 
popG1p = {.809,.0563,.1705}; %A1,sigma1, T1
popG2p = {.33, .132,.365}; %A2, sigma2, T2
popSp  = {1.05, .1685, 38.078, 0.483}; % alpha, beta, s, tao
def_norm = false;

p = inputParser;
p.KeepUnmatched = true;
addParameter(p,'Sp',popSp)
addParameter(p,'G1p',popG1p)
addParameter(p,'G2p',popG2p)
addParameter(p,'norm',def_norm)

parse(p,varargin{:})
% vary the parameter under SD
% SpSD = {0.017,0.0056,16.78,0.015};
% G1pSD = {0.044,0.0011,0.00073};
% G2pSD = {0.04,0.021,0.028};
Sp = p.Results.Sp;
G1p = p.Results.G1p;
G2p = p.Results.G2p;
% Sp = num2cell(cell2mat(p.Results.Sp)+randn(size(p.Results.Sp)).*cell2mat(SpSD));
% G1p = num2cell(cell2mat(p.Results.G1p)+randn(size(p.Results.G1p)).*cell2mat(G1pSD));
% G2p = num2cell(cell2mat(p.Results.G2p)+randn(size(p.Results.G2p)).*cell2mat(G2pSD));
norm = p.Results.norm;
con = Sp{1}.*exp(-Sp{2}.*t)./(1+exp(-Sp{3}.*(t-Sp{4})))...
    + G1p{1}./(G1p{2}.*sqrt(2*pi)) * exp(-(t-G1p{3}).^2./(2*G1p{2}.^2))...
    + G2p{1}./(G2p{2}.*sqrt(2*pi)) * exp(-(t-G2p{3}).^2./(2*G2p{2}.^2));
        
maxcon = Sp{1}*exp(-Sp{2}*G1p{3})./(1+exp(-Sp{3}*(G1p{3}-Sp{4})))...
    + G1p{1}/(G1p{2}*sqrt(2*pi)) * exp(-(G1p{3}-G1p{3}).^2/(2*G1p{2}^2))...
    + G2p{1}/(G2p{2}*sqrt(2*pi)) * exp(-(G1p{3}-G2p{3}).^2/(2*G2p{2}^2));
con0 = Sp{1}.*exp(-Sp{2}.*0)./(1+exp(-Sp{3}.*(0-Sp{4})))...
    + G1p{1}./(G1p{2}.*sqrt(2*pi)) * exp(-(0-G1p{3}).^2./(2*G1p{2}.^2))...
    + G2p{1}./(G2p{2}.*sqrt(2*pi)) * exp(-(0-G2p{3}).^2./(2*G2p{2}.^2));
con = con-con0;
if norm
    con = con/maxcon;
end

end