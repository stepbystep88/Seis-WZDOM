function y = BPassFilter(data)
 centerFre=40;
 offsetFre=30;
 sampFre=500;
    %设计I型带通滤波器
    M = 0 ;    %滤波器阶数（必须是偶数）
    Ap = 0.82; %通带衰减
    As = 45;   %阻带衰减
    Wp1 = 2*pi*(centerFre - offsetFre)/sampFre;  %算出下边频
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
  
  y = conv(data,h');
  y=y(fix(length(h)./2)+1:length(y)-fix(length(h)./2));