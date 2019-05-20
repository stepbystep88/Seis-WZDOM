function [filledMatrix]=fillData(horizon,unfillMatrix)
minHorizon = min(horizon);
maxHorizon = max(horizon);
[row,column] = size(unfillMatrix);
sampleNum = row;
upNum = 20;
lowNum =20;
upcut=0;
lowcut=0;
totalNum = sampleNum+upNum+lowNum+round((maxHorizon-minHorizon)/2);
filledMatrix = zeros(totalNum,column);

minValue =min(min(unfillMatrix))-(max(max(unfillMatrix))-min(min(unfillMatrix)))./32;
for i=1:1:column
    startIndex = upNum + round((horizon(i)-minHorizon)/2) + upcut;
    endIndex = startIndex + sampleNum -1- (lowcut+upcut);
    for j = 1:1:totalNum
        if j >= startIndex & j<= endIndex
            filledMatrix(j,i) = unfillMatrix(j-startIndex+upcut+1,i);
        else
            filledMatrix(j,i) = minValue;
        end
    end
end
