function [mySign]=MySign(a,b)
if b>0
    Result=abs(a);
else
    Result=-abs(a);
end
mySign=Result;
