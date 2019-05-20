function  [x,fval,exitFlag,output] = bsGBSolveByOptions(inputObjFcnPkgs, xInit, Lb, Ub, options)
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
    
    n = length(xInit);

    %% deal with the boundary condition
    options.bounds.lower = Lb;
    options.bounds.upper = Ub;
    if isempty(Lb) && isempty(Ub)
        options.bounds.active = false;
    elseif isempty(Lb) || isempty(Ub)
        error('Lb and Ub must be empty or not empty at the same time.');
    else
        options.bounds.active = true;
        if ~isempty( find(Lb >= Ub, 1) )
            error('Lb must be less than Ub');
        end
    end
    
    if options.bounds.active
%         validateattributes(options.bounds.weight, {'double'}, {'<=', 1});
        validateattributes(options.bounds.weight, {'double'}, {'>=', 0});
        validatestring(string(options.bounds.methodFlag), ["simpleProj", "linearPenalty", "quadPenalty"]);
    end
    
    %% -------------------------------------------------------------------------
    % create function packages, very important!!!!!
    % --------------------------------------------------------------------------
    [outputObjFcnPkgs, inputObjFcnPkgs] = bsCreateFuncPkgs(xInit, inputObjFcnPkgs);
    
    %% get the parameters
    xInit = bsPFunc(xInit, options.bounds);
    objFcn = @(x) bsSumFuncsWithBound(x, options.bounds, outputObjFcnPkgs);
    optAlgFcn = options.optAlgHandle;
    optAlgParam = options.optAlgParam;
    
    f1 = objFcn(xInit);
    
    if(options.isSaveMiddleRes)
        % if we need to save the middle results, we just allocate space for
        % variable midResults
        midResults.x = zeros(n, options.maxIter+1);  % save model parameter xk
        midResults.f = zeros(1, options.maxIter+1);  % save objective function fk
        midResults.g = zeros(n, options.maxIter);    % save gradient gk
        midResults.p = zeros(n, options.maxIter);    % save descent direction pk
        
        midResults.x(:, 1) = xInit;
        midResults.f(1, 1) = f1;
    else
        midResults = [];
    end
    
    algInfo.pOld = [];
    
    data.xOld = xInit;
    data.xNew = data.xOld;
    data.fOld = f1;
    data.v = zeros(length(xInit), 1);
    data.pOld = [];
    data.nfev = 1;
    data.stp = 1;
    
    % start iteration process
    for iter = 1 : options.maxIter
        
        % set the iteration number
        data.iter = iter;
        
        [data, algInfo] = bsMoveOneStepWithMomentum(optAlgFcn, objFcn, optAlgParam, data, algInfo, options.DDM, options.momentum);
       
        % projection
        data.xNew = bsPFunc(data.xNew, options.bounds);
        
        % check whether intermediate results need to be saved
        if(options.isSaveMiddleRes)
            midResults.x(:, iter+1) = data.xNew;
            midResults.f(1, iter+1) = data.fNew;
            midResults.g(:, iter) = data.gNew;
            midResults.p(:, iter) = data.pk;
        end
            
        
        [exitFlag, message] = bsCheckStopCriteria(data, options);
        [data] = bsPlotMidResults(xInit, data, options, Lb, Ub, exitFlag > 0);
        
        if exitFlag > 0
            break;
        end
        
        % Update
        data.xOld = data.xNew;
        data.pOld = data.pk;
        data.fOld = data.fNew;
        data.gOld = data.gNew;

    end
    
   
    if(options.isSaveMiddleRes)
        midResults.x(:, iter+2:end) = [];
        midResults.f(iter+2:end) = [];
        midResults.g(:, iter+1:end) = [];
        midResults.p(:, iter+1:end) = [];
    end
        
    x = data.xNew;
    fval = data.fNew;
    
    output.gradient = data.gNew;
    output.iterations = iter;
    output.funcCount = data.nfev;
    output.midResults = midResults;
    output.options = options;
    output.message = message;
    output.inputObjFcnPkgs = inputObjFcnPkgs;
%     output.outputObjFcnPkgs = outputObjFcnPkgs;
    output.frames = data.frames;
end

