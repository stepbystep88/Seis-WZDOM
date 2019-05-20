function [f, g] = bsNonSmooth(z)
    x = z(1);
    y = z(2);
    
    f = 10 * abs(x) + abs(y);
    
    if x > 1e-5
        g1 = 10;
    elseif x < -1e-5
        g1 = -10;
    else
        g1 = sign(x) * rand(1) * 10;
    end
    
    if y > 1e-5
        g2 = 1;
    elseif y < -1e-5
        g2 = -1;
    else
        g2 = sign(y) * rand(1);
    end
%     
    g = [g1; g2];
    g = [sign(x)*10; sign(y)];

end