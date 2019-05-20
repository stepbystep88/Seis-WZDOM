function [pk, fk, gk, algInfo] = bsOptCG(xk, objFcn, algInfo, params) 
%% the conjugate gradient algorithm algorithm which performs only one step to generate the descent direction
% This code is implemented according by https://en.wikipedia.org/wiki/Nonlinear_conjugate_gradient_method
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
% % params      the parameters of this optimization algorithm. Specially,
% for LBFGS algorithm, it only has parameter params.m, namely, the number of the 
% most recent vectors saved in memory is options.params.m 
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
    gkTgk = gk'*gk;
    
    if algInfo.iter == 1
        % it means this is the first time to perform this algorithm
        pk = -gk;
        bk = 0;
    else
        switch params.updateFlag
            case 'FR'
                % Fletcher-Reeves
                if algInfo.gkTgkold > 0
                    bk = gkTgk/algInfo.gkTgkold;
                else
                    bk = 0;
                end
            case 'PR'
                % Polak-Ribiere
                gkMgkold = gk - algInfo.gOld;
                if algInfo.gkTgkold > 0
                    bk = (gk'*gkMgkold)/algInfo.gkTgkold;
                else
                    bk = 0;
                end
            case 'HS'
                % Hestenes-Stiefel
                gkMgkold = gk-algInfo.gOld;
                denom = algInfo.pOld'*gkMgkold;
                if denom > 0
                    bk = (gk'*gkMgkold)/denom;
                else 
                    bk = 0;
                end
                
            case 'DY'
                % Dai–Yuan
                gkMgkold = gk-algInfo.gOld;
                denom = algInfo.pOld'*gkMgkold;
                if denom > 0
                    bk = gkTgk/denom;
                else 
                    bk = 0;
                end
            
            otherwise
                error('Error: options.CG_UPDATE_FLAG is not valid. Choices are {FR, PR, HS, DY}');
        end
                        
        bk = max(0, bk);
            
        pk = -gk + bk * algInfo.pOld;
    end
        
    algInfo.gkTgkold = gkTgk;
    
end 
 
