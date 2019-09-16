matlabrc
close all
clc

%% basic infomation 
% <encoding name=??GBK??> 
global ftbverbose caseInfo

ftbverbose = 1; % be noisy

% 输入项目名
caseInfo.casename = 'cockburn';
    % Model time ([Y,M,D,h,m,s])

caseInfo.timezone = 0;
% 输入模式所需时间
caseInfo.modelYear = 2016;
caseInfo.startDate = [caseInfo.modelYear,1,01,00,00,00];
caseInfo.endDate = [caseInfo.modelYear+2,1,1,00,00,00];
% 输入模式所需经纬度范围
caseInfo.lat = [-34,-30];caseInfo.lon = [113.5,116];
caseInfo.basedir = pwd;


caseInfo.startDateUTC = datevec(datenum(caseInfo.startDate)-caseInfo.timezone/24);
caseInfo.endDateUTC = datevec(datenum(caseInfo.endDate)-caseInfo.timezone/24);

% 添加需要用到的程序包
addpath(fullfile(pwd,'utility'))
if isunix       % Unix?
    addpath('/Users/ruthshaw/Documents/MATLAB/toolbox/fvcom-toolbox-master2/fvcom-toolbox-master/utilities')
    addpath('/Users/ruthshaw/Documents/MATLAB/toolbox/fvcom-toolbox-master2/fvcom-toolbox-master/fvcom_prepro')
    addpath('/Users/ruthshaw/Documents/MATLAB/toolbox/air_sea')
    addpath('/Users/ruthshaw/Documents/MATLAB/toolbox/m_map')
    caseInfo.obc_tides.dirTMD = '/Users/ruthshaw/Documents/MATLAB/toolbox/tmd_toolbox';
else     % Or Windows?
%     下载地址为：https://github.com/pwcazenave/fvcom-toolbox
    addpath('F:/Atherine/toolbox/fvcom-toolbox-master2/fvcom-toolbox-master/utilities')
    addpath('F:/Atherine/toolbox/fvcom-toolbox-master2/fvcom-toolbox-master/fvcom_prepro/')
    %这个包好像没用到
%     下载地址为：https://github.com/sea-mat/air-sea
    addpath('F:/Atherine/toolbox/air_sea/')
%   下载地址为：https://www.eoas.ubc.ca/~rich/map.html
    addpath('F:/Atherine/toolbox/m_map')
%    下载地址为： https://www.esr.org/research/polar-tide-models/tmd-software/
    caseInfo.obc_tides.dirTMD = 'F:/Atherine/toolbox/tmd_toolbox/';   
end

addpath(caseInfo.obc_tides.dirTMD)
addpath(fullfile(caseInfo.obc_tides.dirTMD, 'FUNCTIONS'))

% Make the output directory if it doesn't exist
caseInfo.outputDir = fullfile(pwd,caseInfo.casename,'INDIR');
if exist(caseInfo.casename,'dir')~=7
    mkdir(caseInfo.outputDir)
    mkdir(fullfile(pwd,caseInfo.casename,'OUTDIR'))
end

%% maps
cd maps
% coast lines
if exist(fullfile(pwd,'output','coast01.dat'),'file')~=2
    %shoreline.m??????????coast01.dat
    shoreline('dist_to_GSHHG_v2.3.4_1m.nc')
end
%??????????????????????????????????????????????./utility????????myProject.m??????
if exist(fullfile(pwd,'output','coast.cst'),'file')~=2
    %????SMS????????????.cst
    wCst2
    
end
if exist(fullfile(pwd,'output','topo.dat'),'file')~=2
    %??????????????????SMS??????????????????
    topo('ETOPO2v2c_f4.nc','topo2.dat');
end
if exist(fullfile(pwd,'output',[caseInfo.casename,'_dep.dat']),'file')~=2
    wDep;
end
fclose('all');
copyfile(fullfile(pwd,'output',[caseInfo.casename,'.2dm']),caseInfo.outputDir);
copyfile(fullfile(pwd,'output',[caseInfo.casename,'_dep.dat']),caseInfo.outputDir);

%% model input
cd ../modelInput/
    %??????????
createFiles('wind',false)

copyfile(fullfile(pwd,'output',[caseInfo.casename,'_dep.dat']),caseInfo.outputDir);
copyfile(fullfile(pwd,'output',[caseInfo.casename,'_cor.dat']),caseInfo.outputDir);
copyfile(fullfile(pwd,'output',[caseInfo.casename,'_elevtide.nc']),caseInfo.outputDir);
copyfile(fullfile(pwd,'output',[caseInfo.casename,'_grd.dat']),caseInfo.outputDir);
copyfile(fullfile(pwd,'output',[caseInfo.casename,'_obc.dat']),caseInfo.outputDir);
copyfile(fullfile(pwd,'output',[caseInfo.casename,'_spg.dat']),caseInfo.outputDir);
copyfile(fullfile(pwd,'output','sigma.dat'),caseInfo.outputDir);

    %wind

%% model configure
% Description of second code block
a=2;

%% ????????????????????
