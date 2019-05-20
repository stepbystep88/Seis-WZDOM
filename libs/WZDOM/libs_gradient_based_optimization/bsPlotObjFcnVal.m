function [frame] = bsPlotObjFcnVal(fid, iter, fval)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code plots the objective function value at each iteration
%
% Programmed by: Bin She (Email: bin.stepbystep@gmail.com)
% Programming dates: May 2019
% -------------------------------------------------------------------------
% Input
% 
% fid: the figure handle
% 
% iter: the iteration number
%
% fval: objective function vlaue at the current iteration
% -------------------------------------------------------------------------
% Output
%
% frame: the current frame
%
% -------------------------------------------------------------------------

    figure(fid);
    plot(iter, fval, 'ks', 'linewidth', 2); hold on;
    drawnow
    
    if iter == 1
        xlabel('Iteration number');
        ylabel('Objective function value');
        bsPlotSetDefault(bsGetDefaultPlotSet());
    end
    
    frame = getframe(gcf);
end