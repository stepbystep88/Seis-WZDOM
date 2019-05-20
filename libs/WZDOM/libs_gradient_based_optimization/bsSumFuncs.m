function [f, g] = bsSumFuncs(x, ofunc)
%% sum the objective function value and gradient of all functions in options.func
% Bin She, bin.stepbystep@gmail.com, April, 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
% x                         is a column vector; refers to the parameter to be estimated.
%
% ofunc              a struct saving all the information of the objective function.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
%
% f                     	is a scalar; refers to the value of objective function.
%
% g                         is a column vector; refers to the gradient of
% objective function with respect to parameter x.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    n = length(x);
    
    f = 0;
    g = zeros(n, 1);
    
    % sum all of the objFunc
    if ofunc.isSingleFunc
        objFunc = ofunc.objFunc;
        
        switch nargin(objFunc)
            case 1
                [tf, tg] = objFunc(x);
            case 2
                [tf, tg] = objFunc(x, ofunc.data);
            otherwise
                [tf, tg] = objFunc(x, ofunc.data, 0);
        end
        
        
        f = f + tf;
        g = g + tg;
    else
        for i = 1 : ofunc.nFuncs
            
            objFunc = ofunc.objFuncs{i};
            
            switch nargin(objFunc)
                case 1
                    [tf, tg] = objFunc(x);
                case 2
                    [tf, tg] = objFunc(x, ofunc.data{i});
                otherwise
                    [tf, tg] = objFunc(x, ofunc.data{i}, 0);
            end
            
            f = f + ofunc.weights(i) * tf;
            g = g + ofunc.weights(i) * tg;
        end
    end
end