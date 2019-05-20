function [newdata]=welllogscale(data,len)

samplelen=length(data);
for i=2:samplelen-len-1
    if i>len && i<samplelen-len;
        newdata(i,1)=sum(data(i-len:i+len,1))./(len*2+1);
    else
        newlen=i-1;
        newdata(i,1)=sum(data(i-newlen:i+newlen,1))./(newlen*2+1);
    end
end

newdata(1,1)=data(1,1);
newdata(samplelen,1)=data(samplelen,1);
