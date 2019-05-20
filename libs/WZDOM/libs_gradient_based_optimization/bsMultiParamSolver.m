function [x, fval, exitFlag, output] = bsMultiParamSolver(fcnUpdateParams, fcnGetInitialValue, pkgs, options, maxIter, innerIter)
%% For solving an multiple parameters optimization problem
% Bin She, bin.stepbystep@gmail.com, February, 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
% fcnUpdateParams    is a function handel which will be called at each
% iteration. It's shape is [params, xk, fk] = fcnUpdateParams(pkgs), where pkgs
% is a big struct data including all the information needed to update
% parameters. params is a struct containing all parameters, xk and fk are the main
% parameter vector and main function value at the kth iteration.
%
% fcnGetInitialValue   is a function handel which will be called at the first
% time. It's shape is [x1, f1] = fcnGetInitialValue(pkgs), where pkag is a big 
% struct data including all the information needed to calculate the initial
% main parameter and initial function value.
%
% pkgs is a big struct data including all the information needed to update
% parameters.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
% outParams     is a struct including all the estimated parameters.
%
% midResults    when isSaveMiddleRes = 1, it will save the middle
% estimations of the main parameter.
%
% nIter         the number of iterations performed in the process.
%
% xk            the main estimated parameter at the last iteration.
%
% fk            the main objective function value at the last iteration.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ~exist('maxIter', 'var') || isempty(maxIter)
        maxIter = 50;
    end
    
    if ~exist('innerIter', 'var') || isempty(innerIter)
        innerIter = 20;
    end
    
    
    [data.xOld, data.fOld] = fcnGetInitialValue(pkgs);
    
    %% parse some basic parameters for this process
    if(options.isSaveMiddleRes)
        
        midResults.x = zeros(length(data.xOld), maxIter+1);  % save model parameter xk
        midResults.f = zeros(1, maxIter+1);  % save objective function fk
        midResults.x(:, 1) = data.xOld;
        midResults.f(1) = data.fOld;
        
    else
        midResults = [];
    end
    
    data.nfev = 1;
    data.xNew = data.xOld;
    data.fNew = 10^10;
    xInit = data.xOld;
    
    for iter = 1 : maxIter
        
        data.iter = iter;
        
        % change the max iteration for options of GBSolver (for subproblem)
        options.maxIter = innerIter;
        [pkgs.params, xk, fk, nfev] = fcnUpdateParams(pkgs, options);
        
        % check whether intermediate results need to be saved
        if(options.isSaveMiddleRes)
            midResults.x(:, iter+1) = xk;
            midResults.f(1, iter+1) = fk;
        end
        
        data.nfev = data.nfev + nfev;
        data.xNew = xk;
        data.fNew = fk;
        
        options.maxIter = maxIter; % change this for checking stop criteria
        [exitFlag, message] = bsCheckStopCriteria(data, options);
        [data] = bsPlotMidResults(xInit, data, options, pkgs.Lb, pkgs.Ub, exitFlag > 0);
        
        if exitFlag > 0
            break;
        end
        
        % Update
        data.xOld = data.xNew;
        data.fOld = data.fNew;
    end
    
   
    
    x = data.xNew;
    fval = data.fNew;
    
    output.pkgs = pkgs;
    output.iterations = iter;
    output.funcCount = data.nfev;
    output.midResults = midResults;
    output.options = options;
    output.message = message;
    output.frames = data.frames;
end



