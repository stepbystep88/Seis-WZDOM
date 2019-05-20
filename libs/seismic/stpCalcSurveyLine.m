function [outInIds, outCrossIds] = stpCalcSurveyLine(inIds, crossIds, firstCdp, traceNum)
% 这是一个计算测线的函数
%
% 输出
% outInIds              输出的inline
% outCrossIds           输出的crossline
%
% 输入
% inIds                 输入的inline
% crossIds              输入的crossline
% firstCdp              第一个crossline号
% traceNum              测线的道数

    endCdp = firstCdp + traceNum - 1;
    
%     setInIds = [2900, inIds, inIds(length(inIds))];
    if(length(inIds) == 1)
        setInIds = [inIds(1), inIds, inIds(length(inIds))];
        setCrossIds = [firstCdp, crossIds, endCdp];
    else
        setInIds = inIds;
        setCrossIds = crossIds;
    end
    
%     setInIds = [2904, inIds, 2468];
%     setInIds = [2560, inIds, 2903];
    
    
    outCrossIds = firstCdp : 1 : endCdp;
    outInIds = stpCubicSpline(setCrossIds, setInIds, outCrossIds, 0, 0);

    % 向下取整
    for i = 1 : length(outInIds)
        outInIds(i) = floor(outInIds(i));
    end
    
    for i = 1 : length(crossIds)
        index = find(outCrossIds == crossIds(i));
        outInIds(index) = inIds(i);
    end

%     figure;
%     plot(outCrossIds, outInIds, 'r'); set(gca,'ydir','reverse');
%     hold on;
% %     text(crossIds, inIds, wellNames, 'FontSize', 8);
% %     set(gca, 'ylim', [2550 2950]);
%     xlabel('Crossline','FontSize',14);ylabel('Inline','FontSize',14);
%     title('测线位置曲线', 'FontSize', 18);
end