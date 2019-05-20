function [pk, fk, gk, algInfo] = bsOptQCG(xk, objFcn, algInfo, params) 
%% the QCG algorithm which performs only one step to generate the descent direction
% This code is implemented according by 
% https://www.sciencedirect.com/science/article/pii/S0926985118304324?via%3Dihub
% and https://www.sciencedirect.com/science/article/pii/S0926985113001456
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
        betak = 0;
    else
        gkMgkold = gk-algInfo.gOld;
        
        switch params.updateFlag
            case 'FR'
                % Fletcher-Reeves
                if algInfo.gkTgkold > 0
                    betak = gkTgk/algInfo.gkTgkold;
                else
                    betak = 0;
                end
            case {'PR', ''}
                % Polak-Ribiere
                if algInfo.gkTgkold > 0
                    betak = (gk'*gkMgkold)/algInfo.gkTgkold;
                else
                    betak = 0;
                end
            case 'HS'
                % Hestenes-Stiefel
                
                denom = algInfo.pOld'*gkMgkold;
                if denom > 0
                    betak = (gk'*gkMgkold)/denom;
                else 
                    betak = 0;
                end
                
            case 'DY'
                % Dai–Yuan
                denom = algInfo.pOld'*gkMgkold;
                if denom > 0
                    betak = gkTgk/denom;
                else 
                    betak = 0;
                end
            
            otherwise
                error('Error: updateFlag is not valid. Choices are {FR, PR, HS, DY}');
        end
                        
        betak = max(0, betak);
        
        if algInfo.gkTgkold > 0
            bk = gk' * algInfo.pOld / algInfo.gkTgkold;  
            pk = -gk + betak * algInfo.pOld - bk * gkMgkold;
        else
            pk = -gk + betak * algInfo.pOld;
        end
        
        
    end
        
    algInfo.gkTgkold = gkTgk;
    

end 
 
