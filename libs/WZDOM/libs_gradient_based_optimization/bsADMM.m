function [pkgs, upFunc, initialFunc] = bsADMM(xInit, zInit, funcF, dataF, funcG, dataG, A, B, c, rho, nInnerIter)
%% create packages, update function and initial function of ADMM, this function has not been varified!!!
% this ADMM algorithm is used to slove the problem shaped like
% min{f(x)+g(z)} s.t. Ax + Bz = c
%
% the implement of this function is based on https://web.stanford.edu/class/ee364b/lectures/admm_slides.pdf
% 
% Bin She, bin.stepbystep@gmail.com, April, 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
% xInit         is a colmun vector; refers to the initial guess of
% parameter x.
% 
% zInit         is a colmun vector; refers to the initial guess of
% parameter z.
%
% funcF         is a function handel shaped like [f, g] = funcF(x, dataF)
%
% dataF         is a struct for calculating function funcF
%
% funcG         is a function handel shaped like [f, g] = funcG(x, dataG)
%
% dataG         is a struct for calculating function funcG
%
% rho           is a scalar used in the split Bregman algorithm
% 
% nInnerIter    is a integer representing the number of inner iterations
% taken in each outer iteration.
%
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

    if ~exist('rho', 'var')
        rho = 1;
    end
    if ~exist('nInnerIter', 'var')
        nInnerIter = 5;
    end
    
    funcs.funcF = funcF;
    funcs.funcG = funcG;
    
    if nargin(funcG) == 3
        [~, ~, funcs.dataG] = funcG(xInit, dataG, 1);
    else
        funcs.dataG = dataG;
    end
    
    if nargin(funcF) == 3
        [~, ~, funcs.dataF] = funcG(xInit, dataF, 1);
    else 
        funcs.dataF = dataF;
    end
    
    funcs.nInnerIter = nInnerIter;
    funcs.rho = rho;
    funcs.A = A;
    funcs.ATrans = A';
    funcs.B = B;
    funcs.BTrans = B';
    funcs.c = c;
    
    pkgs.funcs = funcs;

    n = length(A*xInit, 1);
    params.x = xInit;
    params.z = zInit;
    params.y = zeros(n, 1);
    
    pkgs.params = params;
    
    upFunc = @updateFunc;
    initialFunc = @initFunc;
end

function [xk, fk] = initFunc(pkgs)
    xk = pkgs.params.x;
    fk = minUpdateX(pkgs);
end

function [f, g] = minUpdateX(x, pkgs)
    
    
    switch nargin(pkgs.funcs.funcF)
        case 1
            [f1, g1] = pkgs.funcs.funcF(x);
        case 2
            [f1, g1] = pkgs.funcs.funcF(x, pkgs.funcs.dataF);
        otherwise
            [f1, g1] = pkgs.funcs.funcF(x, pkgs.funcs.dataF, 0);
    end
    
    
    d = pkgs.funcs.A * pkgs.params.x + pkgs.funcs.B * pkgs.params.z - pkgs.funcs.c + pkgs.funcs.y;
    f2 = (0.5 * pkgs.funcs.rho) * (d'*d);
    g2 = pkgs.funcs.rho * (pkgs.funcs.ATrans * d);
    
    f = f1 + f2;
    g = g1 + g2;
    
end

function [f, g] = minUpdateZ(z, pkgs)
    
    
    switch nargin(pkgs.funcs.funcG)
        case 1
            [f1, g1] = pkgs.funcs.funcG(z);
        case 2
            [f1, g1] = pkgs.funcs.funcG(z, pkgs.funcs.dataG);
        otherwise
            [f1, g1] = pkgs.funcs.funcG(z, pkgs.funcs.dataG, 0);
    end
    
    d = pkgs.funcs.A * pkgs.params.x + pkgs.funcs.B * pkgs.params.z - pkgs.funcs.c + pkgs.funcs.y;
    f2 = (0.5 * pkgs.funcs.rho) * (d'*d);
    g2 = pkgs.funcs.rho * (pkgs.funcs.BTrans * d);
    
    f = f1 + f2;
    g = g1 + g2;
    
end

function [params, xk, fk] = updateFunc(pkgs)
    
    params = pkgs.params;
    
    % update x
    [params.x, ~, ~, fk] = bsGBSolver(@bsOptLBFGS, {@minUpdateX, pkgs}, params.x, [], 'maxIter', pkgs.funcs.nInnerIter); 
    
    % update z
    [params.z, ~, ~, ~] = bsGBSolver(@bsOptLBFGS, {@minUpdateZ, pkgs}, params.z, [], 'maxIter', pkgs.funcs.nInnerIter); 
    
    % update y
    d = pkgs.funcs.A * pkgs.params.x + pkgs.funcs.B * pkgs.params.z - pkgs.funcs.c;
    params.y = params.y + d;
    
    xk = params.x;
end


