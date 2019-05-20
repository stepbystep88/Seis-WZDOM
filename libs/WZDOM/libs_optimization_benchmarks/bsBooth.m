function [f, g] = bsBooth(x, isGradient)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -------------------------------------------------------------------------
% Booth's function
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programming dates: May 2019   
% -------------------------------------------------------------------------
% For function details and reference information, see:
% http://benchmarkfcns.xyz/benchmarkfcns/boothfcn.html
%
% Global minimum: min(f) = 0 at x = (1, 3)'
%
% Booth's function is only defined on a 2D space.
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
    
    n = length(x);
    assert(n == 2, 'Booth''s function is only defined on a 2D space.')
    X = x(1);
    Y = x(2);
    
    f = (X + (2 * Y) - 7).^2 + ( (2 * X) + Y - 5).^2;
    
    if isGradient
        g1 = 10*X + 8*Y - 34;
        g2 = 8*X + 10*Y - 38;
        g = [g1; g2];
    else
        g = [];
    end
end