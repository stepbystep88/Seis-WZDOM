function [nResult, fes, mes] = bsCalFEAndME(result, trueModel)
%% calculate the MSE of the resuts
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
% nResult: the number of middle results
%
% fes: the sequece of function evaluations
% 
% mes: the relative root mean square error (RRMSE) betwen estimated model
% and true model.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

    middleResults = result.midResults;
    nResult = length(result.midResults.f);
    
    fes = zeros(1, nResult);
    mes = zeros(1, nResult);
    
    for i = 1 : nResult
        
        fes(i) = middleResults.f(i);
        resModel = exp(middleResults.x(:, i));
        
        mes(i) = sqrt(mse(resModel - trueModel)) / norm(trueModel);
        
    end
    
end