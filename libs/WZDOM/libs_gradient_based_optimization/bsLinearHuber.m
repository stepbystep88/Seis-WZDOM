function [f, g] = bsLinearHuber(x, data)
%% calculate the value of function huber(Ax - B) and its gradient as well
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
% data.threshold is a scalar; refers to the threshold of the huber function (Huber, 1973).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
% f             is a scalar; refers to huber(Ax - B).
%
% g             is a column vector; refers to the gradient of huber(Ax - B) with respect to x.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % get the global value
    threshold = data.threshold;
    
    
    % initial
    z = data.A * x - data.B;
    
    r = abs(z);
    index1 = find(r <= threshold);
    index2 = find(r > threshold);
    
    r(index1) = r(index1) .^2 / (2 * threshold);
    r(index2) = r(index2) - threshold / 2;
    
    % calculate the gradient
    sg = z / threshold;
    sg(sg > 1) = 1;
    sg(sg < -1) = -1;
    
    f = sum(r);
    g = data.A' * sg;

end