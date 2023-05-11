% This function computes the ky- and kx- coordinates of a Cartesian
% sampling scheme for real kspace data from Fan. path.Ky and path.
% Kx are nRO x nPE double matrices with
% each column representing a single pulse(?) of the pulse sequence. e.g.
% Here, one column corresponds to one horizontal path across the k-space
% plane. The sampling density is uniform with respect to both ky- and kx-
% directions, but the densities in the two directions need not be
% identical.
%
% The output is passed on to the k-space signal sampling module as an
% input.
% 
%
% Inputs
%    FOV (integer vector) target FOV of the reconstructed image
%    Res (integer vector) target resolution of the recontructed image
%    varargin = [Gyro, AcqPars]
%        Gyro (double scalar)
%        AcqPars (struct)
%
% Outputs
%    path (struct)
%        Type (character) 'Cart'
%        Ky (double 2D array) ky-coordinates of Cartesian sampling path
%        Kx (double 2D array) kx-coordinates of Cartesian sampling path
%        Time (double 2D array) time-coordinates of Cartesian sampling path

function [Path,AcqPars] = Path_realks(AcqPars,varargin)
StartTime = 0;
if nargin > 1
    StartTime = varargin{1};
end

% Compute k-coordinates of Cartesian sampling path:
FOV = AcqPars.FOV;

% Compute K-coordinate grid of Cartesian sampling path:
kdims = FOV; %nPE_y, nRO, nPE_z

maxKx = 1/2;
Gyro = 42580; %gyromagnetic ratio (kHz/T)

TR = AcqPars.TR; %repetition time (milliseconds between each line acquisition)
TE = AcqPars.TE; %echo time (milliseconds from center to edge of k-space and back along readout dimension)
TS = maxKx / (Gyro * 10^(-5)); %time spent reading out each line (ms)
% TS = .5 / (Gyro * 10^(-5)); %time spent reading out each line (ms)
TDP = TE - TS / 2; %de-phasing time (ms)

tRO = TDP + TS * (1:kdims(2)) / kdims(2); %kdims(2) = nRO

% Compute time stamps according to aquisition parameters:
Path = zeros(kdims);
tPE_y = TR * (0:(kdims(1)-1)); %kdims(1) = nPE_y
tPE_z = fix(TR/kdims(3))*(fix((0:(kdims(3)-1))/2)+mod(0:(kdims(3)-1),2)*ceil(kdims(3)/2)); 
%kdims(3) = nPE_z; we assume that de-phasing in y-encoding also spoils z-phasing

for i=1:kdims(3)
    Path(:,:,i) = ones(kdims(1),1) * tRO + tPE_y' * ones(1,kdims(2)) + tPE_z(i);
end
last_slice = Path(:,:,end-1);
path_length = last_slice(end)-StartTime;

scale_factor = AcqPars.onescantime/path_length;
Path = Path*scale_factor;


assert(isequal(kdims,FOV,size(Path)),...
    'mismatched dimensions in k-space sampling path')

[Path] = ReplicatePath(Path,AcqPars,StartTime);

end

function [Path] = ReplicatePath(Path,AP,StartTime)

if isfield(AP,'nscan')
    repnum = AP.nscan;
elseif isfield(AP,'totalscantime') && isfield(AP,'onescantime')
    repnum = floor(AP.totalscantime/AP.onescantime);
else
    error('acquisition parameters do not specify total scan time')
end

p1 = Path;

for i=2:repnum
    p_new = p1 + max(Path(:)) - StartTime;
    Path(:,:,:,i) = p_new;
end
end