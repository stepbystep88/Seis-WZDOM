function [data] = bsPlotMidResults( xInit, data, params, Lb, Ub, isExit)
%% check whether stop the iteration process.
%
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programmed dates: May 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
% 
% xInit initial model
% 
% plotFcn: the function handel of plot the middle results
%
% data: a struct saving some iteration information 
%
% params.maxIter: maximum number iterations
%
% isExit: is the last iteration
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if ~isempty(params.plotFcn) && isa(params.plotFcn, 'function_handle')
        
        if data.iter <= 1
            data.frames = moviein(params.maxIter);  
            data.fid = figure;
            data.plotIds = [];
        end
        
        switch func2str(params.plotFcn)
            case 'bsPlotObjFcnVal'
                data.frames(:, data.iter) = bsPlotObjFcnVal(data.fid, data.iter, data.fNew);
            case 'bsPlotModelChange'
                [data.frames(:, data.iter), data.plotIds] ...
                    = bsPlotModelChange(data.fid, data.plotIds, data.iter, data.xNew, xInit, Lb, Ub, params.optimalX);
        end
        
        if isExit
            data.frames(:, data.iter+1:end) = [];
        end
    
    else
        data.frames = [];
        
    end
    
    
end