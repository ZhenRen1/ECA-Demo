function [con,maxcon] = EMM(t,varargin)
t = t/1000; %convert from milliseconds to seconds
sampEMMp = {1.066471267, 0.168860905, 6.10530657};
% sampEMMp = {1.066471267, 0.0068860905, 6.10530657};
% SD = {0.48,0.1,3};
% sampEMMp = {1.566471267, 0.068860905, 6.10530657};

p = inputParser;
p.KeepUnmatched = true;
addParameter(p,'EMMp',sampEMMp)

parse(p,varargin{:})
EMMp = p.Results.EMMp;
% EMMp = num2cell(cell2mat(p.Results.EMMp)+randn(size(p.Results.EMMp)).*cell2mat(SD));

Sig = EMMp{1}.*(1-exp(-EMMp{2}.*(t-EMMp{3}))).*(t > EMMp{3});
con = sig2con_EMM(Sig);
% con = (EMMp{1}.*(EMMp{2}.*(t-EMMp{3})).^2)./(1+(EMMp{2}.*(t-EMMp{3})).^2).*(t > EMMp{3});
maxSig = max(EMMp{1}(:));
maxcon = sig2con_EMM(maxSig);
end