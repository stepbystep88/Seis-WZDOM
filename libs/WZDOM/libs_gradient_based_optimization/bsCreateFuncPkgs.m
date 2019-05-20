function [fcnpkgs, objFunc] = bsCreateFuncPkgs(xInit, objFunc)
%% create function packages
% Bin She, bin.stepbystep@gmail.com, April, 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
% xInit         is a colmun vector; refers to the initial guess of the
% parameter x.
%
% objFunc       is a function handel, or a cell made up by a seris of
% functions, the data for calculating each function, and the weight
% coefficients. It could be like the following forms:
% 1. function
% 2. {function, struct}
% 3. {function1, struct1, weight1; function2 struct2; weight2; function3 struct3; weight3}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
%
% fcnpkgs         a re-organized struct. It will be used in the optimization
% process.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if size(objFunc, 1) == 1
        fcnpkgs.isSingleFunc = true;
        
        if isa(objFunc, 'cell') && length(objFunc) >= 2
            fcnpkgs.objFunc = objFunc{1, 1};
            fcnpkgs.data = objFunc{1, 2};
        else
            fcnpkgs.objFunc = objFunc;
            fcnpkgs.data = [];
        end
       
        
        if ~isa(fcnpkgs.objFunc, 'function_handle')
            error("When objective function is single, 'objFunc' has to be a function_handle.");
        end
            
        if nargin(fcnpkgs.objFunc) == 3
            [~, ~, fcnpkgs.data] = fcnpkgs.objFunc(xInit, fcnpkgs.data, 1);
            objFunc{3} = fcnpkgs.data;
        end
        
    else
        fcnpkgs.isSingleFunc = false;
        fcnpkgs.nFuncs = size(objFunc, 1);

        fcnpkgs.data = cell(1, size(objFunc, 1));
        fcnpkgs.weights = zeros(1, size(objFunc, 1));
        fcnpkgs.objFuncs = cell(1, size(objFunc, 1));
        
        if size(objFunc, 2) ~= 3
            error('When objective function is combined by multiple functions, objFunc should be a n*3 cell where n is the number of functions.');
        end
        
        for i = 1 : fcnpkgs.nFuncs
            if ~isa(objFunc{i, 1}, 'function_handle')
                error('When objective function is combined by multiple functions, the first column has to be a function_handle.');
            end
            
            if ~isa(objFunc{i, 3}, 'double')
                error('When objective function is combined by multiple functions, the third column has to be a scalar.');
            end
            
            fcnpkgs.objFuncs{i} = objFunc{i, 1};
            fcnpkgs.data{i} = objFunc{i, 2};
            fcnpkgs.weights(i) = objFunc{i, 3};
            
            if nargin(fcnpkgs.objFuncs{i}) == 3
                [~, ~, fcnpkgs.data{i}] = fcnpkgs.objFuncs{i}(xInit, fcnpkgs.data{i}, 1);
                objFunc{i, 2} = fcnpkgs.data{i};
            end
            
        end
    end
end