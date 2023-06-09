function [AcqPars] = make_AcqPars(Phant)
pdims = size(Phant.PhantomPars.Const_Image);

AcqPars.Resolution = ones(1,length(pdims));
AcqPars.nx = pdims(1);
AcqPars.ny = pdims(2);
AcqPars.nz = pdims(3);
AcqPars.FOV = pdims;

AcqPars.FlipAngle = 10*pi/180;

AcqPars.TR = 3.2;%3.2;
AcqPars.TE = 1.6;

AcqPars.randomseed = rng;

AcqPars.acqtimeres = 50;

AcqPars.totalscantime = 70000;%56000;
AcqPars.onescantime = 10000;%3500;
AcqPars.nscan = AcqPars.totalscantime/AcqPars.onescantime;
AcqPars.phantomtimeres = 50;

% AcqPars.stddev = Phant.PhantomPars.KspStdDev;
end