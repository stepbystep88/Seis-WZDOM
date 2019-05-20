function [Vp,Vs,Den] = GassmannRPMfun(Por,Sw,Clay);

Por(find(Por(:,1)<=0),1)=0.0001;     Por(find(Por(:,1)>=1),1)=0.9999;
Sw(find(Sw(:,1)<=0),1)=0.0001;       Sw(find(Sw(:,1)>=1),1)=0.9999;
Clay(find(Clay(:,1)<=0),1)=0.0001;   Clay(find(Clay(:,1)>=1),1)=0.9999;

load('GassmannRPM.mat');
%0孔隙度下岩石的体积模量和剪切模量
Kmat=0.5.*((Clay.*Kc+(1-Clay).*Ks)./(1-0)+(1-0)./(Clay./Kc+(1-Clay)./Ks));%0孔隙度下岩石的体积模量
Umat=0.5.*((Clay.*Uc+(1-Clay).*Us)./(1-0)+(1-0)./(Clay./Uc+(1-Clay)./Us));%0孔隙度下岩石的剪切模量
v=(Kmat-2./3.*Umat)./(2.*Kmat+2./3.*Umat);%泊松比
%临界孔隙度下岩石的体积模量和剪切模量
KHM=(P.*(n.*(1-POR0).*Umat).^2./(18.*(3.14159.*(1-v)).^2)).^(1/3);
UHM=((5-4.*v)./(10-5.*v)).*((3.*P.*(n.*(1-POR0).*Umat).^2)./(2.*(3.14159.*(1-v)).^2)).^(1/3);
%计算实际孔隙度下干燥岩石的体积模量和剪切模量
sigma=(9.*Kmat+8.*Umat)./(Kmat+2.*Umat);
Kdry=1./((Por./POR0)./(KHM+4./3.*Umat)+(1-Por./POR0)./(Kmat+4./3.*Umat))-4./3.*Umat;
Udry=1./((Por./POR0)./(UHM+1./6.*sigma.*Umat)+(1-Por./POR0)./(Umat+1./6.*sigma.*Umat))-1./6.*sigma.*Umat;
%计算实际孔隙度下含饱和流体岩石的体积模量和剪切模量
Khc=0.02;%油气的体积模量GPa
Kbrine=2.29;%地层水的体积模量GPa
Kfl=1./(Sw./Kbrine+(1-Sw)./Khc);%流体的体积模量
K0=0.5.*((Clay.*Kc+(1-Clay).*Ks)./(1-Por)+(1-Por)./(Clay./Kc+(1-Clay)./Ks));%组成岩石矿物的体积模量
Ksat=Kdry+((1-Kdry./K0).^2)./(Por./Kfl+(1-Por)./K0-Kdry./(K0.^2));%含饱和流体岩石的体积模量：这里之气好像写错了
Usat=Udry;
%计算实际孔隙度下的等效速度、密度
Den=((1-Por).*bestRhomatrix+Por.*bestRhofluid)./1000;
Vp=(((Ksat+4./3.*Usat)./Den).^(1./2))*1000;%纵波速度
Vs=((Usat./Den).^(1./2)).*1000;%横波速度


