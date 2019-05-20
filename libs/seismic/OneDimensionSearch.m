%一维搜索采用Brent
function[Y,fY,landa]=OneDimensionSearch(X,direction,N,dd,G,x_origin)
% global dd ;
% global G ;
% global x_origin ;

a=-10;
b=10;
Epsilon=10^-10;
cgold=0.381966;
IterTimes=200;
if a>b
    temp=a;
    a=b;
    b=temp;
end
v=a+cgold*(b-a);
w=v;
x=v;
e=0.0;
fx=Fx_L2(x,X,direction,N,dd,G,x_origin);
fv=fx;
fw=fx;
for iter=1:IterTimes
    xm=0.5*(a+b);
    if abs(x-xm)<=Epsilon*2-0.5*(b-a)
        break;
    end
    if abs(e)>Epsilon
        r=(x-w)*(fx-fv);
        q=(x-v)*(fx-fw);
        p=(x-v)*q-(x-w)*r;
        q=2*(q-r);
        if q>0
            p=-p;
        end
        q=abs(q);
        etemp=e;
        e=d;
        if not(abs(p)>=abs(0.5*q*etemp) || p<=q*(a-x) || p>=q*(b-x))
            d=p/q;
            u=x+d;
            if u-a<Epsilon*2 || b-u<Epsilon *2
                d=MySign(Epsilon,xm-x);
            end
        else
            if x>=xm
                e=a-x;
            else
                e=b-x;
            end
            d=cgold*e;
        end
    else
        if x>=xm
            e=a-x;
        else
            e=b-x;
        end
        d=cgold*e;
    end
    if abs(d)>=Epsilon
        u=x+d;
    else
        u=x+MySign(Epsilon,d);
    end
    fu=Fx_L2(u,X,direction,N,dd,G,x_origin);
    if fu<=fx
        if u>=x
            a=x;
        else
            b=x;
        end
        v=w;
        fv=fw;
        w=x;
        fw=fx;
        x=u;
        fx=fu;
    else
        if u<x
            a=u;
        else
            b=u;
        end
        if fu<=fw ||w==x
            v=w;
            fv=fw;
            w=u;
            fw=fu; 
        else
            if fu<=fv ||v==x ||v==w
                v=u;
                fv=fu;
            end
        end
    end
end
landa=x;  %返回一维搜索结果
Y=X+x*direction;
fY=Fx_L2(x,X,direction,N,dd,G,x_origin);