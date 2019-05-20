function out = gradfunction(functname,x)
    % hubber function µÄÌÝ¶È
    global globalA globalB threshold;

    n = length(globalB);
    out = zeros(n, 1);

    z = globalA * x -globalB;

    for i = 1 : n
        temp = z(i, 1) / threshold;
        if( temp > 1)
            temp = 1;
        end

        if(temp < -1)
            temp = -1;
        end

        z(i, 1) = temp;
    end

    out = globalA' * z;
    
    out = out';
end