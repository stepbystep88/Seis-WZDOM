function [pk, fk, gk, algInfo] = bsOptSTD(xk, objFcn, algInfo) 
%% the steepest descent algorithm which performs only one step to generate the descent direction
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    [fk, gk] = objFcn(xk);
    
    pk = -gk;
    
end 
 
