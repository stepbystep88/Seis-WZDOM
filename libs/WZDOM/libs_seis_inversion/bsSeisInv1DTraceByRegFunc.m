function [x, fval, exitFlag, output] = bsSeisInv1DTraceByRegFunc(d, G, xInit, Lb, Ub, regParam, parampkgs, options, regFunc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is designed for 1D seismic inversion using regularization
% technique
%
% Programmed by: Bin She (Email: bin.stepbystep@gmail.com)
% Programming dates: May 2019
% -------------------------------------------------------------------------
% Input
% 
% d: observed seismic data, a vector.
% 
% G: forward operator made up by the wavelet information
% 
% xInit: initial guess of model parameters
% 
% Lb: lower boundary of x
% 
% Ub: upper boundary of x
% 
% regParam: regularization parameter. If it is empty, I will start a search
% process to find the optimal regParam.
%
% parampkgs: specail parameter for diffrent methods.
% 
% options: options parameters for 1D seismic inversion. See function
% bsCreateSeisInv1DOptions
% 
% regFunc: regularization function handle. It could be @bsReg*.m
%
% -------------------------------------------------------------------------
% Output
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
% output.regParam: the regularization parameters used
% -------------------------------------------------------------------------

    % create mainData
    mainData.A = G;
    mainData.B = d;
    
    % re-organize the input objective function pakages
    if options.addLowFreqConstraint
        inputObjFcnPkgs = {
            options.mainFunc,       mainData,   1; 
            regFunc,                parampkgs,  0; 
            @bsReg1DTKInitModel,    [],         options.initRegParam
        };
    else
        inputObjFcnPkgs = {
            options.mainFunc,       mainData,   1; 
            regFunc,                parampkgs,  0; 
        };
    end
    
    % if the regParam is not given, I search it by a search subroutine
    % which is save in options.searchRegParamFcn. 
    if isempty(regParam)
        % find the best regularization parameter
        regParam = bsFindBestRegParameter(options, inputObjFcnPkgs, xInit, Lb, Ub);
    end
           
    GBOptions = options.GBOptions;
    inputObjFcnPkgs{2, 3} = regParam;
    GBOptions.maxIter = options.maxIter;
    
    [x, fval, exitFlag, output] = bsGBSolveByOptions(inputObjFcnPkgs, xInit, Lb, Ub, GBOptions);
    output.regParam = regParam;
end