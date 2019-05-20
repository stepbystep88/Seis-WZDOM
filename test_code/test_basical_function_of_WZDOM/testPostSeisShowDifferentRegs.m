%% This code is only for showing the results, you should run
% testPostSeisDifferentRegs.m or testPostSeisDifferentRegsUsingDaufault first.
%
% Programmed by Bin She (bin.stepbystep@gmail.com)
% Programmed dates: May 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% close all;

load colorTbl.mat;

nRegFuncs = length(results);

% figure;
nColumn = ceil(nRegFuncs/2);
nx = length(trueM);
initM = exp(xInit);
t = (1500+2*(1 : nx))/1000;
ps = 150;
pe = length(initM);  



for k = 1 : 2
    figure;
%     set(gcf, 'position', [ 405         316        1039         363]);
% set(gcf, 'position', [1          41        1920         963]);
% set(gcf, 'position', [ 371         188        1206         776]);
    set(gcf, 'position', [  371         188        1247         717]);
    
    for iRegFunc = 1 : 1 : nRegFuncs
    %     subplot('Position', [0.1 0.11 0.86 0.83]);
    %     subplot(1, 2, 1);
    %     bsSubPlotFit(2, nColumn, iRegFunc, 0.97, 0.98, 0.04, 0.06, 0.03, 0.03);
        bsSubPlotFit(2, nColumn, iRegFunc, 0.94, 0.9, 0.02, 0.05, 0.05, 0);
    %     bsSubPlotFit(2, nColumn, iRegFunc, 0.97, 0.98, 0.07, 0.08, 0.06, 0.06);

        result = results{iRegFunc};
        ImpRes = exp(result.xOut);

        plot(initM(ps:pe)/1000, t(ps:pe), 'g', 'linewidth', 2); hold on;
        plot(trueM(ps:pe)/1000, t(ps:pe), 'b--', 'linewidth', 2); hold on;
    %     plot(lb(ps:pe), t(ps:pe), 'g--', 'linewidth', 2); hold on;
    %     plot(ub(ps:pe), t(ps:pe), 'g--', 'linewidth', 2); hold on;
        plot(ImpRes(ps:pe)/1000, t(ps:pe), 'r', 'linewidth', 2); hold on;

        title(sprintf('(%s) %s', 'a'+iRegFunc-1, result.caseNmae));

        if mod(iRegFunc, nColumn) == 1
            ylabel('Time (s)');
        else
            set(gca, 'ytick', [], 'yticklabel', [])
        end
        
        if floor((iRegFunc - 1)/nColumn) < 1
            set(gca, 'xtick', [], 'xticklabel', [])
        else
            xlabel('Impedance (g/cm^3 \cdot km/s)');
        end

        set(gca,'ydir','reverse');
        if k == 1
            set(gca,'ylim',[t(ps) t(pe)]);
            set(gca,'xlim',[min(trueM(ps:pe)/1000)-0.5 max(trueM(ps:pe)/1000)+0.5]);
            rectangle('Position', [5  2 5 0.2 ], 'EdgeColor', 'k', 'LineWidth', 1, 'LineStyle', '--');
            if(iRegFunc == 1)
            	legend('Initial model', 'True model', 'Inversion result');
            end
        
        else
            set(gca,'ylim',[2 2.2]);
            set(gca,'xlim',[5 10]);
        end
        
%         bsTextSeqIdFit(iRegFunc, 0.2, 0.08, 13);

        
    %     set(gca, 'xlim', [7500 14000]/1000);
        set(gca , 'fontsize', 12, 'fontweight', 'bold', 'fontname', 'Times New Roman'); 

    end
end