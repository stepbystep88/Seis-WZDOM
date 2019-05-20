%% this script tests the selection of parameters for seismic inverion
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

%% starts to 
% only get the best regularization parameter of trace 102, you can change 
% the loop range
for iTrace = 102 : 102
    
    % the poststack inversion is inverted in logarithm domain
    trueM = trueModel(:, iTrace);
    xTrue = log(trueM);
    xInit = log(initModel(:, iTrace));
    
    % residual term: |Ax-b|_2^2
    mainData.A  = G;
    mainData.B = poststackNoise(:, iTrace);
    mainFunc = @bsLinearTwoNorm;

    % regurization term
    regData.diffOrder = 1;  % the order of difference operator
    maxIter = 100;

    % the input objective function pakages: it refers to the following
    % function:
    % |Ax - B|_2^2 + lambada * |Dx|_1 + 0.001 * |x - x0|_2^2
    % where D is the difference operator
    % x0 is the initial model
    inputObjFcnPkgs = {mainFunc, mainData, 1;  @bsReg1DTV, regData, 0;  @bsReg1DTKInitModel, [], 0.001; };
    
    % organize options by the input, set plotFcn can watch the iteration
    % process of different regularization parameter, but it takes some
    % time.
    options = bsCreateGBOptions(length(xInit), 'maxIter', maxIter, 'display', 'off', 'plotFcn', @bsPlotModelChange, 'optimalX', xTrue);
%     options = bsCreateGBOptions(length(xInit), 'maxIter', maxIter, 'display', 'off');
    
    % get the best lambda by L-Curve method
    tic
    bestLambda = bsBestParameterByLCurve(lambdas, inputObjFcnPkgs, xInit, [], [], options, 1);
    cprintf('*red', sprintf('The best regularization choosen by L-curve is %d\n', bestLambda));
    toc
    
    % get the best lambda by bisection method
    tic
    bestLambda = bsBestParameterByBisection(xTrue, -15, 15, 10, inputObjFcnPkgs, xInit, [], [], options);
    cprintf('*red', sprintf('The best regularization choosen by bisection is %d\n', bestLambda));
    toc
    
    % get the best lambda by linear search method
    options = bsCreateGBOptions(length(xInit), 'maxIter', maxIter, 'display', 'off');
    tic
    bestLambda = bsBestParameterBySearch(lambdas, xTrue, inputObjFcnPkgs, xInit, [], [], options, 1);
    cprintf('*red', sprintf('The best regularization choosen by linear search is %d\n', bestLambda));
    toc
end

