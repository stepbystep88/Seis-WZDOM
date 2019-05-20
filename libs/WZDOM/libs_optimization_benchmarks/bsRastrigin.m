function [f, g] = bsRastrigin(x, isGradient)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -------------------------------------------------------------------------
% Rastrigin Function 
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programming dates: May 2019   
% -------------------------------------------------------------------------
% For function details and reference information, see:
% see http://benchmarkfcns.xyz/benchmarkfcns/rastriginfcn.html
%
% Global minimum: min(f) = 0 at x = (0, 0, ...)'
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% Input
%
% x: it must be a column vector representing the variable to be estimated
%
% isGradient: a logical variabel. The function will calculate gradient
% information of this objective function if it is equal to true, otherwise,
% the subroutine will not compute the gradient information. 
% -------------------------------------------------------------------------
% Output
%
% f: objective function value.
% 
% g: gradient information. g = [] if isGradient = 0.
% -------------------------------------------------------------------------

    if nargin == 1 || isempty(isGradient)
        isGradient = true;
    end
    
    if size(x, 2) > 1
        x = x';
    end
    
    n = length(x);
    A = 10;
    pi2x = 2 * pi * x;
    
    x2 = x .^ 2;
    f = A * n + sum( x2 - 10 * cos(pi2x) );
    
    if isGradient
        g = 2*x + 20 * pi * sin(pi2x);
    else
        g = [];
    end
end