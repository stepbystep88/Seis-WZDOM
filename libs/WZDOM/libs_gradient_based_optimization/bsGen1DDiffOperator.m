function [DD] = bsGen1DDiffOperator(n, nsegments, order)
%% Regularization function, generate a difference operator with order of input order
% Bin She, bin.stepbystep@gmail.com, April, 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
% x             n is a scalar; refers to the dimension of D. For example,
% if the order == 1, D will be a size of (n-1)*n
%
% nsegments     nsegments is a scalar; refers to how many parts n is. For
% example, for pre-stack three-term AVO inversion, nsegments is 3
%
% order         order is a integer; it only can be [1, 2, 3].
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
% DD            the genertated difference matrix.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if nargin <= 1
        nsegments = 1;
        order = 1;
    end
    
    if nargin <= 2
        order = 1;
    end
    
    switch order
        case 0
            coef = 1;
        case 1
            coef = [-1, 1];
        case 2
            coef = [1, -2, 1];
        case 3
            coef = [-1, 3, -3, 1];
        otherwise
            error('order has to be 0, 1, 2 or 3.');
    end
    
    if mod(n, nsegments) ~= 0
        error('n has to be divisible by nsegments.');
    end
    
    n = n / nsegments;
    
    D = zeros(n-order, 1);
    m = length(coef);
    
    for i = 1 : n-order
        D(i, i:i+m-1) = coef;
    end
    
    DD = cell(nsegments, nsegments);
    MZERO = zeros(n-order, n);
    
    for i = 1 : nsegments
        for j = 1 : nsegments
            if i == j
                DD{i, i} = D;
            else
                DD{i, j} = MZERO;
            end
        end
        
    end
    
    DD = cell2mat(DD);
end