function [newMatrix] = createMatrix(a1,a2,a3,b1,b2,b3,c1,c2,c3,G)
[Grow Gcolumn] = size(G);
newMatrix=zeros(2*Gcolumn+Grow,2*Gcolumn);
startIndex = 1;
endIndex=Gcolumn;
for i=startIndex:1:endIndex
    newMatrix(i,i) = 1;
end

startIndex = Gcolumn+1;
endIndex=2*Gcolumn;
for i=startIndex:1:endIndex
    newMatrix(i,i) = -1;
end

startIndex =2*Gcolumn +1;
endIndex=2*Gcolumn+Grow;
startIndex2=Gcolumn+1;
endIndex2=2*Gcolumn;
for i=startIndex:1:endIndex
    for j=startIndex2:1:endIndex2
        newMatrix(i,j) = G(i-startIndex+1,j-startIndex2+1);
    end
end

Out=1;
In=1;
paratmp=[a1,a2,a3,b1,b2,b3,c1,c2,c3];
beginIndex=1;
while Out<=3
    startIndex = Gcolumn + (Out-1)*Gcolumn/3 + 1;
    endIndex = startIndex+Gcolumn/3-1;
    while In<=3
       startIndex2=(In-1)*Gcolumn/3 +1;
    for i=startIndex:1:endIndex;
        newMatrix(i,startIndex2) = paratmp(beginIndex);  
        startIndex2=startIndex2+1;
    end
    beginIndex=beginIndex+1;
    In = In+1;
    end
    In=1;
    Out=Out+1;
end