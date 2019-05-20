function [ W ] = bsWaveletMatrix( sampNum, waveletFreq, dt)

    wavelet = bsGenRickerWavelet(waveletFreq, dt);
    
    [~, ix] = max(abs(wavelet));

    Wmatrix = convmtx(wavelet, sampNum);
    W = Wmatrix(ix : ix+sampNum-1, :);
    
end

function [wavelet] = bsGenRickerWavelet(freq, dt)
    wave = s_create_wavelet({'type','ricker'}, {'frequencies', freq}, {'step', dt}, {'wlength', 120});   
    wavelet = wave.traces;                                      
end

