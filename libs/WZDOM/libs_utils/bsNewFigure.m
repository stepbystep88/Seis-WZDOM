function bsNewFigure(nRow, nCol, style)

    figure;
    
    
    if nargin == 0
        set(gcf, 'position', [ 200         200        520    420]);
        subplot('Position', [0.1 0.13 0.86 0.83]);
    elseif nargin == 2 || strcmp(style, 'normal')
        switch nRow
            case 1
                switch nCol
                    case 1
                    case 2
                end
            case 2
                switch nCol
                    case 1
                end
            case 3
                switch nCol
                    case 1
                end
        end
        
    end
end