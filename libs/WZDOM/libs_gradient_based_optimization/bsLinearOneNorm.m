function [f, g] = bsLinearOneNorm(x, data)
%% calculate the value of function |Ax - B| and its gradient as well
% Bin She, bin.stepbystep@gmail.com, February, 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
% x             is a column vector; refers to the parameter to be estimated.
%
% data.A   is a matrix; refers to the kernel/deblur/sampling matrix.
%
% data.B   is a column vector; refers to the observed data.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
% f             is a scalar; refers to |Ax - B|.
%
% g             is a column vector; refers to the gradient of |Ax - B| with respect to x.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
%     n = length(data.B);
    z = data.A * x - data.B;
    
    f = sum( abs(z) );
    
    % calculate the gradient
%     sg = zeros(n, 1);
    
    t = sign(z);
    
%     iz = find(z>0 & z<1e-5);
%     t(iz) = rand(length(iz), 1);
%     
%     iz = find(z<0 & z>-1e-5);
%     t(iz) = -rand(length(iz), 1);
    
    g = data.A' * t;
    
end