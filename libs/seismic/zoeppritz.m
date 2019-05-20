function [M,C,A] = zoeppritz(Theta1,Theta2,Psi1,Psi2,Vs1,Vp1,rho1,Vs2,Vp2,rho2)
%%M*A=C  zoeppritz·½³Ì
% M = [sin(Theta1)     cos(Psi1)                 -sin(Theta2)               -cos(Psi2);
%      cos(Theta1)    -sin(Psi1)                  cos(Theta2)               -sin(Psi2);
%      sin(2*Theta1)   (Vp1*cos(2*Psi1))/Vs1     (rho2*Vs2^2*Vp1*sin(2*Theta2))/(rho1*Vp2*Vs1^2)   (rho2*Vs2*Vp1*cos(2*Psi2))/(rho1*Vs1^2);
%      cos(2*Psi1)     -(Vs1*sin(2*Psi1))/Vp1     -(rho2*Vp2*cos(2*Psi2))/(rho1*Vp1)               (rho2*Vs2*sin(2*Psi2))/(rho1*Vp1)];
% C = [-sin(Theta1),cos(Theta1),sin(2*Theta1),-cos(2*Psi1)]';
% A = inv(M)*C;

M = [sin(Theta1)     cos(Psi1)                 -sin(Theta2)               cos(Psi2);
     cos(Theta1)    -sin(Psi1)                  cos(Theta2)               sin(Psi2);
     sin(2*Theta1)   (Vp1*cos(2*Psi1))/Vs1     (rho2*Vs2^2*Vp1*sin(2*Theta2))/(rho1*Vp2*Vs1^2)   -(rho2*Vs2*Vp1*cos(2*Psi2))/(rho1*Vs1^2);
     cos(2*Psi1)     -(Vs1*sin(2*Psi1))/Vp1     -(rho2*Vp2*cos(2*Psi2))/(rho1*Vp1)               -(rho2*Vs2*sin(2*Psi2))/(rho1*Vp1)];
C = [-sin(Theta1),cos(Theta1),sin(2*Theta1),-cos(2*Psi1)]';
A = inv(M)*C;%%Rpp=A(1)
