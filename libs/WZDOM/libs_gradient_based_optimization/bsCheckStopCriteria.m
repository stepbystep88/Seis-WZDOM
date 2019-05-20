function [breakFlag, msg] = bsCheckStopCriteria(data, params)
%% check whether stop the iteration process.
%
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programmed dates: May 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% params.optimalityTolerance is a tolerance for the first-order optimality
% measure. see https://www.mathworks.com/help/optim/ug/first-order-optimality-measure.html
%
% params.stepTolerance is a lower bound on the size of a step. 
% If the solver attempts to take a step that is smaller than StepTolerance, the iterations end.

% params.functionTolerance is a lower bound on the change in the value of the objective function during a step. 
% For those algorithms, if |f(xi) – f(xi+1)| < FunctionTolerance, the iterations end.

% params.optimalFunctionTolerance is a lower bound on the residual error in the value of 
% the objective function between f(xi) and the minimum objective function
% value
%
% params.optimalModelTolerance is a lower bound on the residual error in the value of 
% the model between xi and the groundtruth.
%
% params.optimalF -> the minimum objective function value
%
% params.optimalX -> the groundtruth of parameters.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
% 
% breakFlag refers to termination Flags:
% breakFlag = 0: not stop the iteration
% breakFlag = 1 if reaches the max number of function evaluations
% breakFlag = 2 if reaches the max number of iterations
% breakFlag = 3 if the current step size is less than stepTolerance
% breakFlag = 4 if the difference between two adjacent estimated parameters is less than optimalityTolerance
% breakFlag = 5 if the max absolute gradient among all dimensions is less than optimalGradientTolerance
% breakFlag = 6 if the difference between two adjacent objective function value is less than functionTolerance
% breakFlag = 7 if the difference between estimated parameter and the true parameter is less than optimalModelTolerance
% breakFlag = 8 if the difference between the objective function value at the estimated parameter and the true minimum is less than optimalFunctionTolerance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    breakFlag = 0;
    msg = '';
    
    %% check whether to print iteration information
    if strcmp(params.display, 'iter')
        bsPrintIterInfo(data);
    end
    
    %% check stop criteria
    if isfield(data, 'nfev') && data.nfev > params.maxFunctionEvaluations
        breakFlag = 1;
        
        msg = sprintf('Optimization stopped because it reaches the max number of function evaluations %d (ExitFlag=%d).', ...
            params.maxFunctionEvaluations, breakFlag);
        
        bsPrintMessage(data, params.display, msg, 1);
        
        return;
    end
    
    if( isfield(data, 'iter') && data.iter >= params.maxIter )
        breakFlag = 2;
        
        msg = sprintf('Optimization stopped because it reaches the max number of iterations %d (ExitFlag=%d).', ...
            params.maxIter, breakFlag);
        
        bsPrintMessage(data, params.display, msg, 1);
        
        return;
    end
    
    if( isfield(data, 'stp') && data.stp < params.stepTolerance )
        breakFlag = 3;
        
        msg = sprintf('Optimization stopped because the current step size is less than stepTolerance %d (ExitFlag=%d).', ...
            params.stepTolerance, breakFlag);
        
        bsPrintMessage(data, params.display, msg, 0);
        
        return;
    end
    
%     data.xNew->xi+1; data.xOld->xi
    if( isfield(data, 'xOld') && max(abs(data.xNew - data.xOld)) < params.optimalityTolerance )
        
        breakFlag = 4;
        
        msg = sprintf('Optimization stopped because the difference between two adjacent estimated parameters is less than optimalityTolerance %d (ExitFlag=%d).', ...
            params.optimalityTolerance, breakFlag);
        
        bsPrintMessage(data, params.display, msg, 0);
        
        return;
    end
    
%     data.gNew->the gradient at xi+1
    if( isfield(data, 'gNew') && max(abs(data.gNew)) < params.optimalGradientTolerance )
        breakFlag = 5;
        
        msg = sprintf('Optimization stopped because the max absolute gradient among all dimensions is less than optimalGradientTolerance %d (ExitFlag=%d).', ...
            params.optimalGradientTolerance, breakFlag);
        
        bsPrintMessage(data, params.display, msg, 0);
        
        return;
    end

    % data.fNew->f(xi+1); data.fOld->f(xi)
    if( isfield(data, 'fOld') && abs(data.fNew - data.fOld) < params.functionTolerance)
        breakFlag = 6;
        
        msg = sprintf('Optimization stopped because the difference between two adjacent objective function value is less than functionTolerance %d (ExitFlag=%d).', ...
            params.functionTolerance, breakFlag);
        
        bsPrintMessage(data, params.display, msg, 0);
        
        return;
    end
    
    if( ~isempty(params.optimalX) && max(abs(data.xNew - params.optimalX)) < params.optimalModelTolerance )
        breakFlag = 7;
        
        msg = sprintf('Optimization stopped because the difference between estimated parameter and the true parameter is less than optimalModelTolerance %d (ExitFlag=%d).', ...
            params.optimalModelTolerance, breakFlag);
        
        bsPrintMessage(data, params.display, msg, 0);
        
        return;
    end
    
    if( ~isempty(params.optimalF) && abs(data.fNew - params.optimalF) < params.optimalFunctionTolerance )
        breakFlag = 8;
        
        msg = sprintf('Optimization stopped because the difference between the objective function value at the estimated parameter and the true minimum is less than optimalFunctionTolerance %d (ExitFlag=%d).', ...
            params.optimalFunctionTolerance, breakFlag);
        
        bsPrintMessage(data, params.display, msg, 0);
        
        return;
    end
    
    

    
    
end

function bsPrintMessage(data, flag, msg, isNotify)

    switch flag
        case 'off'
            
        case 'notify'
            if isNotify
                cprintf('\n');
                warning(msg);
                cprintf('\n');
            end
        otherwise
            if isNotify
                cprintf('\n');
                warning(msg);
                cprintf('\n');
            else
                cprintf('*Blue', sprintf('\n%s\n', msg));
%                 fprintf(sprintf('\n%s\n', msg));
            end
         
    end
    
    if strcmp(flag, 'final') || strcmp(flag, 'iter')
        bsPrintFinalMessage(data);
    end
end

function bsPrintIterInfo(data)

    if isfield(data, 'stp') 
        if data.iter <= 1
            cprintf([0 0 0], sprintf('\n%20s %20s %20s %20s %20s\n', 'Iteration', 'f(k)', 'stepsize', 'delta(f)', 'norm(delta(x))'));
        end

        cprintf([0 0 0], sprintf('\n%20d %20d %20d %20d %20d %20d\n', data.iter, data.fNew, data.stp, abs(data.fNew-data.fOld), norm(data.xNew-data.xOld)));
     else
        if data.iter <= 1
            cprintf([0 0 0], sprintf('\n%20s %20s %20s %20s\n', 'Iteration', 'f(k)', 'delta(f)', 'norm(delta(x))'));
        end

        cprintf([0 0 0], sprintf('\n%20d %20d %20d %20d %20d\n', data.iter, data.fNew, abs(data.fNew-data.fOld), norm(data.xNew-data.xOld)));

    end
end

function bsPrintFinalMessage(data)

    cprintf('blue', '|------------------------------------------------------------------------------------|\n');
    cprintf('blue', sprintf('Final objective function value: %d\n', data.fNew));
    cprintf('blue', sprintf('The number of iterations: %d\n', data.iter));
    cprintf('blue', sprintf('The number of function evaluations: %d\n', data.nfev));
    cprintf('blue', '|------------------------------------------------------------------------------------|\n');
end