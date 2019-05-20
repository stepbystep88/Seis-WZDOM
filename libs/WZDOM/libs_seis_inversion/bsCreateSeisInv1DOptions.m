function [options] = bsCreateSeisInv1DOptions(nDim, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is designed for genearating the options for bsSeisInv1DTrace
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
% of calculating the objective function. see the comments of the code below
% to know the option parameters it has
% -------------------------------------------------------------------------

    %% parse some basic parameters for this process
    parser = inputParser;
    
    % some basica informations
    % for search the best lambda
    
    % set the function handle of searching optimal regularization parameter
    addParameter(parser, 'searchRegParamFcn', @bsBestParameterByLCurve);   
    
    % the following three parameter is set for bisection function
    % see bsBestParameterByBisection
    addParameter(parser, 'logRegParamLeft', -10);
    addParameter(parser, 'logRegParamRight', 5);
    addParameter(parser, 'searchRegParamNIter', 8);
    
    % a sequence of regularization parameters, it will be used for function
    % bsBestParameterByLCurve and bsBestParameterBySearch
    addParameter(parser, 'regParams', exp(-10:5));
    
    % the max iteration number performed for each lambda (it will perform 
    % GBSolver to get the final residual data error and regularization term
    % at each lambda)
    addParameter(parser, 'searchRegMaxIter', 50);
    
    % set the true model of parameter, it must be given when using search
    % subroutine bsBestParameterBySearch and bsBestParameterByBisection
    addParameter(parser, 'optimalX', []);
    
    
    % the options for bsGBSolver
    addParameter(parser, 'GBOptions', bsCreateGBOptions(nDim));
    
    % whether to add low frequence component constraint |x-x0|_2^2, default
    % is yes
    addParameter(parser, 'addLowFreqConstraint', 1);
    % the coeficient of the low frequence component constraint |x-x0|_2^2
    % term
    addParameter(parser, 'initRegParam', 0.001);
    
    % the number of properties to estimated, it is poststack inversion when
    % nSegments = 1
    addParameter(parser, 'nSegments', 1);
    
    % the max inner iteration number when using Split-Bregman or ADMM
    % algorithm
    addParameter(parser, 'innerIter', 5);
    
    % the max outter iteration number 
    addParameter(parser, 'maxIter', 100);
    
    % set default function to measure residual data error 
    addParameter(parser, 'mainFunc', @bsLinearTwoNorm );
    
    % set default regularization function
    addParameter(parser, 'regFunc', @bsReg1DTV );
    
    parser.parse(varargin{:});  
    options = parser.Results;
   
end
