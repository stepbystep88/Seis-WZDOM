function [f, g] = bsRosenbrock(x, isGradient)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -------------------------------------------------------------------------
% Rosenbrock Function 
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programming dates: May 2019   
% -------------------------------------------------------------------------
% For function details and reference information, see:
% see https://www.sfu.ca/~ssurjano/rosen.html
%
% Global minimum: min(f) = 0 at x = (1, 1, ...)'
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
    
    m = length(x);
    
    x2 = x.^2;
    
    xi = x(1:m-1, :);
    xip1 = x(2:m, :);
    xi_2 = x2(1:m-1, :);
    
    f = sum ( 100 * (xip1 - xi_2).^2 +  (xi - 1).^2 );
    f = f';
    
    
    if isGradient
        g1 = 2*(x(1) - 1) - 400*x(1)*(x(2) - x(1)^2);
        gm = 200*(x(m) - x(m-1)^2);

        xk = x(2:m-1);
        xkm1_2 = x2(1:m-2);
        xkp1 = x(3:m);
        xk_2 = x2(2:m-1);

        gk = -200*xkm1_2 + 202*xk - 400*(xk.*(xkp1 - xk_2)) - 2;

        g = [g1; gk; gm];
    else
        g = [];
    end
    
end