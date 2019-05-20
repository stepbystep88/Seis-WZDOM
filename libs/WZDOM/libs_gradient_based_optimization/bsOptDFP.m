function [pk, fk, gk, algInfo] = bsOptDFP(xk, objFcn, algInfo) 
%% the DFP algorithm which performs only one step to generate the descent direction
% This code is implemented according by 
% https://en.wikipedia.org/wiki/Davidon%E2%80%93Fletcher%E2%80%93Powell_formula
% 
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programmed dates: May 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
% xk            is the current input parameter.
%
% objFcn        objective function, shaped like [f, g] = objFcn(xk) whose
% input is xk, the output is the objective function value f and gradient
% information calculated at x
%
% algInfo       is a struct; algInfo.iter == 0 when this function is called 
% at the first time. Otherwise, it saves some information for latter
% update, such as the gradient and descent direction at the last time.
% algInfo.pOld, algInfo..gOld, algInfo.xOld -> represent the descent 
% direction, gradient and % parameter at last iteration, respectively.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
%
% pk            is a column vector; refers to the current descent direction
%
% fk            is a scalar; refers to the current value of objective function. 
%
% gk            is a column vector; refers to the current gradient.
%
% algInfo       
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [fk, gk] = objFcn(xk);
    
    if algInfo.iter == 1
        % it means this is the first time to perform this algorithm
        n = length(xk);
        algInfo.Bk = eye(n); 
        algInfo.I = eye(n);
        
        pk = -gk;
    else
        
        sk = xk - algInfo.xOld; 
        yk = gk - algInfo.gOld; 
        By = algInfo.Bk * yk;
        
        ykTsk = yk' * sk;
        ykTBy = yk' * By;
        if ykTsk < 1e-8 || abs(ykTBy) < 1e-8
            pk = -gk;
        else
            
            algInfo.Bk = algInfo.Bk - By'*By/ykTBy + sk'*sk/ykTsk;

            pk = -algInfo.Bk * gk;
        end

    end

end 
 
