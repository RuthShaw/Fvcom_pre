function wDep
%DESCRIPTION:
%   生成casename_dep.dat文件
% INPUT:
%   无
% EXAMPLE USAGE:
%   wDep;
global caseInfo

% %% write casename_grd.dat
% fid1 = fopen('work8.geo','r');
% fid2 = fopen('ecs_grd.dat','w');
% while 1
%     tline = fgets(fid1);
%     if ~ischar(tline), break, end
%     if tline(1:2) == 'GE'
%         fprintf(fid2,'%s %s %s %s\n',tline(4:8),tline(10:14),tline(22:26),tline(34:38));
%     end
%     if tline(1:3) == 'GNN'
%         fprintf(fid2,'%s %s %s\n',tline(5:9),tline(15:30),tline(36:51));
%     end
% end
% fclose('all');

%% write casename_dep.dat
fid1 = fopen(fullfile(pwd,'output',[caseInfo.casename,'.pts']),'r');
fid2 = fopen(fullfile(pwd,'output',[caseInfo.casename,'_dep.dat']),'w');
tmp = fgetl(fid1);
data2 = fscanf(fid1,'%f %f %f',[3 inf]);

[data(1,:),data(2,:)] = myProject(data2(1,:),data2(2,:),'reverse');
data(3,:) = data2(3,:);

fprintf(fid2,'Node Number = %d\n',size(data,2));
for i = 1:size(data,2)
    fprintf(fid2,'%f %f %f\n',data(1,i),data(2,i),data(3,i));
end
fclose('all');
