function [f, g] = bsSumFuncsWithBound(x, bounds, fcnPkgs)
%% sum the objective function value and gradient of all functions in fcnPkgs and at the same time add the 
% boundary condition if it is activated.
%
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programmed dates: May 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
% x                         is a column vector; refers to the parameter to be estimated.
%
% fcnPkgs              a struct saving the information related to the
% objective function.
%
% bounds            a struct saving the information related to the boundary contition.      
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
% f                     	is a scalar; refers to the value of objective function.
%
% g                         is a column vector; refers to the gradient of
% objective function with respect to parameter x.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    n = length(x);
    f1 = 0;
    g1 = zeros(n, 1);
                
    if bounds.active
        switch bounds.methodFlag
            case 'simpleProj'
                x = bsPFunc(x, bounds);
                
            otherwise
                xLowerBound = bounds.lower;
                xUpperBound = bounds.upper;
    
                lLogical = x < xLowerBound;
                rLogical = x > xUpperBound;
                n = length(x);
                
                xml = xLowerBound(lLogical) - x(lLogical);
                rmx = x(rLogical) - xUpperBound(rLogical);
                        
                switch bounds.methodFlag
                    case 'linearPenalty'
                        
                        f1 = bounds.weight * (sum(xml) + sum(rmx));
                        g1 = bounds.weight * (-double(lLogical) + double(rLogical) );

                    case 'quadPenalty'
                        f1 = bounds.weight * 0.5 * (sum(xml.^2) + sum(rmx).^2);
                        g1 = zeros(n, 1);
                        g2 = zeros(n, 1);
                        g1(lLogical) = -xml;
                        g2(rLogical) = rmx;
                        g1 = bounds.weight * (g1 + g2);
                end
        end
    end
    
    [f2, g2] = bsSumFuncs(x, fcnPkgs);
    
    f = f1 + f2;
    g = g1 + g2;
    
end