function result = bsButtBandPassFilter(data, dt, lowf, highf)

    ft = 1000 / dt / 2;
    n = 5;
%     [b, a] = butter(n, [lowf/ft, highf/ft], 'bandpass');
%     result = filtfilt(b, a, data);
    
    [b, a]= ellip(n, 3, 30, [lowf/ft, highf/ft]);         
    result = filtfilt(b, a, data);


end