%% this script tests different regularization methods for seismic inverion
% for each regularization method, this routine just uses the default
% parameters. To see more advanced function, please see
% testPostSeisDifferentRegs.m as examples.
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
SNR = 10;            % signal to noise ratio
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
    
    %% the following code estimates impedance using different regularization methods with default parameter 
    % In addition, it should be noted that each case will select the best parameter by
    % L-curve authomatically.
   
    % flags of all test methods
    testMethods = {'TV-SB', 'TV', 'TK', 'JTT', 'PS', 'PL'};
    nRegFuncs = length(testMethods);
    
    results = cell(1, nRegFuncs);
    
    for iMethod = 1 : nRegFuncs
        methodFlag = testMethods{iMethod};
        
        [res.xOut, res.fval, res.exitFlag, output] = bsSeisInv1DTrace(methodFlag, d, G, xInit);
        res.caseNmae = methodFlag;
        res.midResults = output.midResults;
        results{iMethod} = res;
    end
    
    
    %% compare the results of different methods.
    testPostSeisShowDifferentRegs;
end

