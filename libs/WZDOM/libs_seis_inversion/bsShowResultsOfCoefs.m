function bsShowResultsOfCoefs(options, optFunc, objFunc, methodName, testMethods, ...
    maxIter, stopCoefficient, coefs, initX, trueX)
    
    nTests = size(testMethods, 1);
    nCoefs = length(coefs);
    nCases = nTests * nCoefs;
    evaluations = [];
    
    iter = 0;
    close all;
    optParameters = {optFunc, objFunc, initX, options, ...
                'isSaveMiddleRes', 1, 'stopCriterion', 4, 'stopCoefficient', stopCoefficient, ...
                'maxIter', maxIter, 'optimalF', 0, 'optimalX', trueX};
    
    
    for iParameter = 1 : nTests
        
        parameters = testMethods{iParameter, 2};
        
        options.DDM.active = parameters{1, 2};
        options.DDM.coefficient = parameters{1, 3};
        options.momentum.methodFlag = parameters{1, 4}; 
        
        caseName = sprintf("%s%s", methodName, parameters{1, 1});
            
        iRes = cell(nCoefs, 8);
        
        for iCoef = 1 : nCoefs
            newOptParameters = optParameters;
            newOptions = options;
            
            newOptions.momentum.coefficient = coefs(iCoef);
            
            if ~isempty(newOptions.momentum.methodFlag) && newOptions.DDM.active
                newOptions.DDM.coefficient = 0.5;
            elseif newOptions.DDM.active
                newOptions.DDM.coefficient = coefs(iCoef);
            end

            fprintf('Using method:%s, coef=%.3f...\n', caseName, coefs(iCoef));

            tic

            newOptParameters{4} = newOptions;
            
            [xOut, midResults, nIter, funVal, ~, nfev] = bsGBSolver(newOptParameters{:});

            timeElapsed = toc;

            % minimum value of the test function, obtain function, RRMSE, iter,
            % gradient
            iRes(iCoef, :) = {xOut, midResults, caseName, funVal, nIter, nfev, timeElapsed, coefs(iCoef)};


        end

        evaluations = [evaluations; iRes];
    end
    
    
%     0.105357142857143 0.126190476190476 0.85 0.823809523809524
    options.DDM = [];
    options.momentum = [];
%     opt
    optParameters{4} = options;
    [xOut, ~, nIter, funVal, ~, nfev] = bsGBSolver(optParameters{:});
                
    % plot the contour map 
%     map = brewermap(nMethods,'Set1');
%     colors = {'b', 'k+-', 'r+-', 'y+--', 'g+--', 'b+--', 'c+-'};
    load colorTbl.mat;
    shapes = {'+', '-*', '-o', '-s', '-<', '-^', '-d', '->', '-v'};
    
    iter = 0;
    strs = cell(1, nTests+1);
%     close all;
    strs{1} = methodName;
    mse_model = sqrt(mse(exp(xOut) - exp(trueX))) / norm(exp(trueX));
    
    figure;
    set(gcf, 'position', [ 405         316        1039/2         363]);
    subplot('Position', [0.105 0.133 0.86 0.81]);
    
%     set(gcf, 'position', [ 405         316        1039/2         363]);
%     subplot('Position', [0.105 0.126 0.85 0.823]);
    
    plot((coefs), ones(1, nCoefs)*mse_model, 'color', colors(1, :),  'linewidth', 2); hold on;
    
    for iTest = 1 : nTests
        xOuts = evaluations(iter+1:iter+nCoefs, 1);
%         fvals = tmp(:, 1);
%         fvals = fvals;
        for k = 1 : length(xOuts)
            mse_models(k) = sqrt(mse(exp(xOuts{k}) - exp(trueX))) ./ norm(exp(trueX));
        end
        
        
        plot((coefs), mse_models, shapes{iTest+1}, 'color', colors(iTest+1, :),  'linewidth', 2); hold on;
        strs{iTest+1} = sprintf("%s", evaluations{iter+1, 3});

        iter = iter + nCoefs;
    end
    
%     set(gca, 'ylim', [-8 2]);
    ylabel('RRMSE of Model');
    xlabel('c or d');
%     set(gca, 'ylim', [3.5 5]*1e-3)

    hlegend = legend(strs, 'Location', 'best');
    set(gca , 'fontsize', 12, 'fontweight', 'bold', 'fontname', 'Times New Roman');  
    hlegend.NumColumns = 2;

    figure;
    set(gcf, 'position', [ 405         316        1039/2         363]);
    subplot('Position', [0.105 0.133 0.86 0.81]);
    
    
%     title(labelOfFigure);
    iter = 0;
    plot((coefs), ones(1, nCoefs)*nIter, 'color', colors(1, :),  'linewidth', 2); hold on;

    for iTest = 1 : nTests
        tmp = cell2mat(evaluations(iter+1:iter+nCoefs, [4, 5]));
        niters = tmp(:, 2);

        plot((coefs), niters, shapes{iTest+1}, 'color', colors(iTest+1, :), 'linewidth', 2); hold on;
        strs{iTest+1} = sprintf("%s", evaluations{iter+1, 3});

        iter = iter + nCoefs;
    end

%     set(gca, 'ylim', [0 nIter * 2]);
    xlabel('c or d');
    ylabel('The number of iterations'); 
    hlegend = legend(strs, 'Location', 'best');
    hlegend.NumColumns = 2;
    set(gca , 'fontsize', 12, 'fontweight', 'bold', 'fontname', 'Times New Roman');  

    figure;
    set(gcf, 'position', [ 405         316        1039/2         363]);
    subplot('Position', [0.105 0.133 0.86 0.81]);
    
    iter = 0;
    plot((coefs), ones(1, nCoefs)*nfev, 'color', colors(1, :),  'linewidth', 2); hold on;

    for iTest = 1 : nTests
        tmp = cell2mat(evaluations(iter+1:iter+nCoefs, [4, 5, 6]));
        niters = tmp(:, 3);

        plot((coefs), niters, shapes{iTest+1}, 'color', colors(iTest+1, :), 'linewidth', 2); hold on;
        strs{iTest+1} = sprintf("%s", evaluations{iter+1, 3});

        iter = iter + nCoefs;
    end

%     set(gca, 'ylim', [0 nIter * 2]);
    xlabel('c or d');
    ylabel('The number of function evaluations'); 
    hlegend = legend(strs, 'Location', 'best');
    hlegend.NumColumns = 2;
    set(gca , 'fontsize', 12, 'fontweight', 'bold', 'fontname', 'Times New Roman');  
    
end


