function [pkgs, fcnUpdateParams, fcnGetInitialValue] = bsSplitBregman(uInit, Lb, Ub, funcH, funcPhi, lambda, input)
%% create packages, update function and initial function of split Bregman algorithm
% this split Bregman algorithm is used to slove the problem shaped like min{H(u) + lambda*|Phi(u)|_1} 
% the implement of this function is based on ftp://ftp.math.ucla.edu/pub/camreport/cam08-29.pdf
% Bin She, bin.stepbystep@gmail.com, April, 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
% uInit         is a colmun vector; refers to the initial guess of
% parameter u.
%
% funcH         is a function handel shaped like [f, g] = funcH(u)
%
% funcPhi       is a function handel shaped like [v, G] = funcPhi(u) 
% where v = Phi(u), G is a Jacobian matrix equaling to J_u(Phi)
%
% eta           is a scalar used in the split Bregman algorithm
% 
% nInnerIter    is a integer representing the number of inner iterations
% taken in each outer iteration.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
%
% updateFunc    is a function handel which will be called at each
% iteration. It's shape is [params, xk, fk] = updateFunc(pkgs), where pkgs
% is a big struct data including all the information needed to update
% parameters. params is a struct containing all parameters, xk and fk are the main
% parameter vector and main function value at the kth iteration.
%
% initialFunc   is a function handel which will be called at the first
% time. It's shape is [x1, f1] = initialFunc(pkgs), where pkag is a big 
% struct data including all the information needed to calculate the initial
% main parameter and initial function value.
%
% pkgs is a big struct data including all the information needed to update
% parameters.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

    [~, input] = bsGetFieldsWithDefaults(input, ...
        {
        'eta', 100; 
        }...
    );
    
    funcs.funcH = funcH;
    funcs.funcPhi = funcPhi;
    
    funcs.eta = input.eta;
    funcs.lambda = lambda;
    
    pkgs.funcs = funcs;

    t = funcPhi(uInit);
    
    n = length(t);
    params.u = uInit;
    params.b = zeros(n, 1);
    params.d = zeros(n, 1);
    pkgs.params = params;
    
    pkgs.Lb = Lb;
    pkgs.Ub = Ub;
    
    fcnUpdateParams = @updateFunc;
    fcnGetInitialValue = @initFunc;
end

function [xk, fk] = initFunc(pkgs)
    xk = pkgs.params.u;
    fk = minUpdateU(xk, pkgs);
end

function [f, g] = minUpdateU(u, pkgs)

    [f1, g1] = pkgs.funcs.funcH(u);
    [p2, t2] = pkgs.funcs.funcPhi(u);
            
    z = pkgs.params.d - p2 - pkgs.params.b;
    g2 = -(pkgs.funcs.eta*pkgs.funcs.lambda) * (t2 * z);
    
    g = g1 + g2;
    f = f1 + (0.5 * pkgs.funcs.eta) * (z' * z);
    
end

function [params, xk, fk, nfev] = updateFunc(pkgs, options)
    
    % no display, no plot, no save middle results
    options.display = 'off';
    options.plotFcn = [];
    options.isSaveMiddleRes = false;
    
    params = pkgs.params;
    
    % update u
    [params.u, fk, exitFlag, output] = bsGBSolveByOptions({@minUpdateU, pkgs}, params.u, pkgs.Lb, pkgs.Ub, options); 
    
    % update d
    threshold = pkgs.funcs.lambda / pkgs.funcs.eta;
    phiU = pkgs.funcs.funcPhi(params.u);
%     phiU = pkgs.funcs.lambda * phiU;
    
    params.d = bsShrinkage(phiU + params.b, threshold);
    
    %update b
    params.b = params.b + (phiU - params.d);
    
    xk = params.u;
    nfev = output.funcCount;
    
end


