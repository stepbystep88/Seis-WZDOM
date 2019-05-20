function [xNew, fNew, gNew, pk, stp, nfev, algInfo] = bsMoveOneStepWithDDM(optAlgFcn, objFcn, optAlgParam, xk, algInfo, iter, DDM, stp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is to move one step using DDM method
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
% xk: current model parameter
%
% algInfo: a struct recording optimization algorithm information
%
% iter: iteration number index
%
% DDM: descent direction algorithm parameters
%
% -------------------------------------------------------------------------
% Output
%
% xNew: the update model parameter
%
% fNew: the update objective function value at xNew
%
% gNew: the update gradient at xNew
%
% pk: the update descent direction 
% 
% stp: the step size searched in the current iteration
% 
% nfev: the number of function evaluations
% 
% algInfo: update optimization algorithm information.
% -------------------------------------------------------------------------

    % get the descent direction of last time.
    pOld = algInfo.pOld;
    
    if nargin(optAlgFcn) == 3
        [pk, fk, gk, algInfo] = optAlgFcn(xk, objFcn, algInfo);
    else
        [pk, fk, gk, algInfo] = optAlgFcn(xk, objFcn, algInfo, optAlgParam);
    end
    
    % we need to save the latest basic update information in algInfo
    algInfo.pOld = pk;
    algInfo.fOld = fk;
    algInfo.gOld = gk;
    algInfo.xOld = xk;
    
    algInfo.iter = iter;
    
    if(pk' * gk > 0)
        pk = -gk;
    end
    
    if(iter > 1 && DDM.active)

        DDMCoef = DDM.coefficient * DDM.scaleFactor ^ (iter - 1);

        % if use the DDM method, we update the descent direction
        tpk = (1-DDMCoef) * pk/norm(pk) + DDMCoef * pOld/norm(pOld);
     
        if gk' * tpk < 0
        % check whether the updated direction is a descent direction
            pk = tpk;
            % we have to update the descent direction saved in algInfo.
            algInfo.pOld = pk;
        end
    end
    
%     arc_handle = @(stp_param) line_arc(stp_param, pk);
%     [xNew, fNew, gNew, stp, flag, nfev] = mtasrch(...
%         objFcn, ...
%         xk, ...
%         fk, ...
%         gk, ...
%         arc_handle, ...
%         1, ...
%         0, ...
%         1e-4, ...
%         0.9, ...
%         1e-8, ...
%         0, ...
%         1e10, ...
%         100);
    [xNew, fNew, gNew, stp, flag, nfev] = cvsrch(objFcn, length(xk), xk, fk, gk, pk, 1, 0.0001, 0.9, 1e-7, 0, 1e10, 40); 
    
    if flag == 6
        warning('Warning in step size search subroutine. There may not be a step which satisfies the sufficient decrease and curvature conditions.');
    end
    
    nfev = nfev + 1;    % + 1 is because the objective function is called in the optimization algorithm optAlgFcn.
    
end