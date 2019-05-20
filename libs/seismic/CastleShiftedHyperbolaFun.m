function p = CastleShiftedHyperbolaFun(zp,vp,xoff)
% [dout,M,N,ti,vi] = inmo(d,dt,h,ti,vi,max_stretch,vtimeweigh);
% DeltaT = diff(zp)./vp(2:length(vp));
% DeltaT0 = cumsum(DeltaT);
% LayNum = length(diff(zp));
% mu2_sum = 0;
% mu4_sum = 0;
% mu_sum  = 0;
% for LayIndex = 1:LayNum
%     mu2_sum = mu2_sum + DeltaT0(LayIndex)*vp(LayIndex)*vp(LayIndex);
%     mu4_sum = mu4_sum + DeltaT0(LayIndex)*vp(LayIndex)*vp(LayIndex)*vp(LayIndex)*vp(LayIndex);
%     mu_sum  = mu_sum  + DeltaT0(LayIndex);
% end
% mu2 = mu2_sum/mu_sum;
% mu4 = mu4_sum/mu_sum;
% 
% S = mu4/(mu2*mu2);
% Tau0 = (t0/S);
% v = sqrt(S*mu2);
% 
% for XoffIndex = 1:length(xoff)
%     h = xoff(XoffIndex);
%     Tau  = TauS+sqrt(Tau0*Tau0+(h/v)*(h/v))
%     TauS = t0*(1-1/S);
%     p(XoffIndex) = h/((Tau-TauS)*v*v);
% end
% [nt,nh] = size(d);
t=vint2t(vp,zp);
vi=vint2vrms(vp,t);
vtimeweigh=vint2timeweighed(vp,t); 
ti =2*t;
S = vtimeweigh./(vi.^4);
tao0 = ti./S;
taos = tao0.*(S-1);
v_square = S.*(vi.^2);
h = xoff;
nh = length(xoff);
nt = length(v_square);
for it = 1:nt;
    for ih = 1:nh;
        % shifted hyperbola NMO equation
        arg = taos(it)+sqrt(tao0(it)*tao0(it) + h(ih)*h(ih)/v_square(it));
        p(it,ih) = h(ih)/((arg - taos(it))*v_square(it));
    end;
 end;



