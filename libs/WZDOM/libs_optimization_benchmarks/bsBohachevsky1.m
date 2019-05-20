function [f, g] = bsBohachevsky1(z, isGradient)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -------------------------------------------------------------------------
% Bohachevsky N. 1 function
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programming dates: May 2019   
% -------------------------------------------------------------------------
% For function details and reference information, see:
% http://benchmarkfcns.xyz/benchmarkfcns/bohachevskyn1fcn.html
%
% Global minimum: min(f) = 0 at x = (0, 0)'
%
% The Bohachevsky N. 1 function is only defined on a 2D space.
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
    
    x = z(1);
    y = z(2);
    
    assert(length(z) == 2, 'The Bohachevsky N. 1 function is only defined on a 2D space.')
    
    f = x^2 + 2*y^2 - 0.3*cos(3*pi*x) - 0.4*cos(4*pi*y) + 0.7;
    
    if isGradient
        g = [2*x + 0.9*pi*sin(3*pi*x); 4*y + 1.6*pi*sin(4*pi*y)];
    else
        g = [];
    end
    
end