function [meanTheta] = Zoep_syn(xoff,D,startP,P,vp,vs,rho)

    offsets_num = length(xoff);
    meanTheta = zeros(length(D)-1, offsets_num);
    
    for j  = 1:length(D)-1 % 最后一个界面没有反射系数
        for i = 1:offsets_num
            upper_indic = startP+j-1;lower_indic = startP+j;

            Theta1 = asin(vp(upper_indic)*P(j,i));%入射p波角度
            Psi1 = asin(vs(upper_indic)*P(j,i)); %反射横波角度
            Theta2 = asin(vp(lower_indic)*P(j,i));%特设纵波角度
            Psi2 = asin(vs(lower_indic)*P(j,i));%透射横波角度

            Vs1 = vs(upper_indic);Vp1 = vp(upper_indic);rho1 = rho(upper_indic);
            Vs2 = vs(lower_indic);Vp2 = vp(lower_indic);rho2 = rho(lower_indic);

            [M,C,A] = zoeppritz(Theta1,Theta2,Psi1,Psi2,Vs1,Vp1,rho1,Vs2,Vp2,rho2); %zoepritz方程 M*A=C
            meanTheta(j,i) = (Theta1+Theta2)/2;%透射纵波与入射纵波的角度差
%             Rpp(j,i) = A(1);
        end
    end
end