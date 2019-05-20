function result = bsButtLowPassFilter(data, Wn)

    [b, a] = butter(10, Wn, 'low');
    result = filtfilt(b, a, data);
end