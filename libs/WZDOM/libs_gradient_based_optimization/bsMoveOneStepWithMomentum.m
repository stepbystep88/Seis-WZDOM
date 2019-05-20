function [data, algInfo] = bsMoveOneStepWithMomentum(optAlgFcn, objFcn, optAlgParam, data, algInfo, DDM, momentum)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is to move one step 
%
% Programmed by: Bin She (Email: bin.stepbystep@gmail.com)
% Programming dates: May 2019
% -------------------------------------------------------------------------
% Input
%
% optAlgFcn: optimization function, shaped like [pk, fk, gk, algInfo] = optAlgFcn(xk, objFcn, algInfo, params) 
% sometimes the argument params may not exist. 
% see bsOptQCG, bsOptLBFGS, bsOptCG
%
% ojbFcn: objective function, shaped like [f, g] = objFcn(x) where f and g is
% objective function value and gradient information at x, respectively.
% 
% optAlgParam: a struct, parameters for optimization algorithm.
%
% data: a struct recording iteration information, incluing the previous and
% current gradient, objective function value, model, step size and so on.
%
% algInfo: a struct recording optimization algorithm information
%
% DDM: descent direction algorithm parameters
%
% momentum: momentum technique parameters
% -------------------------------------------------------------------------
% Output
%
% data: the update iteration information, incluing the previous and
% current gradient, objective function value, model, step size and so on.
% 
% algInfo: update optimization algorithm information.
%
% -------------------------------------------------------------------------

    iter = data.iter;
    algInfo.iter = data.iter;
    
    mu = momentum.coefficient * momentum.scaleFactor ^ (iter - 1);
    muPre = mu / momentum.scaleFactor;

    if ~momentum.active || isempty(momentum.methodFlag)
        [data.xNew, data.fNew, data.gNew, data.pk, data.stp, nfev, algInfo] ...
            = bsMoveOneStepWithDDM(optAlgFcn, objFcn, optAlgParam, data.xOld, algInfo, iter, DDM, data.stp);
    end
%     algInfo.xOld = data.xOld;
    
    switch momentum.methodFlag 
        case 'CM'
            [xNew, data.fNew, data.gNew, data.pk, data.stp, nfev, algInfo] ...
                = bsMoveOneStepWithDDM(optAlgFcn, objFcn, optAlgParam, data.xOld, algInfo, iter, DDM, data.stp);
            
            data.v = mu * data.v + (xNew - data.xOld);
            data.xNew = data.xOld + data.v;
            
        case "NAG"
            if iter == 1
                data.v = data.xOld;
            end
            
            [data.xNew, data.fNew, data.gNew, data.pk, data.stp, nfev, algInfo] ...
                = bsMoveOneStepWithDDM(optAlgFcn, objFcn, optAlgParam, data.v, algInfo, iter, DDM, data.stp);

            if iter == 1
                data.v = data.xNew;
            else
                data.v = data.xNew + mu * (data.xNew - data.xOld);
            end
            
            
        case "Sutskever"
            yOld = data.xOld + mu * data.v;
            
            [yNew, data.fNew, data.gNew, data.pk, data.stp, nfev, algInfo] ...
                = bsMoveOneStepWithDDM(optAlgFcn, objFcn, optAlgParam, yOld, algInfo, iter, DDM, data.stp);

            data.v = mu*data.v + (yNew - yOld);
            data.xNew = data.xOld + data.v;
            
            [data.fNew, data.gNew] = objFcn(data.xNew);
            nfev = nfev + 1;
            
        case "Bengio"
            
            [xNew, data.fNew, data.gNew, data.pk, data.stp, nfev, algInfo] ...
                = bsMoveOneStepWithDDM(optAlgFcn, objFcn, optAlgParam, data.xOld, algInfo, iter, DDM, data.stp);
            gd_step = xNew - data.xOld;
            
            data.xNew = data.xOld + muPre*mu*data.v + (1+mu)*gd_step;
            data.v = mu * data.v + gd_step;
            
            [data.fNew, data.gNew] = objFcn(data.xNew);
            nfev = nfev + 1;
            
        case "AMNAGE"
            [xNew, data.fNew, data.gNew, data.pk, data.stp, nfev, algInfo] ...
                = bsMoveOneStepWithDDM(optAlgFcn, objFcn, optAlgParam, data.xOld, algInfo, iter, DDM, data.stp);
            gd_step = xNew - data.xOld;
            
            data.v = mu * (data.v + gd_step);
            data.xNew = xNew + data.v;
            
            [data.fNew, data.gNew] = objFcn(data.xNew);
            nfev = nfev + 1;
            
        case ""
        otherwise
             % using linear research subroutine to find the best step alpha which satisfies the Wolfe condition.
            error('options.momentum.methodFlag is invalid. Choices are ("CM", "NAG", "Sutskever", "Bengio")');
    end
    
    data.nfev = data.nfev + nfev;
end
