function [pkgs, updateFcn, initialFcn] = bsPicewiseSmoothReg(xInit, Lb, Ub, mainFunc, input)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create packages, update function and initial function of the picewise regularization problem
% mainFunc(x) + alpha*lambda1*|D1x1|_1+(1-alpha)*lambda2*|D2x2|_2^2, s.t. x1+x2=x
%
% Programmed by: Bin She (Email: bin.stepbystep@gmail.com)
% Programming dates: May 2019
% -------------------------------------------------------------------------
% INPUT
%
% xInit         is a colmun vector; refers to the initial guess of
% parameter x.
%
% Lb            lower boundary
%   
% Ub            upper boundary
% 
% mainFunc      a function handle corresponding to the residual term.
% Shaped like [f, g] = mainFunc(x)
%
% input         some special parameter for this method.
%
%
% -------------------------------------------------------------------------
% OUTPUT
%
% updateFcn    is a function handel which will be called at each
% iteration. It's shape is [params, xk, fk] = updateFunc(pkgs), where pkgs
% is a big struct data including all the information needed to update
% parameters. params is a struct containing all parameters, xk and fk are the main
% parameter vector and main function value at the kth iteration.
%
% initialFcn   is a function handel which will be called at the first
% time. It's shape is [x1, f1] = initialFunc(pkgs), where pkag is a big 
% struct data including all the information needed to calculate the initial
% main parameter and initial function value.
%
% pkgs is a big struct data including all the information needed to update
% parameters.
%
% -------------------------------------------------------------------------
    
    %% parse some basic parameters for this process
    [~, input] = bsGetFieldsWithDefaults(input, ...
        {
        'rho', 0.001; 
        'eta', 50; 
        'diffOrder1', 1;
        'diffOrder2', 2;
        'nSegments', 1;
        'alpha', 0.4;
        'lambda1', 0.1;
        'lambda2', 0.1;
        }...
    );
    
    alpha = input.alpha;
    lambda1 = input.lambda1;
    lambda2 = input.lambda2;
    
    funcs.mainFunc = mainFunc;
    
    n = length(xInit);
    funcs.D1 = bsGen1DDiffOperator(n, input.nSegments, input.diffOrder1);
    funcs.D2 = bsGen1DDiffOperator(n, input.nSegments, input.diffOrder2);
    
    params.x1 = xInit * alpha;
    params.x2 = xInit * (1-alpha);
    params.d = zeros(size(funcs.D1, 1), 1);
    params.b = params.d;
    
    pkgs.params = params;
    
    
    funcs.lambda1 = lambda1 * alpha;
    % for piecewise smooth algorithm, the bigger lambda2 (smooth part), the
    % result will be more blocky, to enhence the blockiness, I use a huge
    % lambda2 when alpha is close to 1
    funcs.lambda2 = lambda2 * 5 ^ (10 * alpha);
%     funcs.lambda2 = lambda2 / (1 - alpha) * 10;
    
%     funcs.D1 = funcs.D1 * funcs.lambda1;
%     funcs.D2 = funcs.D2 * funcs.lambda2;

    funcs.eta = input.eta;
    funcs.eta1 = input.eta * funcs.lambda1;
    
    funcs.rho = input.rho;
    pkgs.xInit = xInit;
    
    pkgs.funcs = funcs;
    
    pkgs.Lb = Lb;
    pkgs.Ub = Ub;
    
    updateFcn = @updateFunc;
    initialFcn = @initFunc;
    
end


function [xk, fk] = initFunc(pkgs)
    xk = pkgs.params.x1 + pkgs.params.x2;
    fk = minUpdateX1(pkgs.params.x1, pkgs);
end

function [f, g] = minUpdateX1(x1, pkgs)
    
    x = x1 + pkgs.params.x2;
    
    [f1, g1] = pkgs.funcs.mainFunc(x);
    
    t = pkgs.params.d - pkgs.funcs.D1*x1 - pkgs.params.b;
    f2 = (0.5 * pkgs.funcs.eta1) * (t'*t);
    g2 = -pkgs.funcs.eta1*(pkgs.funcs.D1' * t);
    
    t = x1 + pkgs.params.x2 - pkgs.xInit;
    f3 = (0.5 * pkgs.funcs.rho) * (t'*t);
    g3 = pkgs.funcs.rho * t;
    
    f = f1 + f2 + f3;
    g = g1 + g2 + g3;
    
end

function [f, g] = minUpdateX2(x2, pkgs)
    
    x = pkgs.params.x1 + x2;
    
    [f1, g1] = pkgs.funcs.mainFunc(x);
    
    t = (pkgs.funcs.D2 * x2);
    f2 = pkgs.funcs.lambda2 * (t' * t);
    g2 = (2*pkgs.funcs.lambda2) * (pkgs.funcs.D2' * t);
    
    t = pkgs.params.x1 + x2 - pkgs.xInit;
    f3 = (0.5 * pkgs.funcs.rho) * (t'*t);
    g3 = pkgs.funcs.rho * t;
    
    f = f1 + f2 + f3;
    g = g1 + g2 + g3;
    
end



function [params, xk, fk, nfev] = updateFunc(pkgs, options)
    
    % no display, no plot, no save middle results
    options.display = 'off';
    options.plotFcn = [];
    options.isSaveMiddleRes = false;
    
    params = pkgs.params;
    
    % update u
    [params.x1, fk, exitFlag, output] = bsGBSolveByOptions({@minUpdateX1, pkgs}, params.x1, [], [], options); 
    pkgs.params.x1 = params.x1;

    % update d
    gx1b = pkgs.funcs.D1 * params.x1 + params.b;
    params.d = bsShrinkage(gx1b, 1 /pkgs.funcs.eta);
    
    % update b
    params.b = gx1b - params.d;
    
    % update x2
    [params.x2, ~, exitFlag, output] = bsGBSolveByOptions({@minUpdateX2, pkgs}, params.x2, [], [], options); 

    
    xk = params.x1 + params.x2;
    params.x = xk;
    
    nfev = output.funcCount;
end


