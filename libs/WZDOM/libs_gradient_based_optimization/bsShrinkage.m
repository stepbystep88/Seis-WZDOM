function res = bsShrinkage(y, a)
%% shrinkage function
% Bin She, bin.stepbystep@gmail.com, April, 2019
%
% this function performs the following procedure
% 
% 1. if y(i) > a, res(i) = y(i) - a;
% 2. if y(i) < -a, res(i) = y(i) + a;
% 3. otherwise res(i) = 0
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    res = zeros(length(y), 1);
    index = find(y > a);
    res(index) = y(index) - a;
    
    index = find(y < -a);
    res(index) = y(index) + a;
end