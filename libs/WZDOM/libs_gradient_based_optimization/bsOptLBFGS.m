function [pk, fk, gk, algInfo] = bsOptLBFGS(xk, objFcn, algInfo, params) 
%% the LBFGS algorithm which performs only one step to generate the descent direction
% This code is implemented according by http://www.desy.de/~blobel/lvmini.pdf
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [fk, gk] = objFcn(xk);
    
    if algInfo.iter == 1
        % it means this is the first time to perform this algorithm
        n = length(xk);
        
        algInfo.y = zeros(n, params.m);
        algInfo.s = zeros(n, params.m);
        algInfo.rho = zeros(1, params.m);
        
        pk = -gk;
    
        algInfo.index = 1 : params.m;
    else
        iter = algInfo.iter;
        
        if iter <= params.m
            L = iter;
            iNew = iter;
        else
            L = params.m;
            iNew = algInfo.index(1);
            algInfo.index(1:L-1) = algInfo.index(2:L);
            algInfo.index(L) = iNew;
        end
        
        algInfo.y(:, iNew) = gk - algInfo.gOld;
        algInfo.s(:, iNew) = xk - algInfo.xOld;
        demo1 = algInfo.y(:, iNew)' * algInfo.s(:, iNew);
        demo2 = algInfo.y(:, iNew)' * algInfo.y(:, iNew);
        
        if abs(demo1) > 1e-8 && abs(demo2) > 1e-8
            algInfo.rho(iNew) = 1 / demo1;
        
            % two-loop recursion with memory = params.m
            gammak = (algInfo.s(:, iNew)' * algInfo.y(:, iNew)) / demo2;
            q = gk;
            alpha = zeros(1, L);

            for j = L : -1 : 1
                i = algInfo.index(j);

                alpha(i) = algInfo.rho(i) * (algInfo.s(:, i)' * q);
                q = q - alpha(i) * algInfo.y(:, i);
            end

            r = gammak * q;

            for j = 1 : L
                i = algInfo.index(j);

                beta = algInfo.rho(i) * (algInfo.y(:, i)' * r);
                r = r + algInfo.s(:, i) * (alpha(i) - beta);
            end

            pk = -r;
        else
            pk = -gk;
        end
        
        
        
    end
    
end 
 
