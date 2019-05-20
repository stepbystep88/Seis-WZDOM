function coef = bsRandCoefByLevy()

    data = bsLevy(1, 10, 1.5);
    data = data ./ (max(abs(data)) + 0.01);
    
    index = randi([1 10]);
    coef = data(index);
end