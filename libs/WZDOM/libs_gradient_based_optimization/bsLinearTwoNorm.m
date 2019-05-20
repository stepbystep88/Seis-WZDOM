function [f, g] = bsLinearTwoNorm(x, data)
%% calculate the value of function |Ax - B|_2^2 and its gradient as well
% Bin She, bin.stepbystep@gmail.com, February, 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
% x                         is a column vector; refers to the parameter to be estimated.
%
% data.A               is a matrix; refers to the kernel/deblur/sampling matrix.
%
% data.B               is a column vector; refers to the observed data.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
% f                     	is a scalar; refers to |Ax - B|_2^2.
%
% g                         is a column vector; refers to the gradient of
% |Ax - B|_2^2 with respect to x.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    z = data.A * x - data.B;

    f = z' * z;
    g = 2*(data.A' * z) ;
end