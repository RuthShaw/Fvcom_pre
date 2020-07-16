%% read cockburn_cor.dat
clear all;clc;close all
filename = 'cockburn_cor.dat';
fid = fopen(filename,'r');
assert(fid >= 0, 'file: %s does not exist.', filename)

reading = true;

lin = fgetl(fid);
lin = strtrim(lin);
switch lin(1:2)
    case 'No'
        tmp = regexp(lin, ' = ', 'split');
        nObcNodes = str2double(tmp(end));
        clear tmp
        
end
 
C = textscan(fid, '%f %f %f', nObcNodes);
tri(:, 1) = C{1};
tri(:, 2) = C{2};
tri(:, 3) = C{3}*0+0;

fclose(fid);


%% write cockburn_cor_new.dat
bname = 'cockburn_cor_all0.dat';

fprintf('writing FVCOM coriolis file %s\n',bname);
fid = fopen(bname,'w');
fprintf(fid,'Node Number = %d\n',nObcNodes);
for i=1:nObcNodes
  fprintf(fid,'%f %f %f\n',tri(i,1),tri(i,2),tri(i,3));
end;
fclose(fid);

%% specify areas
load('wannei.mat')
bname = 'cockburn_cor_wannei0.dat';
clear tri
tri(:, 1) = C{1};
tri(:, 2) = C{2};
tri(:, 3) = C{3};
for i = wannei(:,3)
    tri(i, 3) = 0;
end
fprintf('writing FVCOM coriolis file %s\n',bname);
fid = fopen(bname,'w');
fprintf(fid,'Node Number = %d\n',nObcNodes);
for i=1:nObcNodes
  fprintf(fid,'%f %f %f\n',tri(i,1),tri(i,2),tri(i,3));
end;
fclose(fid);

