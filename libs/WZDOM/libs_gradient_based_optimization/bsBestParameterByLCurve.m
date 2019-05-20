function [bestLambda, curveData] = bsBestParameterByLCurve(lambdas, inputObjFcnPkgs, xInit, Lb, Ub, options, isShowFigure)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate the crossplot of objective function value and regularization term for different lambdas
%
% Programmed by: Bin She (Email: bin.stepbystep@gmail.com)
% Programming dates: May 2019
% -------------------------------------------------------------------------
% INPUT
%
% lambdas       is a array; refers to a seris of regularization parameters.
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
% isShowFigure is a logical; When it is true, the L-Curve will be
% displayed.
%
% -------------------------------------------------------------------------
% OUTPUT
%
% bestLambda: the best lambda choosen by L-curve criteria
% 
% curveData is a array of size n*2, the first column corresponds to the
% data residual error, the second column is the regularization term.
%
% -------------------------------------------------------------------------

    nLambdas = length(lambdas);
    curveData = zeros(nLambdas, 2);
    
    for i = 1 : nLambdas
        
        if ~isempty(options.plotFcn)
            cprintf('blue', sprintf('In L-curve method. Runing the optimization process with regularization parameter=%d\n', lambdas(i)));
        end
        
        % update the lambda
        inputObjFcnPkgs{2, 3} = lambdas(i);
        
        % call bsGBSolverByOptions to solve the problem at current lambda
        [xOut, fval, exitFlag, output] = bsGBSolveByOptions(inputObjFcnPkgs, xInit, Lb, Ub, options);
        
        % update the inputObjFckPkgs, this is due to we initialize some
        % data of the inputObjFckPkgs through GBSolver
        inputObjFcnPkgs = output.inputObjFcnPkgs;
        
        % save the residual error and regularization term.
        curveData(i, 1) = inputObjFcnPkgs{1, 1}(xOut, inputObjFcnPkgs{1, 2});
        curveData(i, 2) = inputObjFcnPkgs{2, 1}(xOut, inputObjFcnPkgs{2, 2});
        
        
    end
    
%     curvature = zeros(nLambdas - 2, 1);
%     logCurveData = log(curveData);
    
    eta = curveData(:, 2);
    eta = normalize(eta, 'range');
    
    rho = curveData(:, 1);
    rho = normalize(rho, 'range');
    
    %% locate corner based on distance
    cornerX = min(eta);
    cornerY = min(rho);
    distancesFromCorner = sqrt((eta - cornerX) .^ 2 + (rho - cornerY) .^ 2);
    % Find min distance
    [minDistance, indexOfMin] = min(distancesFromCorner);
    bestLambda = lambdas(indexOfMin);
    
    %% locate corner based on distance]
%     curvature = zeros(nLambdas-2, 1);
%     for i = 2 : nLambdas - 1
%         x1 = eta(i-1);
%         y1 = rho(i-1);
%         x2 = eta(i);
%         y2 = rho(i);
%         x3 = eta(i+1);
%         y3 = rho(i+1);
%         
%         curvature(i-1) = 2*abs((x2-x1).*(y3-y1)-(x3-x1).*(y2-y1)) ./ ...
%             sqrt(((x2-x1).^2+(y2-y1).^2)*((x3-x1).^2+(y3-y1).^2)*((x3-x2).^2+(y3-y2).^2));
%     end
%     [~, indexOfMax] = max(curvature);
%     bestLambda = lambdas(indexOfMax);
    
    if nargin > 2 && isShowFigure == 1
        figure;
        
        plot(curveData(:, 2), curveData(:, 1), 'k-*', 'linewidth', 2);
        
        xlabel('Regularization term');
        ylabel('Residual term');
        bsPlotSetDefault(bsGetDefaultPlotSet());
    end
    
end
