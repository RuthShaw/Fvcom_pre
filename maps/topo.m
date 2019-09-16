function topo(scrname,filename)
%DESCRIPTION:
%   读取地形数据，生成SMS可使用的地形数据。

% INPUT:
%   scrname：原始海底地形nc文件
%   filename：生成的.dat文件名

% EXAMPLE USAGE:
%   topo('ETOPO2v2c_f4.nc','topo.dat');
global caseInfo

lon1 = caseInfo.lon(1);
lon2 = caseInfo.lon(2);
lat1 = caseInfo.lat(1);
lat2 = caseInfo.lat(2);
f = fullfile(pwd,'raw_data',scrname);

x = ncread(f,'x');
y = ncread(f,'y');
%[x,y] = myProject(xx,yy, 'forward');
index_lon = find(x >= lon1 & x <= lon2);
index_lat = find(y >= lat1 & y <= lat2);
temp = [index_lon(1),index_lat(1)];temp2 = [size(index_lon,1),size(index_lat,1)]; 
z = ncread(f,'z',temp,temp2);

fid = fopen(fullfile(pwd,'output',filename), 'w');
temp1 = length(index_lon);temp2 = length(index_lat);
for i = 1:temp1
    for j = 1:temp2
        if z(i,j) < 0
            %[xx,yy]=myProject(x(index_lon(i)), y(index_lat(j)),'forward');
            xx = x(index_lon(i));yy = y(index_lat(j));
            fprintf(fid, '%f %f %f\n',xx,yy, -z(i,j));
        end
    end
end
fclose(fid);
