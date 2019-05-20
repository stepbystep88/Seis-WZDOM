function [poststackFreeNoise, poststackNoise, poststackBandPassNoise, G] = bsGenPostSynSeis(trueModel, waveletFreq, dt, SNR, isReadMode, modelSavePath, varargin)
%% generate synthetic data based on trueModel, waveletFreq, dt, SNR
%
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programmed dates: May 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% trueModel: impedance model, 1D or 2D, each column vector represents a
% trace
%
% waveletFreq: the domain frequency of Ricker wavelet
%
% dt: sampling interval (ms)
%
% SNR: the signal to noise ratio, for adding noise on synthetic data
%
% isReadMode: if it is true, the data will be read from modelSavePath
%
% modelSavePath: the path to save the generated data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
% 
% poststackFreeNoise: noise-free synthetic seismic data
%
% poststackNoise: noise added seismic data
%
% poststackBandPassNoise: band limited noise added seismic data
% 
% G: forward operator made by wavelet
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    p = inputParser;
    
    addParameter(p, 'freqLowPass', 5);      % the low cutoff frequency
    addParameter(p, 'freqHighPass', 100);   % hight cutoff frequency
    % function handle for adding noise, default is to use awgn function
    addParameter(p, 'addNoiseFcn', @(x, SNR)(awgn(x, SNR, 'measured')));    

    p.parse(varargin{:});  
    params = p.Results;
    
    sampNum = size(trueModel, 1);
    
    logModel = log(trueModel);
    
    if( isReadMode )
        load( modelSavePath );
    else
        D = bsGen1DDiffOperator(sampNum, 1, 1);
        W = bsWaveletMatrix(sampNum-1, waveletFreq, dt);
        G = 0.5 * W * D;
        poststackFreeNoise = G * logModel;
        
        poststackNoise = params.addNoiseFcn(poststackFreeNoise, SNR);
        poststackBandPassNoise = bsButtBandPassFilter(poststackNoise, dt, params.freqLowPass, params.freqHighPass);

        
        if ~isempty(modelSavePath)
            save(modelSavePath, 'poststackFreeNoise', 'poststackNoise', 'G', 'poststackBandPassNoise')
        end
    end
end








