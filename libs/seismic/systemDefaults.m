function systemDefaults
% This function establishes defaults for parameters used by SeisLab
%
% Written by: E. R.: January 2000
% Last updated: April 14, 2006: Add CURVE mnemonic "Vrms"; bug fix in CURVE field

global S4M CURVES CURVE_TYPES TABLES 

%	Find name of the calling program and save it in variable SAM.script
temp=dbstack;  
if length(temp) > 2         % Presets is called from inside another macro/script
   [dummy,name]=fileparts(temp(3).name);
   S4M.script=name;
else
   S4M.script='';
end


S4M.alert=logical(1); 	    % Warning messages ("alerts") are printed.   
                            %    If S4M.alert == logical(0), then warnings 
                            %    are not printed
S4M.backgroundcolor=[0.9,0.9,0.9];  % Color of backgound in menus, etc.
S4M.case_sensitive=logical(0); % Header selection is case-insensitive (change 
                            %    from 0 to 1 to make it case-sensitive)
S4M.compiled=logical(0);    % If S4M.compiled==1 then the script is meant to
                            %    be used in compiled form
S4M.dd=6.1925;              % Distribution date
S4M.dualscreen=logical(0);  % Fields set to logical(0) if SeisLab does not run on
                            % a dual-screen system (see screen-size check below)
                            % It may need to be set manually in "presets"
S4M.experience=1;           % Level of experience (possible values -1, 0, 1)

S4M.font_name='Arial';      % Font for plot annotations
S4M.fontsize4params=9;      % Font size for parameter menus
S4M.fixed_font='FixedWidth';% Fixed-pitch font 

%               Color schemes for Graphical User Interfaces                           
S4M.gui.backgroundcolor=[0.8,0.8,0.8];  % Color of background in menus, etc.
S4M.gui.titlebackground=[0.8,0.8,0.9];  % Color of background of titles of UIC groups
S4M.gui.quitbackground=[0.8,0.8,0.9];   % Color of background of the Quit/Done/Cancel buttons
S4M.gui.buttonbackground=[0.8,0.8,0.8]; % Color of background of buttons
S4M.gui.color4tasks=[0.25,0.5,0.5];     % Color of background for tasks

S4M.history=logical(1);     % Create history field for seismic structures (set 
                            %    S4M.history to logical(0) to disable history
                            %    field)
S4M.history_level=1;        % Set the deepest level below the START_LEVEL from 
                            %    which to add entries into the history field

S4M.interactive=logical(0); % Use interactive features of macros where available;
                            %    this is normal for compiled code

S4M.invert_hardcopy='off';   % Invert figure background when printing 

v=tokens(version,'.');
S4M.matlab_version=str2double([v{1},'.',v{2}]);  % Matlab version number with major 			  
                            %    and minor release digits

S4M.log_step_error=0.005;   % Upper limit on the relative depth increment
                            % deviation for a log to still be considered uniformly
                            % sampled.

S4M.mymatlab=pwd;           % Directory with Matlab files (to be personalized
                            %    in "userDefaults")
S4M.name='SeisLab';         % Name for Figure windows in compiled version
S4M.no_units='n/a';         % Indicator that a quantity is dimensionless
S4M.ntr_wiggle2color=101;   % Number of traces for which the default seismic
                            % display switches from wiggle to color
S4M.pd=logical(1);          % PD version
S4M.plot_label=S4M.script;  % Label for the lower left corner of plots
S4M.pp_directory=fullfile('C:\Documents and Settings',getenv('USERNAME'),'My Documents','My Pictures');
                            % Directory for PowerPoint files
S4M.eps_directory=S4M.pp_directory;   % Directory for EPS files

temp=fileparts(which('systemDefaults'));
idx=strfind(temp,filesep);
S4M.myseislab=temp(1:idx(end)-1); % Directory with SeisLab files 

S4M.start_time=clock;       % Date and time as 6-element array       

S4M.start_level=size(dbstack,1);  % Set the level relative which to count the level 
                            %   of a function to determine if it can make an entry
			    %   into the history field.
S4M.time=datestr(now,0);    % Date and time as string
S4M.title=S4M.name;         % Title in figures and dialogs

S4M.seislab_version='2.01'; % SeisLab version
			    %   and minor release digits

%	GUI colors (deprecated)
S4M.quitbackground= [0.8,0.8,0.9];
S4M.titlebackground=[0.8,0.8,0.9];
S4M.backgroundcolor=[0.8,0.8,0.8];


%       Should be overridden by user-specific files in m-file "userDefaults.m"
S4M.seismic_path=tempdir;   % Path to seismic data with extension "sgy" (starting point for interactive data selection)
S4M.log_path=tempdir;       % Path to log data  with extension "log" (starting point for interactive data selection)
S4M.mat_path=tempdir;       % Path to mat-files with extension "mat"
S4M.table_path=tempdir;     % Path to table data  with extension "tbl" (starting point for interactive data selection)
S4M.default_path=tempdir;   % Path for all other files


if S4M.matlab_version >= 7
%   feature('jitallow','structs','off'); % Fix bug in Matlab Version 7
end

if S4M.matlab_version < 6.5
   S4M.interactive=logical(0); 
                               
else
   S4M.interactive=logical(1); % Use interactive features of macros where available;
                               % this is normal for compiled code
end

%       Default figure sizes/positions for portrait and landscape (based on screen size)
scrnsize=get(0,'ScreenSize');
if scrnsize(3) > 1600           % Dual screen?
   scrnsize(3)=scrnsize(3)/2;   
   S4M.dualscreeen=logical(1);
else
   S4M.dualscreen=logical(0);
end
bdwidth=5;            % Border width
topbdwidth=60;        % Top border width
xl=scrnsize(4)*0.75;  % Long side of figure
yl=xl*0.66;           % Shorter side of figure
x0=scrnsize(3)*0.15;
y0=scrnsize(4)-yl-5*(topbdwidth+bdwidth);
LANDSCAPE=round([x0,y0,xl*1.05,yl]);   % Figure position information for landscape format
                      % The four elements in vector LANDSCAPE are: x and y coordinates of the
                      % lower left corner and length and height of the figure (in pixels)
S4M.landscape=LANDSCAPE;

x0=scrnsize(3)*0.2;
y0=scrnsize(4)/8-0.5*(topbdwidth+bdwidth);
PORTRAIT=round([x0,y0,yl*1.0,xl*0.8]);    % Figure position information for portrait format
                      % The four elements in vector PORTRAIT are: x and y coordinates of the
                      % lower left corner and length and height of the figure (in pixels)
S4M.portrait=PORTRAIT;

%	Default mnemonics for tables
TABLES.owt='owt';	       % One-way time
TABLES.vint='vint';	       % Interval velocity
TABLES.vrms='vrms';            % RMS velocity
TABLES.twt='twt';	       % Two-way time

%       Default mnemonics for log curves
CURVES.aimp='aImp';            % Acoustic (pressure) impedance (rho*Vp)
CURVES.arefl='aRefl';          % Acoustic reflectivity
CURVES.bd='BS';                % Bit size
CURVES.cal='cal';              % Caliper
CURVES.delta='delta';          % Thomsen parameter
CURVES.depth='depth';          % Depth column (generally first column)
CURVES.drho='drho';            % Density correction
CURVES.dtp='DTp';              % Sonic log (Pressure)
CURVES.dts='DTs';              % Shear log
CURVES.epsilon='epsilon';      % Thomsen anisotropic parameter
CURVES.gr='GR';                % Gamma ray
CURVES.md='MD';                % Measured depth
CURVES.owt='OWT';              % One-way time
CURVES.phie='Phie';            % Effective porosity
CURVES.phit='Phit';            % Total porosity
CURVES.pr='PR';                % Poisson's ratio
CURVES.qp='Qp';                % Q for P-waves
CURVES.qs='Qs';                % Q for S-waves
CURVES.rho='rho';              % Density
CURVES.sbrine='SBrine';        % Brine saturation
CURVES.sgas='SGas';            % Gas saturation
CURVES.shc='SHC';              % Hydrocarbon saturation
CURVES.simp='sImp';            % Shear impedance (rho*Vs)
CURVES.soil='SOil';            % Oil saturation
CURVES.tvd='TVD';              % True vertical depth
CURVES.tvdbml='TVDbML';        % True vertical depth below mud line
CURVES.tvdbsd='TVDbSD';        % True vertical depth below seismic datum
CURVES.twt='TWT';              % Two-way time
CURVES.vclay='Vclay';          % Clay volume
CURVES.vshale='Vshale';        % Shale volume
CURVES.vint='Vint';            % Interval velocity
CURVES.vrms='Vrms';            % RMS velocity
CURVES.vp='Vp';                % Compressional velocity
CURVES.vs='Vs';                % Shear velocity

%       Lithology
CURVES.coal='coal';            % Logical for coal
CURVES.dolomite='dolomite';    % Logical for dolomite
CURVES.gas_sand='gas_sand';    % Logical for gas sand
CURVES.hc_sand='hc_sand';      % Logical for hydrocarbon sand
CURVES.limestone='limestone';  % Logical for limestone
CURVES.oil_sand='oil_sand';    % Logical for oil sand
CURVES.salt='salt';            % Logical for salt
CURVES.sand='sand';            % Logical for sand
CURVES.sh_sand='sh_sand';      % Logical for shaly sand
CURVES.shale='shale';          % Logical for shale
CURVES.volcanics='volcanics';  % Logical for volcanics
CURVES.wet_sand='wet_sand';    % Logical for wet sand

%       Pore pressure
CURVES.ep='EP';                % Excess pressure
CURVES.epg='EPG';              % Excess pressure gradient
CURVES.fp='FP';                % Fracture pressure
CURVES.fpg='FPG';              % Fracture pressure gradient
CURVES.obp='OBP';              % Overburden pressure
CURVES.obpg='OBPG';            % Overburden pressure gradient
CURVES.pp='PP';                % Pore pressure
CURVES.ppg='PPG';              % Pore pressure gradient

%	Curve types
% The 4 columns are:
%    Description
%    Units of measurements usually associated with it
%          "standard" curve mnemonic
%    Curve type
%    Indicator if a curve type is not related to the next in the list
%         ('P-sonic' is related to 'P-velocity' in the next row; hence the indicator is 0
%          'P-velocity' is not related to 'Density' in the next row; hence the indicator is 1)
CURVE_TYPES = ...
[{'P-sonic',      '|us/ft|us/m|',    'DTp',   'sonic',            0};
 {'P-velocity',   '|m/s|ft/s|',      'Vp',    'sonic velocity',   1};
 {'Density',      '|g/cm3|kg/m3|',   'rho',   'density',          1};
 {'Impedance',    '|imp|',           'Imp',   'impedance',        0};
 {'Reflection coefficients', '|n/a|','Refl',  'reflection coefficients',1};
 {'S-sonic',      '|us/ft|us/m|',    'DTs',   'shear sonic',      0};
 {'S-velocity',   '|m/s|ft/s|',      'Vs'   , 'shear velocity',   1};
 {'Clay volume',  '|fraction|%|',    'Vclay', 'clay volume',      1};
 {'Water saturation','|fraction|%|', 'Sbrine','brine saturation', 1};
 {'Gamma ray',    '|API|gamma|',     'GR',    'gamma ray',        1};
 {'Two-way time', '|s|ms|',          'TWT',   'two-way time',     0};
 {'One-way time', '|s|ms|',          'OWT',   'one-way time',     1};
 {'Depth',        '|ft|m|'           'depth', 'depth',            0}];

