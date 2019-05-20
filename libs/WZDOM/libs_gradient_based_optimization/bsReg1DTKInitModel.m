function [f, g, data] = bsReg1DTKInitModel(x, data, isInitial)
%% Regularization function, return the value and gradient of function $|x-x_0|_2^2$
% Bin She, bin.stepbystep@gmail.com, March, 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
% x             is a column vector; refers to the parameter to be estimated.
%
% GOptParam.xInit is a column vector; refers to the initial guess of x
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
% f             is a scalar; refers to |x-x_0|_2^2.
%
% g             is a column vector; refers to the gradient of |x-x_0|_2^2 with respect to x.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % if the funcion is called at first time
    if nargin == 3 && isInitial
        data.xInit = x;
    end
    
    z = x - data.xInit;
    f = z' * z;
    g = 2 * z;
end