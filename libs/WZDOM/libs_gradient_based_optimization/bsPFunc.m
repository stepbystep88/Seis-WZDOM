function [px, gpx] = bsPFunc(x, bounds)
%% projection fundtion P(x)
%
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programmed dates: May 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
% x: is a column vector; refers to the parameter to be estimated.
%
% bounds.lower: is a column vector; refers to the lower bound
% of parameter x.
%
% bounds.upper: is a column vector; refers to the upper bound
% of parameter x.
%
% bounds.active: is a logical value; The projection function is activated 
% when it is equal to 1.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
% px: is a column vector; refers to the projection P(x).
%
% gpx: is a column vector; refers to the gradient of
% P(x) with respect to parameter x.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    px = x;
    gpx = ones(length(x), 1);
    
    % perform projection operation
    if(bounds.active && strcmp(bounds.methodFlag, "simpleProj"))
        
        xLowerBound = bounds.lower;
        xUpperBound = bounds.upper;
    
        lowerIndex = find(x <= xLowerBound);
        upperIndex = find(x >= xUpperBound);


        px(lowerIndex) = xLowerBound(lowerIndex);
        px(upperIndex) = xUpperBound(upperIndex);
    end
    
end