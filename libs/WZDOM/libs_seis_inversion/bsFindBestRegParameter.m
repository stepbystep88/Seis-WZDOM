function [bestRegParam] = bsFindBestRegParameter(options, inputObjFcnPkgs, xInit, Lb, Ub)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find the best regularization parameter by different methods. You can change
% options.searchRegParamFcn to set which function used to select
% regularization parameter.
%
% Programmed by: Bin She (Email: bin.stepbystep@gmail.com)
% Programming dates: May 2019
% -------------------------------------------------------------------------
% INPUT
%
% options: is a struct which contains the data and infomation of the way
% of calculating the objective function. see bsCreateSeisInv1DOptions.m
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
% -------------------------------------------------------------------------
% OUTPUT
%
% bestRegParam: the best regularization parameter choosen by different methods.
%
% -------------------------------------------------------------------------


    GBOptions = options.GBOptions;
    GBOptions.maxIter = options.searchRegMaxIter;
    lambdas = options.regParams;
    GBOptions.display = 'off';
    GBOptions.plotFcn = [];
    GBOptions.isSaveMiddleRes = false;
    
    %% check the parameters
    strSearchRegParamFcn = func2str(options.searchRegParamFcn);
    switch strSearchRegParamFcn
        case {'bsBestParameterByBisection', 'bsBestParameterBySearch'}
            if isempty(options.optimalX)
                error('To find a best regularization parameter using function bsBestParameterByBisection or bsBestParameterBySearch, the true model options.optimalX must be given .');
            else
                options.GBOptions.optimalX = options.optimalX;
            end
    end
        
    %% perform regularization parameter searching process 
    switch func2str(options.searchRegParamFcn)
        case strSearchRegParamFcn
            % get the best regParam by L-curve method
            bestRegParam = bsBestParameterByLCurve(lambdas, inputObjFcnPkgs, xInit, Lb, Ub, GBOptions, 0);
%             cprintf('*red', sprintf('The best regularization choosen by L-curve is %d\n', bestRegParam));
            
        case 'bsBestParameterByBisection'
            % get the best regParam by bisection method
            bestRegParam = bsBestParameterByBisection(...
                options.optimalX, ...
                options.logRegParamLeft, ...
                options.logRegParamRight, ...
                options.searchRegParamNIter, inputObjFcnPkgs, xInit, Lb, Ub, GBOptions);
%             cprintf('*red', sprintf('The best regularization choosen by bisection is %d\n', bestRegParam));
        case 'bsBestParameterBySearch'
            % get the best regParam by linear search method
            bestRegParam = bsBestParameterBySearch(lambdas, options.optimalX, inputObjFcnPkgs, xInit, Lb, Ub, GBOptions, 0);
%             cprintf('*red', sprintf('The best regularization choosen by linear search is %d\n', bestRegParam));
    end
end