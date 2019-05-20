function [xOut, fval, exitFlag, output] = bsSeisInv1DByTVAndSplitBregman(d, G, xInit, Lb, Ub, regParam, parampkgs, options)
%% 1D total variation (TV) seismic inversion using Split-Bregman algorithm. 
% This function only can be used to solve the prolbem like 
% f(x) + lambda|Dx|_1 where f(x) is a smooth function regarded as residual
% error term (measures the errors between observed seismic data d and
% synthetic data Gx), lambda is the regularization parameter saved in 
%
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programmed dates: May 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
% inputObjFcnPkgs       is a function handel, or a cell made up by a seris of
% functions, the data for calculating each function, and the weight
% coefficients. It could be like the following three forms:
% 1. function (only one function, no need for extra data)
% 2. {function, struct} (only one function, need extra data)
% 3. {function1, struct1, weight1; function2 struct2; weight2; ...} 
% (mutiple functions)
%
% xInit         is a colmun vector; refers to the initial guess of the
% parameter x.
% 
% Lb: lower boundary
%
% Ub: upper boundary
%
% options     is a struct which contains the data and infomation of the way
% of calculating the objective function. 
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
%
% x          is a column vector; refers to the estimated result.
%
% fval          the objective function value at the last iteration
% 
% exitFlag      corresponds to the stopCriteria
% see function bsCheckStopCriteria
% 
% output    a struct, in general, it has
% output.iterations: the number of iterations
% output.nfev: the number of function evaluations
% ouput.midResults: the middle results during the iteration process
% ouput.gradient: the gradient at the final estimated parameter
% ouput.options: the options for this inversion process
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

    % TV solved by gradient-based algorithm
    % re-organize the input objective function pakages
    mainData.A = G;
    mainData.B = d;
    
    % whether add the low frequency component constraint |x-x0|_2^2
    if options.addLowFreqConstraint
        initObjFunc = {@bsReg1DTKInitModel, [], options.initRegParam;};
    else
        initObjFunc = [];
    end
    
    % if the regParam is not given, I search it by a search subroutine
    % which is save in options.searchRegParamFcn. 
    if isempty(regParam)
        inputObjFcnPkgs = [{options.mainFunc, mainData, 1; @bsReg1DTV, parampkgs, 0;}; initObjFunc];
        regParam = bsFindBestRegParameter(options, inputObjFcnPkgs, xInit, Lb, Ub);
    end

    % change the number of iteration for inner iteration
%             options.GBOptions.maxIter = options.innerIter;

    % TV solved by split-bregman
    % create function pakages for regularization term
    regFcnPkgs = bsCreateFuncPkgs(xInit, {@bs1DTVFunc, parampkgs});
    funcPhi = @(x)bs1DTVFunc(x, regFcnPkgs.data, 0);

    % create function pakages for the residual terms
    fcnHPkgs = bsCreateFuncPkgs(xInit, [{options.mainFunc, mainData, 1}; initObjFunc]);
    funcH = @(x)(bsSumFuncsWithBound(x, options.GBOptions.bounds, fcnHPkgs));

    % create pkgs and update function, and get initial value function for
    % bsMultiParamSolver which performs iteration processes for multiple
    % parameters (Split-Bregman algorithm iterates more than one parameter)
    [pkgs, fcnUpdateParams, fcnGetInitialValue] ...
        = bsSplitBregman(xInit, Lb, Ub, funcH, funcPhi, regParam, parampkgs);

    % call the multiple parameter solver to sovle the problem
    [xOut, fval, exitFlag, output] ...
        = bsMultiParamSolver(fcnUpdateParams, fcnGetInitialValue, pkgs, options.GBOptions, options.maxIter, options.innerIter);
    
    output.regParam = regParam;
end