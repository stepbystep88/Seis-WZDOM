function [c1,c2,c3] = Aki_equ(MeanTheta0,Theta,gamma)

c1 = 1+(tan(MeanTheta0)).^2;
for i = 1:length(Theta)
    c2(:,i) = -8*gamma'.^2.*(sin(MeanTheta0(:,i))).^2;
end
for i = 1:length(Theta)
    c3(:,i) = -(tan(MeanTheta0(:,i))).^2/2+2*gamma'.^2.*(sin(MeanTheta0(:,i))).^2;
end
