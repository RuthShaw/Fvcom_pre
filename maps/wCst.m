function wCst
%DESCRIPTION:
%   制作SMS岸线输入数据.cst
% INPUT:
%   无
% EXAMPLE USAGE:
%   wCst('dist_to_GSHHG_v2.3.4_1m.nc');

data2 = load(fullfile(pwd,'output','coast01.dat'));
[data(:,1), data(:,2)] = myProject(data2(:,1),data2(:,2), 'forward');
N = size(data,1);
if data(N,1) <= inf
    data = cat(1,data,[nan nan]);
end

fid = fopen(fullfile(pwd,'output','coast.cst'),'w');
fprintf(fid,'%s\n','COAST');
index_nan = find( ~(data(:,1) <= inf) );
num = length(index_nan)-1;
fprintf(fid,'%i\n',num);

for i = 1:num 
    num_segment = index_nan(i+1)-index_nan(i)-1;
    fprintf(fid,'%i  ',num_segment);
    fprintf(fid,'%i\n',(data(index_nan(i)+1,1) == data(index_nan(i+1)-1,1) & ...
         data(index_nan(i)+1,2) == data(index_nan(i+1)-1,2)));
    for j = 1:num_segment
        fprintf(fid,'%f %f\n',data(index_nan(i)+j,1),data(index_nan(i)+j,2));
    end  
end
fclose(fid);
