function p = bsAddBasicalParameters(p, nDim)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code generates some default parameters for stop criteria of
% algorithms
% 
% Programmed by: Bin She (Email: bin.stepbystep@gmail.com)
% Programming dates: May 2019
% -------------------------------------------------------------------------
% Input
%
% p: a input parser
% 
% nDim: the number of dimensions
% -------------------------------------------------------------------------

    addParameter(p, 'maxIter', nDim * 150 );
    addParameter(p, 'maxFunctionEvaluations', nDim * 1500);
    
    addParameter(p, 'stepTolerance', 1e-10 ); % this is only for gradient based optimization algorithm
    addParameter(p, 'functionTolerance', 1e-10 );
    addParameter(p, 'optimalGradientTolerance', 1e-10);
    addParameter(p, 'optimalityTolerance', 1e-10);
    addParameter(p, 'optimalFunctionTolerance', 1e-6);
    addParameter(p, 'optimalModelTolerance', 1e-6);
    
    addParameter(p, 'optimalX', [] );
    addParameter(p, 'optimalF', [] );
    % notify: only print some important information
    % off: do't print any information
    % final: print the final information 
    % iter: print the iteration information
    addParameter(p, 'display', 'notify', @(x) ~isempty(validatestring(x, ["notify", "off", "final", "iter"])));
    
    % whether to save the middle results during the iteration process
    addParameter(p, 'isSaveMiddleRes', 0);
    
    % plot the result during the whole iteration process
    addParameter(p, 'plotFcn', [], @(x) isempty(x) || ~isempty(validatestring(func2str(x), ["bsPlotObjFcnVal", "bsPlotModelChange"])));
end
