function [x,fval,exitFlag,output] = bsGBSolver(inputObjFcnPkgs, xInit, Lb, Ub, varargin)
%% solving a large scale optimization problem using gradient based optimization algorithm
%
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programmed dates: May 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
% inputObjFcnPkgs       is a function handel, or a cell made up by a seris of
% functions, the data for calculating each function, and the weight
% coefficients. It could be like the following forms:
% 1. function
% 2. {function, struct}
% 3. {function1, struct1, weight1; function2 struct2; weight2; function3 struct3; weight3}
%
% xInit         is a colmun vector; refers to the initial guess of the
% parameter x.
%
% Lb        lower boundary
%
% Ub        upper boundary
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
% exitFlag = 1 if reaches the max number of function evaluations
% exitFlag = 2 if reaches the max number of iterations
% exitFlag = 3 if the current step size is less than stepTolerance
% exitFlag = 4 if the difference between two adjacent estimated parameters is less than optimalityTolerance
% exitFlag = 5 if the max absolute gradient among all dimensions is less than optimalGradientTolerance
% exitFlag = 6 if the difference between two adjacent objective function value is less than functionTolerance
% exitFlag = 7 if the difference between estimated parameter and the true parameter is less than optimalModelTolerance
% exitFlag = 8 if the difference between the objective function value at the estimated parameter and the true minimum is less than optimalFunctionTolerance.
%
% output    a struct, in general, it has
% output.iterations: the number of iterations
% output.nfev: the number of function evaluations
% ouput.midResults: the middle results during the iteration process
% ouput.gradient: the gradient at the final estimated parameter
% ouput.options: the options for this inversion process
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % if xInit is a row vector, we reshape it to a column vector
    if size(xInit, 1) == 1
        xInit = xInit';
    end
    
    % deal with the different cases of the number of input arguments
    nInputVar = nargin;
    
    if nInputVar < 3
        Lb = [];
    end
    
    if nInputVar < 4
        Ub = [];
    end
    

    % create options by the given input arguments
    options = bsCreateGBOptions(length(xInit), varargin{:});
    
    [x, fval, exitFlag, output] = bsGBSolveByOptions(inputObjFcnPkgs, xInit, Lb, Ub, options);
end


