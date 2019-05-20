function y = BPassFilter(data)

% T=0:0.002:(79-1)*0.002;
% data=sin(2*pi*40*T);
% data=data';
% figure;plot(T,data); title('滤波前信号');
% N=512;
% fs=500;%采样频率
% df=fs/(N-1) ;%分辨率
% f=(0:N-1)*df;%其中每点的频率
% Y=fft(data,512)/N*2;%真实的幅值
% figure;plot(f(1:N/2),abs(Y(1:N/2)));

%%
centerFre=40;offsetFre=10;sampFre=1./0.002;

    %设计I型带通滤波器
    M = 0 ;    %滤波器阶数（必须是偶数）
    Ap = 0.9; %通带衰减
    As = 45;   %阻带衰减
    Wp1 = 2*pi*(centerFre - offsetFre)/sampFre;  %算出下边频
    Wp1 = 2*pi*(centerFre - 30)/sampFre;  %算出下边频
    Wp2 = 2*pi*(centerFre + offsetFre)/sampFre;  %算出上边频
 
    % (1)矩形窗
    N = ceil(3.6*sampFre/offsetFre);             %计算滤波器阶数,采用矩形窗，3dB截频在中心频率到上下边频的中点
    M = N - 1;
    M = mod(M,2) + M ; %使滤波器为I型(偶数)
    %单位脉冲响应的下脚标
    h = zeros(1,M+1);  %单位冲击响应变量赋初值
    for k = 1:(M+1);
        if (( k -1 - 0.5*M)==0)
            h(k) = Wp2/pi - Wp1/pi;
        else
            h(k) = Wp2*sin(Wp2.*(k - 1 - 0.5*M))/(pi*(Wp2*(k -1 - 0.5*M))) - Wp1*sin(Wp1*(k - 1 - 0.5*M))/(pi*(Wp1*(k -1 - 0.5*M)));
        end
    end
    
    
  % (2) Hann Window
%   N = ceil(12.4*sampFre/offsetFre);             %计算滤波器阶数,采用矩形窗，3dB截频在中心频率到上下边频的中点
%   M = N - 1;
%   M = mod(M,2) + M ; %使滤波器为I型(偶数)
%       h = zeros(1,M+1);  %单位冲击响应变量赋初值
%     for k = 1:(M+1);
%         if (( k -1 - 0.5*M)==0)
%             h(k) = Wp2/pi - Wp1/pi;
%         else
%             h(k) = Wp2*sin(Wp2.*(k - 1 - 0.5*M))/(pi*(Wp2*(k -1 - 0.5*M))) - Wp1*sin(Wp1*(k - 1 - 0.5*M))/(pi*(Wp1*(k -1 - 0.5*M)));
%         end
%     end
%   K = 0:M;
%   w = 0.5 - 0.5*cos(2*pi*K/M);
%   h = h.*w;
 
  % (3)Hamming Window
%   N = ceil(14*sampFre/offsetFre);             %计算滤波器阶数,采用矩形窗，3dB截频在中心频率到上下边频的中点
%   M = N - 1;
%   M = mod(M,2) + M ; %使滤波器为I型(偶数)
%     h = zeros(1,M+1);  %单位冲击响应变量赋初值
%     for k = 1:(M+1);
%         if (( k -1 - 0.5*M)==0)
%             h(k) = Wp2/pi - Wp1/pi;
%         else
%             h(k) = Wp2*sin(Wp2.*(k - 1 - 0.5*M))/(pi*(Wp2*(k -1 - 0.5*M))) - Wp1*sin(Wp1*(k - 1 - 0.5*M))/(pi*(Wp1*(k -1 - 0.5*M)));
%         end
%     end
%   K = 0:M;
%   w = 0.54 - 0.46*cos(2*pi*k/M);
%   h = h.*w;

% (4)Blackman window
%   N = ceil(22.8*sampFre/offsetFre);             %计算滤波器阶数,采用矩形窗，3dB截频在中心频率到上下边频的中点
%   M = N - 1;
%   M = mod(M,2) + M ; %使滤波器为I型(偶数)
%     h = zeros(1,M+1);  %单位冲击响应变量赋初值
%     for k = 1:(M+1);
%         if (( k -1 - 0.5*M)==0)
%             h(k) = Wp2/pi - Wp1/pi;
%         else
%             h(k) = Wp2*sin(Wp2.*(k - 1 - 0.5*M))/(pi*(Wp2*(k -1 - 0.5*M))) - Wp1*sin(Wp1*(k - 1 - 0.5*M))/(pi*(Wp1*(k -1 - 0.5*M)));
%         end
%     end
%   K = 0:M;
%   w = 0.42 - 0.5*cos(2*pi*K/M) + 0.08*cos(4*pi*K/M);
%   h = h.*w;

  h=h';
  
  
  y= conv(h,data);y=y(fix(length(h)./2)+1:length(y)-fix(length(h)./2),1);


%   N=512;
%   fs=512;%采样频率
%   df=fs/(N-1) ;%分辨率
%   f=(0:N-1)*df;%其中每点的频率
%   Y=fft(h,512)/N*2;%真实的幅值
%   figure;plot(f(1:N/2),abs(Y(1:N/2)));
%   
%     f=(0:N-1)*df;%其中每点的频率
%   Y=fft(y,512)/N*2;%真实的幅值
%   figure;plot(f(1:N/2),abs(Y(1:N/2)));
%   
%   figure;
%   plot(T,y);set(gca,'ylim',[-1 1]);
