function stpSubPlotFit( M, N, index, lw, lh, mdw, mdh, left, below)

    
    dw = lw/N;  dh = lh/M;
    w = dw - mdw; h = dh - mdh;
    y = floor( (index(1)-1) / N);
    x = mod(index(1)-1, N);

    xe = mod(index(end)-1, N);
    wn = (xe-x)*dw + w;

    px = x*(dw+0.005) + left;
    py = 1.0-(y+1)*dh + below + below*(M-y-1)*0.2;
    
    subplot('Position', [px py wn h]);
    
end

