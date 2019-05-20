% 协方差矩阵的计算
%参考文献：AVO三参数反演方法研究 P68
function [Cx inv_Cx] = Cx_calculate(x)
% clc;clear all;close all;
% x = rand(1,1200);
x_len = length(x)/3;
R_vp = x(1:x_len);R_vs = x(x_len+1:2*x_len);R_rho = x(2*x_len+1:3*x_len);

flag1 = 0; flag2=0;
for i = 2:x_len 
    if flag ==0
        for j = 1:i-1
            for k = 2:i
                if R_vp(j)~=R_vp(k) && R_vs(j)~=R_vs(k)
                    flag1 = flag1+1;
                    break
                end
            end
        end
    end
%         for m = 1:i-1
%             for n = 2:i
%                 if R_vp(m)~=R_vp(n) && R_rho(m)~=R_rho(n)
%                     flag2 = f1ag2+1;
%                     break
%                 end
%             end 
%         end   
%     end
                
    if flag1 ~= 0
        R0 = corrcoef(R_vp(1:i),R_vs(1:i));r_RalphaRbeta(i) = R0(1,2);
        R0 = corrcoef(R_vp(1:i),R_rho(1:i));r_RalphaRrho(i) = R0(1,2);
    else
        r_RalphaRbeta(i) = 1;
        r_RalphaRrho(i) = 1;
    end
end
r_RalphaRbeta(1)=1;r_RalphaRrho(1)=1;
g = (R_rho*R_vp')/(R_vp*R_vp');
m = (R_vp*R_vs')/(R_vs*R_vs');
f = (R_rho*R_vs')/(R_vs*R_vs');
%=====================================================%

for i = 1:length(R_vp)  
    [Cx_part,S,V,inv_V]= CxMatrix(r_RalphaRbeta(i),r_RalphaRrho(i),g,f,m);
  
    Cov1(i) = S(1);Cov2(i) = S(2);Cov3(i) = S(3);
    V11(i) = V(1,1);V12(i) = V(1,2);V13(i) = V(1,3);
    V21(i) = V(2,1);V22(i) = V(2,2);V23(i) = V(2,3);
    V31(i) = V(3,1);V32(i) = V(3,2);V33(i) = V(3,3);
    inv_V11(i) = inv_V(1,1);inv_V12(i) = inv_V(1,2);inv_V13(i) = inv_V(1,3);
    inv_V21(i) = inv_V(2,1);inv_V22(i) = inv_V(2,2);inv_V23(i) = inv_V(2,3);
    inv_V31(i) = inv_V(3,1);inv_V32(i) = inv_V(3,2);inv_V33(i) = inv_V(3,3);
end

Cx =[diag(V11) diag(V12) diag(V13);diag(V21) diag(V22) diag(V23);diag(V31) diag(V32) diag(V33)];
inv_Cx =[diag(inv_V11) diag(inv_V12) diag(inv_V13);diag(inv_V21) diag(inv_V22) diag(inv_V23);diag(inv_V31) diag(inv_V32) diag(inv_V33)];