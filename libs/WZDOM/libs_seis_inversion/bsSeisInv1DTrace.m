function [xOut, fval, exitFlag, output] = bsSeisInv1DTrace(regFlag, d, G, xInit, Lb, Ub, regParam, parampkgs, options)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is designed for 1D seismic inversion
%
% Programmed by: Bin She (Email: bin.stepbystep@gmail.com)
% Programming dates: May 2019
% -------------------------------------------------------------------------
% Input
% 
% -------------------------------------------------------------------------
% regFlag: regularization flag, it could be the following terms:
% "TV-SB": corresponds to total variation regularization method. The
% objective function looks like 
% f(x) + lambda |Dx|_1 + rho |x-x0|_2^2.
% Where f(x) is a smooth function regarded as residual error term (measures 
% the errors between observed seismic data d and synthetic data Gx). D is a
% different matrix (could be first-order, second-order and third-order).
% The third term could be cancled off if you set
% options.addLowFreqConstraint = false. In addition, it should be noted
% that the second term which has a L1 norm is solved by Split-Bregman (SB)
% algorithm.
%
% "TV": corresponds to total varitation regularization method. It is the
% same as "TV-SB", but this one is sovled by gradient descent algorithm.
% The performance would be a little bit worse than "TV-SB", but will be
% faster than "TV-SB" in general.
%
% "TK": corresponds to Tikhonov method. The objective function looks like
% f(x) + lambda |Dx|_2^2 + rho |x-x0|_2^2.
% Similarly, D could be first-, second-, and third-order difference matrix.
% This method has smooth effect on solutions.
%
% "MGS": corresponds to minimum gradient support method. The objective
% function looks like
% f(x) + lambda |Dm|o|Dm|/(|Dm|o|Dm| + beta^2) + rho |x-x0|_2^2,
% where o represents element-wise multiplication. To see the effect of this
% method, please check the paper "Blaschek R, Hördt A, Kemna A. A new
% sensitivity-controlled focusing regularization scheme for the inversion 
% of induced polarization data based on the minimum gradient support[J]. 
% Geophysics, 2008, 73(2): F45-F54."
%
% "JTT": corresponds to joint TV and TK (JTT) method. The objective
% function looks like 
% f(x) + lambda (alpha*|D1 x|_1 + (1-alpha) |D2 x|_2^2) + rho |x-x0|_2^2,
% where alpha \in (0, 1), D1 and D2 could be different difference matrix,
% the difault is first-order for D1, second-order for D2. This method is a
% hybrid regularization method. 
%
% "PS": corresponds to piecewise smooth method. The objective funciton
% looks like
% f(x1, x2) + lambda (alpha*|D1 x1|_1 + (1-alpha) |D2 x2|_2^2)  rho |x-x0|_2^2,
% s.t. x1 + x2 = x. 
% This method is solved by ADMM and Split-Bregman
% algorithm. It takes some time to sovle it. The D1 and D2 should be the
% first-order and second-order different matrix, respectively. But you can
% try setting them as the other different matrix which may have good
% results.
%
% "PL": corresponds to piecewise linear method. The objective funciton
% looks like
% f(x1, x2) + lambda (alpha*|D1 x1|_1 + (1-alpha) |D2 x2|_1)  rho |x-x0|_2^2,
% s.t. x1 + x2 = x. 
% This method is solved by ADMM and Split-Bregman
% algorithm. It takes some time to sovle it. The D1 and D2 should be the
% first-order and second-order different matrix, respectively. But you can
% try setting them as the other different matrix which may have good
% results.
% -------------------------------------------------------------------------
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

    %% deal with different cases of input arguments
    if ~exist('Lb', 'var')
        Lb = [];
    end
    
    if ~exist('Ub', 'var')
        Ub = [];
    end
    
    if ~exist('regParam', 'var')
        regParam = [];
    end
    
    if ~exist('parampkgs', 'var') || isempty(parampkgs)
        parampkgs = [];
    end
    
    if ~exist('options', 'var') || isempty(options)
        options = bsCreateSeisInv1DOptions(length(xInit));
    end
    
    if ~strcmp(options.GBOptions.display, 'off')
        cprintf('blue', sprintf('Runing 1D seismic inversion method %s\n', regFlag));
    end
    
    
    switch regFlag
        case 'TV-SB'
            % TV solved by Split-Bregman algorithm
            [xOut, fval, exitFlag, output] = bsSeisInv1DByTVAndSplitBregman(d, G, xInit, Lb, Ub, regParam, parampkgs, options);
            
        case 'TV'
            % TV solved by gradient-based algorithm
            [xOut, fval, exitFlag, output] = bsSeisInv1DTraceByRegFunc(d, G, xInit, Lb, Ub, regParam, parampkgs, options, @bsReg1DTV);
            
        case 'TK'
            % Tikhonov regularization
            [xOut, fval, exitFlag, output] = bsSeisInv1DTraceByRegFunc(d, G, xInit, Lb, Ub, regParam, parampkgs, options, @bsReg1DTK);
            
        case 'PS'
            % picewise smooth
            [xOut, fval, exitFlag, output] = bsSeisInv1DByPicewiseSolver(d, G, xInit, Lb, Ub, regParam, parampkgs, options, @bsPicewiseSmoothReg);
            
        case 'PL'
            % picewise linear
            [xOut, fval, exitFlag, output] = bsSeisInv1DByPicewiseSolver(d, G, xInit, Lb, Ub, regParam, parampkgs, options, @bsPicewiseLinearReg);
            
        case 'MGS'
            % minimum gradient suppport algorithm
            [xOut, fval, exitFlag, output] = bsSeisInv1DTraceByRegFunc(d, G, xInit, Lb, Ub, regParam, parampkgs, options, @bsReg1DMGS);
            
        case 'JTT'
            % joint TV and TK
            [xOut, fval, exitFlag, output] = bsSeisInv1DTraceByRegFunc(d, G, xInit, Lb, Ub, regParam, parampkgs, options, @bsReg1DJTT);
            
        otherwise
            [xOut, fval, exitFlag, output] = bsSeisInv1DTraceByRegFunc(d, G, xInit, Lb, Ub, regParam, parampkgs, options, options.regFunc);
    end
    
    
end

