function ndata = bsGenLaplacianNoise(data, SNR)
    [m, n] = size(data);
    
    NOISE = laprnd(m, n, 0, 10);
    
    signal_power = 1/length(data) * sum( (data - mean(mean(data))).^2);
    noise_power = 1/length(NOISE) * sum(NOISE .* NOISE);
    
    SNR = 10^(SNR / 10);
    noise_variance = signal_power / SNR;
    
    NOISE = sqrt(noise_variance) / sqrt(noise_power) * NOISE;
    
    ndata = data + NOISE;
end