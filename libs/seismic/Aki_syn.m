function [AngleTrace_Aki,c1,c2,c3] = Aki_syn(Theta,Vp,Vs,Rho)

Lp = log(Vp.*Rho);Ls = log(Vs.*Rho);Ld = log(Rho);

D = zeros(length(Lp)-1,length(Lp));
for i=1:1:length(Lp)-1
    D(i,i) = -1;D(i,i+1) = 1;
end
Rp = (1/2)*D*Lp';Rs = (1/2)*D*Ls';Rd = D*Ld';

for j = 1:length(Theta)
    for i = 1:length(Vp)-1
        [Theta2(i,j),Psi1,Psi2] = snell(Theta(j),Vs(i),Vp(i),Vs(i+1),Vp(i+1));%Theta(j)»Î…‰Ω«£ªTheta2(i,j)Õ∏…‰Ω«
        MeanTheta0(i,j) = (Theta2(i,j)+Theta(j))/2;
    end
end
for i = 1:length(Vs)-1
    gamma(i) = (Vs(i)+Vs(i+1))/(Vp(i)+Vp(i+1));
end

[c1,c2,c3] = Aki_equ(MeanTheta0,Theta,gamma);

for i =1:length(Theta)
   Rpp_Aki(:,i) = c1(:,i).*Rp+c2(:,i).*Rs+c3(:,i).*Rd; 
end

%load BGPricker.txt;
%wavelet= BGPricker;
load ricker.txt;
wavelet= ricker;
Wmatrix = convmtx(wavelet,size(Rpp_Aki,1));W = Wmatrix(1:size(Rpp_Aki,1),:);%–Œ≥…Òﬁª˝◊”≤®æÿ’ÛW
clear Wmatrix  


for i = 1:size(Rpp_Aki,2)
    AngleTrace_Aki(i,:) = W*Rpp_Aki(:,i);
end

