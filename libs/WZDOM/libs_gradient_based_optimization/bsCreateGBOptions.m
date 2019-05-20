function [options] = bsCreateGBOptions(nDim, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is designed for genearating the options for bsGBSolver
%
% Programmed by: Bin She (Email: bin.stepbystep@gmail.com)
% Programming dates: May 2019
% -------------------------------------------------------------------------
% Input
% 
% nDim: the number of dimensions of variables
%
% -------------------------------------------------------------------------
% Output
%
% options: is a struct which contains the data and infomation of the way
% of calculating the objective function. 
% 
% -------------------------------------------------------------------------
% some other option parameters
% 
% optMethod     is a function handle; refers to the iterative algorithm,
% namely, STD, CG, LBFGS, QCG. Its shape should be :
% [pk, algInfo] = optMehtod(xk, objFcn, algInfo), where xk is the current estimated
% parameter, pk is the output descent direction, algInfo is some
% information needed in searching pk of the algorithm, and algInfo.iter = 0 
% when the optMehtod function is called at the first time.
%
% isSaveMiddleRes: whether to save the middle results during the iteration 
% process.
%
% bounds: for boundary contidtion
%
% DDM: for controlling descent direction memory method
% 
% momentum: for controlling momentum technique
%
% -------------------------------------------------------------------------

    %% parse some basic parameters for this process
    p = inputParser;
    
    % some basica informations
    p = bsAddBasicalParameters(p, nDim);
    
    addParameter(p, 'optAlgHandle', @bsOptLBFGS);
    addParameter(p, 'optAlgParam', []);
    addParameter(p, 'bounds', []);
    addParameter(p, 'DDM', []);
    addParameter(p, 'momentum', []);
    
    p.parse(varargin{:});  
    options = p.Results;
%     options.optAlgHandle = p.Results.optAlgHandle;

    
    %% check the optimization algorithm
    switch func2str(options.optAlgHandle)
        case 'bsOptLBFGS'
            [~, options.optAlgParam]  = bsGetFieldsWithDefaults(options.optAlgParam, {'m', 10});
            validateattributes(options.optAlgParam.m, {'double'}, {'>=', 1});
            
        case {'bsOptQCG', 'bsOptCG'}
            [~, options.optAlgParam]  = bsGetFieldsWithDefaults(options.optAlgParam, {'updateFlag', 'PR'});
            validatestring(string(options.optAlgParam.updateFlag), ["PR", "FR", "HS", "DY"]);
    end
    
    %% check bound constraint, the information is saved in options.bounds
    
    
    [~, options.bounds]  = bsGetFieldsWithDefaults(options.bounds, ...
        {'active', 0; 'methodFlag', 'simpleProj'; 'weight', 1000; 'weightIncr', 1});

    % check whether to use the descent direciton memory (DDM) function.
    % if options.DDM.active is set to 1, we will update the descent direction by 
    % (1-coefficient) * pk + coefficient * pOld;
    [~, options.DDM]  = bsGetFieldsWithDefaults(options.DDM, {'active', 0; 'coefficient', 0.1; 'scaleFactor', 0.98});
    validateattributes(options.DDM.coefficient, {'double'}, {'>=', 0});
    
    % check whether to use the momentum function
    % if options.momentum.active is set to 1, the momentum technique will be used.
    % options.momentum.scaleFactor is the scale factor.
    [~, options.momentum]  = bsGetFieldsWithDefaults(options.momentum, ...
        {'active', 0; 'methodFlag', ''; 'coefficient', 0.2; 'scaleFactor', 0.98});
    validateattributes(options.momentum.coefficient, {'double'}, {'>=', 0});
    
end
