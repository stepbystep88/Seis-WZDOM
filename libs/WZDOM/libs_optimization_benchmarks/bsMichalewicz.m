function [f, g] = bsMichalewicz(x, isGradient)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -------------------------------------------------------------------------
% Michalewicz's function
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programming dates: May 2019   
% -------------------------------------------------------------------------
% For function details and reference information, see:
% http://www-optima.amp.i.kyoto-u.ac.jp/member/student/hedar/Hedar_files/TestGO_files/Page2376.htm
%
% Global minimum: 0 < xi < pi, i=1,2...
%
% For n=1:
%   f(x*) = -0.801303410098552549
%   x* = 2.20290552017261
%
% For n=2:
%   f(x*) = -1.80130341009855321
%   x* = (2.20290552014618,1.57079632677565)
% 
% For n=5:
%   f(x*) = -4.687658.
%
% For n=10
%   f(x*) = -9.66015
% -------------------------------------------------------------------------
% Input
%
% z: it must be a column vector representing the variable to be estimated
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
    
    n = length(x);
    m = 10;
    
    ii = (1 : n)';
    t0 = sin(ii.*x.^2/pi);
    t1 = t0.^(2*m);
    t2 = sin(x);
    t3 = t1 .* t2;
    
    f = -sum(t3);

         
    if isGradient
        g1 = -cos(x).*t1;
        g2 = -(2*m)*(t2.*t0.^(2*m-1).*cos(ii.*x.^2/pi).*(2*ii/pi));
        g = g1 + g2;
    else
        g = [];
    end
    
end