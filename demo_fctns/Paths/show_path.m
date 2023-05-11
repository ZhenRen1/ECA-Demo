function [h] = show_path(Path,time)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
nscan = floor(time/3500)+1;
S = size(Path(:,:,:,nscan));
time_gap = 250;
[x,y,z] = ndgrid(1:S(1),1:S(2),1:S(3));
s =Path(:,:,:,nscan);
% s1 = ones(S);
s1 = s.*(s< time+time_gap & s>=time);
s1(s1 == 0) = NaN;

figure
h=scatter3(x(:),y(:),z(:),321,s1(:),'.');
colorbar
axis equal
xlabel('ky')
ylabel('kx')
zlabel('kz')
end

