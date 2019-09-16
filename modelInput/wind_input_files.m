%wind input files
matlabrc
close all
clc

global ftbverbose
ftbverbose = 1; % be noisy

addpath('/Users/ruthshaw/Documents/MATLAB/toolbox/fvcom-toolbox-master2/fvcom-toolbox-master/utilities')
addpath('/Users/ruthshaw/Documents/MATLAB/toolbox/fvcom-toolbox-master2/fvcom-toolbox-master/fvcom_prepro')
addpath('/Users/ruthshaw/Documents/MATLAB/toolbox/air_sea')
%conf.obc_tides.dirTMD = 'G:/tools/matlab/tmd_toolbox/';
%addpath(conf.obc_tides.dirTMD)
%addpath(fullfile(conf.obc_tides.dirTMD, 'FUNCTIONS'))
% Which system am I using?
% CHANGE THESE TO YOUR OWN DIRECTORIES
if isunix       % Unix?
    basedir = '/Users/ruthshaw/Documents/doing/FVCOM/';
else     % Or Windows?
    basedir = '/Users/ruthshaw/Documents/doing/FVCOM/';    % Insert your mapped drive to \\store\login\your_name here
end

% Base folder location - where do you want your forcing input files to end
% up?
inputConf.base = [basedir,'eljobc/'];
inputConf.outbase = [inputConf.base,'input/'];

% Which version of FVCOM are we using (for the forcing file formats)?
inputConf.FVCOM_version = '4.0.1';

% Case name for the model inputs and outputs
% Change this to whatever you want
inputConf.casename = 'nscs';
% output coordinates (FVCOM only likes cartesian at the moment)
inputConf.coordType = 'spherical'; % 'spherical' or 'cartesian'
%my projection
%m_proj('UTM','longitude',[100,130],'latitude',[12,30],'zone',50,'hemisphere','north','ellipsoid','wgs84')

Mobj = read_sms_mesh(...
    '2dm', fullfile(inputConf.base, 'raw_data', [inputConf.casename, '.2dm']),...
    'bath', fullfile(inputConf.base, 'raw_data', [inputConf.casename, '_dep.dat']),...
    'coordinate', inputConf.coordType, 'addCoriolis', true,...
    'project',true);
Mobj2 = read_sms_mesh(...
    '2dm', fullfile(inputConf.base, 'raw_data', [inputConf.casename, '.2dm']),...
    'bath', fullfile(inputConf.base, 'raw_data', [inputConf.casename, '_dep.dat']),...
    'coordinate', inputConf.coordType, 'addCoriolis', true);
Mobj.lon=Mobj2.lon;Mobj.lat=Mobj2.lat;
%range
% make a timeframe
tbeg = greg2mjulian(2015,9,1,0,0,0);
tend = greg2mjulian(2015,10,10,0,0,0);

%nTimes = numel(data.time);

% time varying wind in m/s at 10-m above the water surface using NCEP 
forcing = get_NCEP_forcing(Mobj, [tbeg, tend], 'varlist', {'uwnd', 'vwnd'});
forcing.time = tbeg:1/2:tend;

[lon, lat]=meshgrid(forcing.lon, forcing.lat);
[forcing.x, forcing.y] = my_project(lon, lat, 'forward');
interpfields = {'uwnd', 'vwnd', 'time', 'lon', 'lat','x','y'};
forcing_interp = grid2fvcom(Mobj, interpfields, forcing,'add_elems',true);

% data.uwnd = forcing.uwnd;
% data.vwnd = forcing.vwnd;
%data.lon = forcing.lon;data.lon = forcing.lat;

%-----------------------------------------------------------------------------
% write output to time-varying, spatially constant FVCOM wind file 
%-----------------------------------------------------------------------------

write_FVCOM_forcing(Mobj, 'nscs', forcing_interp, 'test forcing', '3.1.0');

