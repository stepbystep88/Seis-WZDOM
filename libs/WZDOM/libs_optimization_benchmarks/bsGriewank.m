function [f, g] = bsGriewank(x, isGradient)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -------------------------------------------------------------------------
% Griewank Function 
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programming dates: May 2019   
% -------------------------------------------------------------------------
% For function details and reference information, see:
% see http://benchmarkfcns.xyz/benchmarkfcns/griewankfcn.html
%
% Global minimum: min(f) = 0 at x = (0, 0, ...)'; -600<=x(i)<= 600.
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
    
    n = size(x, 1);
    
    seq = (1 : n)';
    term1 = x.^2 / 4000;
    tmp = x ./ sqrt(seq);
    term2 = cos(tmp);
    prodTerm2 = prod(term2);
    
    f = sum(term1) - prodTerm2 + 1;
    
    if isGradient
        
        g = 2 * term1 + prodTerm2 ./ term2 .* sin(tmp) ./ sqrt(seq);
    else
        g = [];
    end
end