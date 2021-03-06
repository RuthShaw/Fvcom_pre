function [out_east,out_north] = myProject(in_east,in_north,direction) 

% Sample user-defined projection and inverse projection of (lon,lat) to (x,y) 
% Copy to my_project (not a member of the toolbox) and modify to suite you
%
% function [out_east,out_north] = my_project(in_east,in_north,direction) 
%
% DESCRIPTION:
%    Define projections between geographical and Euclidean coordinates 
%
% INPUT: 
%   in_east   = 1D vector containing longitude (forward) x (reverse)
%   in_north  = 1D vector containing latitude  (forward) y (reverse)
%   direction = ['forward' ;  'inverse']
%           
% OUTPUT:
%   (lon,lat) or (x,y) depending on choice of forward or reverse projection
%
% EXAMPLE USAGE
%    [lon,lat] = myProject(x,y,'reverse') 
%
% Author(s):  
%    Geoff Cowles (University of Massachusetts Dartmouth)
%
% Revision history
%   
%==============================================================================

%subname = 'my_project';
%fprintf('\n')
%fprintf(['begin : ' subname '\n'])

%------------------------------------------------------------------------------
% Parse input arguments
%------------------------------------------------------------------------------
global caseInfo

ProjectDirection = 'forward';

if(direction == 'forward')
	ProjectDirection = 'forward';
        lon = in_east;
        lat = in_north;
else
	ProjectDirection = 'inverse';
        x = in_east;
        y = in_north;
end;



%------------------------------------------------------------------------------
% Perform the projection:  USER DEFINED 
% Example:  project/inverse project to state plane 1802
%------------------------------------------------------------------------------

%if(ProjectDirection == 'forward')
%	fprintf('Projecting from (lon,lat) to (x,y)\n');
%	[x,y] = sp_proj('1802','forward',lon,lat,'m');
%	
%else
%	fprintf('Inverse Projecting from (x,y) to (lon,lat)\n')
%	[lon,lat] = sp_proj('1802','inverse',x,y,'m');
%end;

%------------------------------------------------------------------------------
% Skagit, UTM, Zone 10 (see http://www.dmap.co.uk/utmworld.htm)
%------------------------------------------------------------------------------
[temp,temp,temp]=deg2utm(caseInfo.lat,caseInfo.lon);
caseInfo.UTMzone = (str2double(temp(1,1:2))+str2double(temp(2,1:2)))/2;
clear temp
latSpan=[caseInfo.lat(1)-1,caseInfo.lat(2)+2];
lonSpan=[caseInfo.lon(1)-3.5,caseInfo.lon(2)+6];
m_proj('UTM','longitude',lonSpan,'latitude',latSpan,'zone',caseInfo.UTMzone,'hemisphere','north','ellipsoid','wgs84')
%m_proj('UTM','longitude',caseInfo.lon,'latitude',caseInfo.lat,'zone',caseInfo.UTMzone,'hemisphere','north','ellipsoid','wgs84')
%m_proj get
%[x,y] = m_ll2xy(-122.530820 , 48.363114);
%fprintf('x %f y %f\n',x,y-1e7);
%fprintf('should be 534752, 5356766.\n')
deltay = 1e7;

if(ProjectDirection == 'forward')
%	fprintf('Projecting from (lon,lat) to (x,y)\n');
    
	[x,y]=m_ll2xy(lon,lat); 
	y = y - deltay; %why?
else
%	fprintf('Inverse Projecting from (x,y) to (lon,lat)\n')
	[lon,lat]=m_xy2ll(x,y+deltay); 
end;


% set the output
if(ProjectDirection == 'forward')
  out_east = x;
  out_north = y;
else
  out_east = lon;
  out_north = lat;
end;

