function [f, g] = bsHart6(x, isGradient)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -------------------------------------------------------------------------
% HARTMANN 6-DIMENSIONAL FUNCTION
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programming dates: May 2019   
% -------------------------------------------------------------------------
% For function details and reference information, see:
% https://www.sfu.ca/~ssurjano/hart6.html
%
% The function is usually evaluated on the hypercube 0 < xi < 1, for all
% i = 1,..., 6. 
% The global minima: f(x*) = -3.32237 at x* = (0.20169, 0.150011, 0.476874,
% 0.275332, 0.311652, 0.6573).
%
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
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUT:
%
% x = [x1, x2, x3, x4, x5, x6]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if nargin == 1 || isempty(isGradient)
        isGradient = true;
    end

    if size(x, 2) > 1
    	x = x';
    end
    
    n = length(x);
    assert(n == 6, 'Hartmann 6-dimensional function is only defined on a 6D space.')
    
    alpha = [1.0, 1.2, 3.0, 3.2]';
    A = [10, 3, 17, 3.5, 1.7, 8;
         0.05, 10, 17, 0.1, 8, 14;
         3, 3.5, 1.7, 10, 17, 8;
         17, 8, 0.05, 10, 0.1, 14];
     
    P = 10^(-4) * [1312, 1696, 5569, 124, 8283, 5886;
                   2329, 4135, 8307, 3736, 1004, 9991;
                   2348, 1451, 3522, 2883, 3047, 6650;
                   4047, 8828, 8732, 5743, 1091, 381];

    
    
    xx = repmat(x, 1, 4)';
    t1 = A .* (xx - P).^2;
    t2 = sum(t1, 2);
    t3 = alpha .* exp(-t2);
    f = -sum(t3);
    
    if isGradient
        
        g1 = 2 * (A .* (xx - P));
        g2 = repmat(t3, 1, 6);
        g3 = g1 .* g2;
        g = sum(g3, 1)';
        
%         for ii = 1:6
%             inner = 0;
%             for jj = 1 : 4
%                 inner = inner + 2.*tmps(jj) * A(jj, ii) * (x(ii) - P(jj, ii));
%             end
%             g(ii) = inner;
%         end
        
        
    else
        g = [];
    end
    
end