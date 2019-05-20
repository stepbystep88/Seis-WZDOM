function stpTextSeqIdFit(i, a, b, fontsize)

    if ~exist('fontsize', 'var')
        fontsize = 12;
    end
    
    xlim = get(gca, 'xlim');
    ylim = get(gca, 'ylim');
    
    x = xlim(1) - (xlim(2) - xlim(1))*a;
    y = ylim(1) - (ylim(2) - ylim(1))*b;
    ichar = 'a' + i - 1;
    
    text(x, y, sprintf('%s)', ichar), 'fontsize', fontsize, 'fontweight', 'bold', 'fontname', 'Times New Roman');
    
end