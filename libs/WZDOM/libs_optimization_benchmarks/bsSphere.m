function [f, g] = bsSphere(x, isGradient)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -------------------------------------------------------------------------
% Michalewicz's Function 
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programming dates: May 2019   
% -------------------------------------------------------------------------
% For function details and reference information, see:
% https://www.al-roomi.org/benchmarks/unconstrained/n-dimensions/197-michalewicz-s-function
%
% Global minimum: min(f) = 0 at x = (0, 0, ...)'
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
    
    f = sum(x.^2);
    
    if isGradient
        
        g = 2 * x;
    else
        g = [];
    end
end