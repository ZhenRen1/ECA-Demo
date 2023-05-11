function [vmap] = vessel_analysis(DYN,MASK,time,NPRE)
im_size = size(DYN);
N = find(MASK==1); % find vessel voxels
baseline = mean(DYN(:,:,:,1:NPRE),4);
baseline = repmat(baseline,1,1,1,im_size(4));
DYN = (DYN-baseline)./baseline;
DYN = reshape(DYN,[],im_size(4));
DYN(isnan(DYN)) = 0;
DYN(DYN == inf) = 0;
% Vmap_M1_161410016 = zeros(size(DYN,1),4); % prepare a matrix for storing the vessel map, M1 exponential model
vmap = zeros(size(DYN,1),8); % modified model
start_frame = 1;
% fitting
for i = 1:length(N)
%     Vmap_M1_161410016(N(i),:) = FitEMMuptake(time,squeeze(DYN(N(i),start_frame:end)));
%     vmap(N(i),:) = FitModEMMuptake(time,squeeze(DYN(N(i),start_frame:end)));
    %% Lin+BiExp fit
    vmap(N(i),:) = FitLinBiExp(time,squeeze(DYN(N(i),start_frame:end)));
    
    %% Mod+Exp fit
%     vmap(N(i),:) = FitModExp(time,squeeze(DYN(N(i),start_frame:end)));
end

% Vmap_M1_161410016 = reshape(Vmap_M1_161410016,size(DYN161410016,1),size(DYN161410016,2),size(DYN161410016,3),[]);
vmap = reshape(vmap,im_size(1),im_size(2),im_size(3),[]);
end