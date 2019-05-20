function [Dnew] = flatness(D);     
[cx,dx]=size(D);
% J= dx;%处理的道数
% Nw=10;%窗口大小
% Nm=6;%窗口移动量
% Ns=4;%搜索半径
J= 99;%处理的道数
Nw=50;%窗口大小
Nm=24;%窗口移动量
Ns=12;%搜索半径
% Tolg=0.5;%群容差
% %Toli=0.7;%个体容差
Number=floor((cx-Nw-Ns)/Nm);

for k=2:1:Number
    is=(k-1)*Nm;
    ie=is+Nw;
    for j=1:1:J
         for i=1:1:(Nw+1)
            f(i,j)=D(is+i,j);
         end
    end
     for j=1:1:J
        for i=1:1:(Nw+1)
            for l=-Ns:1:Ns
            gl(i,(l+1+Ns),j)=D((is+i+l),j);
            end
        end
    end
   for j1=1:1:J
       for j2=1:1:J
            for l=-Ns:1:Ns
                 mie(l+1+Ns)=sum(f(:,j1).*gl(:,(l+1+Ns),j2))/(sqrt(sum(f(:,j1).*f(:,j1)))*sqrt(sum(gl(:,(l+1+Ns),j2).*gl(:,(l+1+Ns),j2))));
            end
          [C(j1,j2),Pos(j1,j2)]=max(mie);
          Pos(j1,j2)=Pos(j1,j2)-1-Ns;
        
           
       end
   end
   % cm= sum(sum(C))/J^2;
    %qq=prctile(C,90);
    for i=1:1:J
        for j=1:1:J
            CC(1,(i-1)*J+j)=C(i,j);
        end
    end
  Toli=prctile(CC,65);%确定参数Toli
  %Toli=prctile(CC,65);%确定参数Toli
    for j=1:1:J
        num(j)=max(size(find(abs(C(j,:))>Toli)));%加不加绝对值
    end
        [Stan,row]=max(num);
        pos1=find(C(row(1),:)>Toli);%可能出现多个最大值
        if ~isempty(pos1)
        jb=pos1(1);
        jmin=min(pos1);
        jmax=max(pos1);      
        for j=1:1:J
            if find(pos1==j)
            m(j)=Pos(jb,j)-Pos(jb,jmin);
            elseif j<jmin
                m(j)=0;
            elseif j>jmax
                 m(j)=Pos(jb,jmax)-Pos(jb,jmin);
            else
                m(j)=9999;
            end
        end
       x=find(m~=9999);
      sss=max(size(x));
      mm=zeros(1,sss);
       for i=1:1:sss
           mm(i)=m(x(i));
       end
%        m=find(m~=9999);
       xi=1:1:J;
      yi=interp1(x,mm,xi); 
      M(k,:)=yi; 
      end
end
   XX=zeros(cx,dx);
   XX(1,:)=1;
   XX(cx,:)=cx;
  for k=2:1:Number
      XX(((k-1)*Nm+Nw/2),:)=M(k,:)+((k-1)*Nm+Nw/2);
  end
 [X,Y,Z]=find(XX);
[x,y]=find(XX==0);
z=griddata(X,Y,Z,x,y,'cubic');
n=length(x);
for i=1:n, XX(x(i),y(i))=z(i); end
X1=zeros(cx,dx);
for i=1:1:cx
    X1(i,:)=i;
end
for j=1:1:J
    Dnew(:,j)=spline(X1(:,j),D(:,j),XX(:,j));
end