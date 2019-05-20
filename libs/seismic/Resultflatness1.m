function [newdata]=Resultflatness1(data,len)

[m,n]=size(data);
newdata=zeros(m,n);

len=2;
for i=1:n  
    for j=1:m
        if i==1
            newdata(j,i)=sum(data(j,i:i+1))./2;
        end
        if i==n
            newdata(j,i)=sum(data(j,i-1:i))./2;
        end
        if i==2 || i==n-1
            newdata(j,i)=sum(data(j,i-1:i+1))./3;
        end
        if i>len && i<n-len
            newdata(j,i)=sum(data(j,i-len:i+len))./(2*len+1);
        end
    end
end

