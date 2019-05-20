function [pk, fk, gk, algInfo] = bsOptBFGS(xk, objFcn, algInfo) 
%% the BFGS algorithm which performs only one step to generate the descent direction
% This code is implemented according by https://en.wikipedia.org/wiki/Broyden%E2%80%93Fletcher%E2%80%93Goldfarb%E2%80%93Shanno_algorithm
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
        
        ykTsk = yk' * sk;
        
        if ykTsk < 1e-8
            pk = -gk;
        else
            yts = 1 / (yk' * sk);
            D = yts * yk * sk';
            Vk = algInfo.I - D;
            Vk2 = algInfo.I - D';
            algInfo.Bk = Vk2 * algInfo.Bk * Vk + yts * (sk * sk');

            pk = -algInfo.Bk * gk;
        end
        
          
    end
    
end 
 
