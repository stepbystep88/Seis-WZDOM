function figure_handle=pfigure
% Function creates a figure window in portrait mode
% Written by: E. R.: March 2000
% Last updated: August 16, 2003: Use S4M
%
%         figure_handle=pfigure
% OUTPUT
% figure_handle  figure handle (optional)

global S4M

if isempty(S4M)
   presets
   S4M.script='';
   S4M.plot_label='';
end

figure_handle=figure;
set(figure_handle,'Position',S4M.portrait,'PaperPosition',[0.8 0.5 6.5,8.0], ...
        'PaperOrientation','portrait','Color','w', ...
        'InvertHardcopy',S4M.invert_hardcopy);             
figure(figure_handle)

set(gca,'Position',[0.14,0.085,0.75,0.79],'FontName',S4M.font_name);

if nargout == 0
   clear figure_handle
end
