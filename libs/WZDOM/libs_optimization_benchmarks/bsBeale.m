function [f, g] = bsBeale(x, isGradient)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -------------------------------------------------------------------------
% Beale's function
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programming dates: May 2019   
% -------------------------------------------------------------------------
% For function details and reference information, see:
% http://benchmarkfcns.xyz/benchmarkfcns/bealefcn.html
%
% Global minimum: min(f) = 0 at x = (3, 0.5)'
%
% The Beale's function is only defined on a 2D space.
% -------------------------------------------------------------------------
% Input
%
% z: it must be a column vector representing the variable to be estimated
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
    
    assert(n == 2, 'Beale''s function is only defined on a 2D space.')
    X = x(1);
    Y = x(2);
    
    f = (1.5 - X + (X .* Y)).^2 + ...
             (2.25 - X + (X .* (Y.^2))).^2 + ...
             (2.625 - X + (X .* (Y.^3))).^2;
         
    if isGradient
        g1 = 2*(Y - 1)*(X*Y - X + 3/2) + 2*(Y^2 - 1)*(X*Y^2 - X + 9/4) + 2*(Y^3 - 1)*(X*Y^3 - X + 21/8);
        g2 = 2*X*(X*Y - X + 3/2) + 4*X*Y*(X*Y^2 - X + 9/4) + 6*X*Y^2*(X*Y^3 - X + 21/8);
        g = [g1; g2];
    else
        g = [];
    end
    
end