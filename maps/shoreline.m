function shoreline( filename )
%DESCRIPTION:
%   �����������ص�ԭʼ������������SMS�ɶ���.cst�ļ�
%   shoreline.m�ļ�����дcoast01.dat
%   shorelineBinary.m������ȡ�����ư�������
% INPUT:
%   ԭʼ�ļ���,�ַ���ʽ
%
% EXAMPLE USAGE:
%   shoreline('dist_to_GSHHG_v2.3.4_1m.nc');

global caseInfo

x=ncread(fullfile(pwd,'raw_data',filename),'lon');
y=ncread(fullfile(pwd,'raw_data',filename),'lat');
z=ncread(fullfile(pwd,'raw_data',filename),'z');
%z(z~=0)=nan;
xx=find(x>=caseInfo.lon(1)&x<=caseInfo.lon(2));
yy=find(y>=caseInfo.lat(1)&y<=caseInfo.lat(2));
h=contour(x(xx),y(yy),flipud(rot90(z(xx,yy))),[0 0]);
saveas(gcf,fullfile(pwd,'output','��������.png'))
close all
fid = fopen(fullfile(pwd,'output','coast01.dat'),'w');
col = 1; parCol = size(h,2);
while(col<parCol)
    coastlineNum = h(2,col);
    temp = col+1 : col + coastlineNum;
    fprintf(fid,'%s %s\n','nan','nan');
    for j = temp;
        fprintf(fid,'%f %f\n',h(1,j),h(2,j));
    end 
    col = col + coastlineNum+1;
end
fprintf(fid,'%s %s\n','nan','nan');

end

