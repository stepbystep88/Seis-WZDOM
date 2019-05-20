%% this script tests different regularization methods for seismic inverion
%
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programmed dates: May 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

install;

close all; 
clear;
load model.mat;

% prepare data
nTrace = size(poststackFreeNoise, 2);

% these are some basical parameters for generating the synthetic data.
iter = 0;
waveletFreq = 15;   % domain frequency of wavelet
dt = 2;             % sampling interval
SNR = 4;            % signal to noise ratio
isReadMode = 0;     % whether to read from a file
modelSavePath = sprintf('./data/syn_data_SNR_%d.mat', SNR);

% generating synthetic data
[poststackFreeNoise, poststackNoise, poststackBandPassNoise, G] ...
    = bsGenPostSynSeis(trueModel, waveletFreq, dt, SNR, isReadMode, modelSavePath);

% generate initial model
filtCoef = 0.04;
initModel = bsButtLowPassFilter(trueModel, filtCoef);

% a sequence of lambdas, generated as 
logLambdas = -10 : 1;
lambdas = exp(logLambdas);

%% plot the model and synthetic data
figure;
subplot(2, 2, 1);
imagesc(trueModel); colorbar; title('True model');
subplot(2, 2, 2);
imagesc(initModel); colorbar; title('Initial model');
subplot(2, 2, 3);
imagesc(poststackFreeNoise); colorbar; title('Noise-free seismic data');
subplot(2, 2, 4);
imagesc(poststackNoise); colorbar; title('Seismic data with noise');

for iTrace = 103 : 103
    
   
    % the poststack inversion is inverted in logarithm domain
    trueM = trueModel(:, iTrace);
    xTrue = log(trueM);
    xInit = log(initModel(:, iTrace));
    
    % observed data d
    d = poststackNoise(:, iTrace);
    mainFunc = @bsLinearTwoNorm;

    % regurization term
    maxIter = 50;
    nInnerIter = 5;
    searchLambdaNIter = 8;
    rho = 0.01;
    eta = 20;
    
    % if you don't want to watch the animation, you can set plotFcn to []
    plotFcn = @bsPlotModelChange;
%     plotFcn = [];
    
    Lb = xInit - 0.3;
    Ub = xInit + 0.3;
%     Lb = [];
%     Ub = [];
    
    GBOptions = bsCreateGBOptions(length(xInit), ...
        'display', 'notify', ...
        'plotFcn', plotFcn, ...
        'isSaveMiddleRes', true...
    );
    
    [seisInvOptions] = bsCreateSeisInv1DOptions(length(xInit), ...
        'optimalX', xTrue, ...
        'searchRegParamFcn', @bsBestParameterByLCurve, ...
        'maxIter', maxIter, ...
        'innerIter', nInnerIter, ...
        'addLowFreqConstraint', true, ...
        'initRegParam', rho, ...
        'GBOptions', GBOptions ...
        );

    %% test First-order TV-SB
    TV.diffOrder = 1;
    TV.eta = eta;
    
    % you can also give the regularization parameter (the 7th argument)
    % then it just use the set regularization parameter rather than performing a search process
    tic
    [res.xOut, res.fval, res.exitFlag, output] = bsSeisInv1DTrace('TV-SB', d, G, xInit, Lb, Ub, [], TV, seisInvOptions);
    TVLambda1 = output.regParam;
 
    toc
    res.caseNmae = '1st-TV';
    res.midResults = output.midResults;
    results{1} = res;
    
    %% test Second-order TV-SB
    TV.diffOrder = 2;
    tic
    [res.xOut, res.fval, res.exitFlag, output] = bsSeisInv1DTrace('TV-SB', d, G, xInit, Lb, Ub, [], TV, seisInvOptions);
    TVLambda2 = output.regParam;
    toc
    res.caseNmae = '2nd-TV';
    res.midResults = output.midResults;
    results{2} = res;
    
    %% test Third-order TV-SB
    TV.diffOrder = 3;
    tic
    [res.xOut, res.fval, res.exitFlag, output] = bsSeisInv1DTrace('TV-SB', d, G, xInit, Lb, Ub, [], TV, seisInvOptions);
    TVLambda3 = output.regParam;
    toc
    res.caseNmae = '3rd-TV';
    res.midResults = output.midResults;
    results{3} = res;
    
    %% set the max iteration as maxIter * nInnerIter / 5 since MGS, TK and JTT do not have inner iterations
    seisInvOptions.maxIter = maxIter * nInnerIter / 5;
    
    %% test MGS
    tic
    MGS.diffOrder = 1;
    MGS.beta = 0.015;
    [res.xOut, res.fval, res.exitFlag, output] = bsSeisInv1DTrace('MGS', d, G, xInit, Lb, Ub, [], MGS, seisInvOptions);
    MGSLambda = output.regParam;
    toc
    res.caseNmae = 'MGS';
    res.midResults = output.midResults;
    results{4} = res;
    
    
    %% test Tikhonov method, for smoothness
    TK.diffOrder = 2;
    tic
    [res.xOut, res.fval, res.exitFlag, output] = bsSeisInv1DTrace('TK', d, G, xInit, Lb, Ub, [], TK, seisInvOptions);
    TKLambda1 = output.regParam;
    toc
    res.caseNmae = 'TK';
    res.midResults = output.midResults;
    results{5} = res;
    
    %% test Joint TV and TK
    tic
    JTT.diffOrder1 = 1;
    JTT.diffOrder2 = 2;
    JTT.alpha = 0.97;
    [res.xOut, res.fval, res.exitFlag, output] = bsSeisInv1DTrace('JTT', d, G, xInit, Lb, Ub, [], JTT, seisInvOptions);
    JTTLambda = output.regParam;
    toc
    res.caseNmae = 'Joint TV and TK';
    res.midResults = output.midResults;
    results{6} = res;

    %% test Picewise smooth
    seisInvOptions.maxIter = maxIter;
    
    params.diffOrder1 = 1;
    params.diffOrder2 = 2;
    params.eta = eta;
    params.rho = rho;
    params.alpha = 0.2;
    
    % this method need two lambdas, we have obtained them from the previous
    % methods. 
    regParam.lambda1 = TVLambda1;
    regParam.lambda2 = TKLambda1;
    
    tic
%     seisInvOptions.findBestRegParam = false;
    [res.xOut, res.fval, res.exitFlag, output] = bsSeisInv1DTrace('PS', d, G, xInit, Lb, Ub, regParam, params, seisInvOptions);
    lambdaPS = output.regParam;

    toc
    res.caseNmae = 'Piecewise smooth';
    res.midResults = output.midResults;
    results{7} = res;
    
    %% test Picewise linear
    params.alpha = 0.1;
    
    % this method need two lambdas, we have obtained them from the previous
    % methods. 
    regParam.lambda1 = TVLambda1;
    regParam.lambda2 = TVLambda2;
    
    tic
%     seisInvOptions.findBestRegParam = false;
    [res.xOut, res.fval, res.exitFlag, output] = bsSeisInv1DTrace('PL', d, G, xInit, Lb, Ub, regParam, params, seisInvOptions);
    lambdaPL = output.regParam;
    toc
    res.caseNmae = 'Piecewise Linear';
    res.midResults = output.midResults;
    results{8} = res;

    %% compare the result of different methods.
    testPostSeisShowDifferentRegs;
    
end

