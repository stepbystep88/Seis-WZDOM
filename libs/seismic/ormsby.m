function fa=ormsby(a,dt,f1,f2,f3,f4)
% Function filters input array in the frequency domain with 
% trapezoidal filter with corner frequencies f1, f2, f3, f4. To reduce end effects
% the function doubles the number of rows of "a" by appending zeros. These zeros
% are removed prior to output. 
% The function is for internal use and performs no error checking
%
% Written by: E. R.: May 2001
% Last updated: November 27, 2004: quadruple (from double) the filter length for spectrum calculation
%
%        fa=ormsby(a,dt,f1,f2,f3,f4)
% INPUT
% a      input array; each column represents a seismic trace
% dt     sample interval in ms
% f1 f2 f3 f4  corner frequencies (0 <= f1 <= f2 <= f3 <= f4 <= fnyquist)
% OUTPUT
% fa     filtered input array


nn=size(a,1);
n=4*nn;
nh=2*nn;
fnyquist=500/dt; 
df=2*fnyquist/n;

%    Compute trapezoidal window to apply to spectrum
trapez=zeros(n,1);
f=0:df:fnyquist;
idx=find(f >= f1 & f <= f4);
f=f(idx);
eps1000=1000*eps;
b1=(f-f1+eps1000)/(f2-f1+eps1000);
b2=ones(1,length(b1));
b3=(f4-f+eps1000)/(f4-f3+eps1000);
trapez(idx)=min([b1;b2;b3]);
trapez(n:-1:n-nh+2)=trapez(2:nh);

%   Compute FFT, apply trapezoidal window, and perform inverse FFT.
fa=fft(a,n);

%gh=fa.*trapez(:,ones(1,m));
gh=vmt(fa,trapez);
fa=ifft(gh);

%   Discard appended zeros and imaginary part (if the input data are real)
if isreal(a)
   fa=real(fa(1:nn,:));
else
   fa=fa(1:nn,:);
end

