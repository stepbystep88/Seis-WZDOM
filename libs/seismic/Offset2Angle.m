function [AngleTrace] = Offset2Angle(AngleIndex, tt, SemicTrace, angleTrNum)

    sampNum = length(AngleIndex);
    AngleTrace = zeros(sampNum, angleTrNum);

    for i = 1 : sampNum 
        for j = 1 : angleTrNum
            if AngleIndex{i}{j}  ==  0
                AngleTrace(i,j) = 0;
            else    
                AngleTrace(i,j) = SemicTrace(i, AngleIndex{i}{j})*tt{i}{j}';
            end
        end
    end
end