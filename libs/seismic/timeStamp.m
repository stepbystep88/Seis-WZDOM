function timeStamp
% Function creates time stamp and possibly a label on plot
% Time used is in S4M.time, label is in S4M.plot_label.
%      default (value of global variable S4M.time (if given) or result of call to datum
% Written by: E. R.: November 4, 2005
% Last updated: November 28, 2005: Slight change in x-location of the 
%                                  time-stamp annotation
%
%           timeStamp
% INPUT
% location  location of time stamp. Possible values are "top" and 'bottom'.
%           Default: 'bottom'

global S4M

if isempty(S4M)
   presets
end

figure_handle=gcf;
axis_handle=gca;	% Save handle to current axes

if strcmp(get(figure_handle,'PaperOrientation'),'landscape')
   time_stamp_l('bottom')
else
   time_stamp_p('bottom')
end
 
axes(axis_handle);	% Make original axes the current axes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function time_stamp_l(location)
% Function creates time stamp and possibly a label on plot
% Time used is in S4M.time, label is in S4M.plot_label.
%      default (value of global variable S4M.time (if given) or result of call to datum
% Written by: E. R.: 1995
% Last updated: September 13, 2004: change handle visibilty to "off"
%
%           time_stamp(location)
% INPUT
% location  location of time stamp. Possible values are "top" and 'bottom'.
%           Default: 'bottom'

global PARAMS4PROJECT S4M WF 

h=axes('Position',[0 0 1 1],'Visible','off');

if nargin == 0
   location='bottom';
end

%  	Add date/time stamp  
xt=0.80;
if strcmp(location,'top')
   yt=0.95; 
else
   yt=0.02; 
end
text(xt,yt,S4M.time,'FontSize',7); 

xt=0.1;

txt=strrep(S4M.plot_label,'_','\_');

if ~isempty(PARAMS4PROJECT)  & isfield(PARAMS4PROJECT,'name')  &  ~isempty(txt)
   txt={strrep(PARAMS4PROJECT.name,'_','\_');txt};

elseif ~isempty(WF) & ~isempty(txt)
   txt={strrep(WF.name,'_','\_');txt};
end

if strcmp(location,'top')
   yt=0.95;
else
   yt=0.027;
end

text(xt,yt,txt,'FontSize',6);

set(h,'HandleVisibility','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function time_stamp_p(location)
% Function creates time stamp and possibly program stamp on plot
%      date   date for time stamp (e.g. result of call to datum)
%      default (value of global variable TIME (if given) or result of call to datum
%      if global string variable PROGRAM is also set, the string PROGRAM is also 
%      written to the plot
%  Last updated: September 13, 2004: change handle visibilty to "off"

global PARAMS4PROJECT S4M WF

h=axes('Position',[0 0 1 1],'Visible','off');
if nargin == 0
   location='bottom';
end

%  Add date/time stamp  
xt=0.75;
if strcmp(location,'top')
   yt=0.94; 
else
   yt=0.02; 
end
text(xt,yt,S4M.time,'FontSize',6); 

txt=strrep(S4M.plot_label,'_','\_');
if ~isempty(PARAMS4PROJECT) & isfield(PARAMS4PROJECT,'name') & ~isempty(txt)
   txt={strrep(PARAMS4PROJECT.name,'_','\_');txt};

elseif ~isempty(WF) & ~isempty(txt)
   txt={strrep(WF.name,'_','\_');txt};
end

xt=0.09;
if strcmp(location,'top')
   yt=0.94;
else
   yt=0.02;
end

text(xt,yt,txt,'FontSize',6); 

set(h,'HandleVisibility','off');
