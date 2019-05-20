%% this script tests the basical optimization function of WZDOM
%
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programmed dates: May 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------------------------------------------------------%
% Example 1:
% the simpest example on Rosenbrock function
%-------------------------------------------------------------------------%

install;

clc;
clear;
close all;

cprintf('*red', '|------------------------------------------------------------------------------------|\nTest exmaple 1...\n');

nDim = 5;                  % the number of dimensions
objFunc = @bsRosenbrock;        % sphere function
xInit = 10 * randn(nDim, 1);     % initial guess of x, it must be a column vector
Lb = [];
Ub = [];
options = [];

% call the gradient-based solver
[x, fval, exitFlag, output] = bsGBSolver(objFunc, xInit);
cprintf('*red', 'Press any key to continue\n');
pause;


%-------------------------------------------------------------------------%
% Example 2:
% print the iteration information
%-------------------------------------------------------------------------%
cprintf('*red', '|------------------------------------------------------------------------------------|\nTest exmaple 2...\n');
[x, fval, exitFlag, output] = bsGBSolver(objFunc, xInit, Lb, Ub, 'display', 'iter');
cprintf('*red', 'Press any key to continue\n');

pause;

%-------------------------------------------------------------------------%
% Example 3:
% plot middle results during the iteration process
%-------------------------------------------------------------------------%
cprintf('*red', '|------------------------------------------------------------------------------------|\nTest exmaple 3...\n');
[x, fval, exitFlag, output] = bsGBSolver(objFunc, xInit, Lb, Ub, 'isSaveMiddleRes', true);

figure;
plot(1:(output.iterations+1), log10(output.midResults.f), 'r', 'linewidth', 2);
xlabel('The number of iterations');
ylabel('Objective function value (log scale)');
title('Example 3');
bsPlotSetDefault(bsGetDefaultPlotSet());

cprintf('*red', 'Press any key to continue\n');

pause;

%-------------------------------------------------------------------------%
% Example 4:
% more option parameters
%-------------------------------------------------------------------------%
cprintf('*red', '|------------------------------------------------------------------------------------|\nTest exmaple 4...\n');
% for conjagate gradient algorithm the updateFlag of parameter be 'FR', 'PR', 'HS', 'DY', see bsOptCG
optAlgParam.updateFlag = 'PR';  
% right now, optAlgHandle could be @bsOptCG, @bsOptLBFGS, @bsOptBFGS,
% @bsOptDFP, @bsOptSTD
optAlgHandle = @bsOptCG;

[x, fval, exitFlag, output] = bsGBSolver(...
    objFunc, ...
    xInit, ...
    Lb, ...
    Ub, ...
    'isSaveMiddleRes', true, ...
    'optAlgHandle', optAlgHandle, ...   % using conjagate gradient algorithm
    'optAlgParam', optAlgParam, ...
    'maxIter', 90, ...
    'maxFunctionEvaluations', 1000, ... 
    'stepTolerance', 1e-6, ...
    'display', 'iter' ...
    );

cprintf('*red', 'Press any key to continue\n');

pause;

%-------------------------------------------------------------------------%
% Example 5:
% test on multiple functions
%-------------------------------------------------------------------------%
cprintf('*red', '|------------------------------------------------------------------------------------|\nTest exmaple 5...\n');
m = 2000;
n = 200;
% random generate true model
trueX = randn(n, 1);
trueX = bsButtLowPassFilter(trueX, 0.3);
% generate initial guess using a low pass filter
initX = bsButtLowPassFilter(trueX, 0.03);

% get A and B
data.A = rand(m, n);
b = data.A * trueX;
data.B = b +0.01 * randn(m, 1);

% normalization
data.A = data.A / max(abs(data.B(:)));
data.B = data.B / max(abs(data.B(:)));

% regularization parameter
lambda = 0.3;

% this objective function is 
% f(x) = |Ax-B|_2^2 + lambda * |Dx|_1
inputObjFcnPkgs = {@bsLinearTwoNorm, data, 1.0; @bsReg1DTV, [], lambda};
[x, fval, exitFlag, output] = bsGBSolver(...
    inputObjFcnPkgs, ...
    initX, ...
    [], ...
    [], ...
    'display', 'final', ...
    'maxIter', 120, ...
    'optimalX', trueX, ...
    'plotFcn', @bsPlotObjFcnVal... % plotFcn could be @bsPlotModelChange or @bsPlotObjFcnVal
    );

% save the results to gif
bsSaveFramesToGif(output.frames, './pictures/basical_example_5.gif');

cprintf('*red', 'Press any key to continue\n');
pause;


%-------------------------------------------------------------------------%
% Example 6:
% test boundary
%-------------------------------------------------------------------------%
cprintf('*red', '|------------------------------------------------------------------------------------|\nTest exmaple 6...\n');
m = 2000;
n = 200;

trueX = randn(n, 1);
trueX = bsButtLowPassFilter(trueX, 0.3);
initX = bsButtLowPassFilter(trueX, 0.03);

maxVal = max(trueX);
minVal = min(trueX);

Lb = 0.7 * minVal*ones(n, 1);
Ub = 0.7 * maxVal*ones(n, 1);

data.A = rand(m, n);
b = data.A * trueX;
data.B = b +0.01 * randn(m, 1);

% normalization
data.A = data.A / max(abs(data.B(:)));
data.B = data.B / max(abs(data.B(:)));

lambda = 0.3;

% this objective function is 
% f(x) = |Ax-B|_2^2 + lambda * |Dx|_1
% |Ax-B|_2^2 -> @bsLinearTwoNorm; |Dx|_1 -> @bsReg1DTV
inputObjFcnPkgs = {@bsLinearTwoNorm, data, 1.0; @bsReg1DTV, [], lambda};
[x, fval, exitFlag, output] = bsGBSolver(...
    inputObjFcnPkgs, ...
    initX, ...
    Lb, ...
    Ub, ...
    'display', 'iter', ...
    'maxIter', 80, ...
    'optimalX', trueX, ...
    'plotFcn', @bsPlotModelChange...
    );

% save the results to gif
bsSaveFramesToGif(output.frames, './pictures/basical_example_6.gif');
