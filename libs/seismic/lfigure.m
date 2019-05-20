function figure_handle=lfigure
% Function creates a figure window in landscape mode
% Written by: E. R.: March 2000
% Last updated: August 16, 2003: Use S4M
%
%            figure_handle=lfigure
% OUTPUT
% figure_handle  figure handle (optional)

global S4M

if isempty(S4M)
   presets
   S4M.script='';
   S4M.plot_label='';
end

figure_handle=figure;
set(figure_handle,'Position',S4M.landscape,'PaperPosition',[0.8 0.8 10.0 6.35], ...
        'PaperOrientation','landscape')
figure(figure_handle)

set(gca,'Position',[0.10,0.11,0.83,0.72],'FontName',S4M.font_name);   % Location of axes on figure (relative coordinates)

if nargout == 0
   clear figure_handle
end
