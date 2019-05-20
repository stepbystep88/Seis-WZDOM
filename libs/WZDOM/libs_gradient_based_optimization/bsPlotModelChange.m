function [frame, plotIds] = bsPlotModelChange(fid, plotIds, iter, x, xInit, Lb, Ub, trueX)
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
% x: objective function vlaue at the current iteration
% -------------------------------------------------------------------------
% Output
%
% frame: the current frame
%
% -------------------------------------------------------------------------

    figure(fid);
    n = length(x);
    
    legendStrs = {'Initial model', 'Estimated model'};
    
    if iter == 1
        plotIds(1) = plot(1:n, xInit, 'g--', 'linewidth', 2); hold on;
        plotIds(2) = plot(1:n, x, 'r', 'linewidth', 2); hold on;
        
        index = 3;
        if exist('trueX', 'var') && ~isempty(trueX)
            plotIds(index) = plot(1:n, trueX, 'b--', 'linewidth', 2); hold on;
            index = index + 1;
            legendStrs = [legendStrs, 'True model'];
        end
        
        if ~isempty(Lb) && ~isempty(Ub)
            plotIds(index) = plot(1:n, Lb, 'k--', 'linewidth', 2); hold on;
            plot(1:n, Ub, 'k--', 'linewidth', 2); hold on;
            legendStrs = [legendStrs, 'Boundary'];
        end
        
        legend(plotIds, legendStrs, 'location', 'best');
        xlabel('Sample number');
        ylabel('Varible value');
        title(sprintf('Iteration number: %d', iter));
        bsPlotSetDefault(bsGetDefaultPlotSet());
    else
        set(plotIds(2), 'YData', x);
        title(sprintf('Iteration number: %d', iter));
    end
    
    drawnow
    
    frame = getframe(gcf);
    pause(0.005);
end