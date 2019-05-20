function [W,ricker]=getricker(sgydata,dt,samplenum)
Fs  = 1000./dt; %采样频率              
N = 256;                          
n = 0:N - 1; 
fr = fft(sgydata,N);

mag = sqrt(real(fr).^2+imag(fr).^2);f = n * Fs / N;  
index = 1:(N / 2);
% figure; 
% plot(f(index),mag(index));    
% xlabel('Fre (HZ)');ylabel('Mag');title('syn Signal Frequency Spectrum');
bestft=min(f(find(mag(:,1)==max(mag))));
%%
%产生雷克子波                                                           
wav = s_create_wavelet({'type','ricker'},{'frequencies',bestft},{'step',dt});   
wavelet = wav.traces;                                                           
waveletSize = length(wavelet);                                                  
[mv index] = max(wavelet);                                                                                                                                     
while index > 1 && wavelet(index) > 0                                           
    index = index - 1;                                                          
end
for i = index + 1:waveletSize
    smallWavelet(i - index,1) = wavelet(i);                                       
end
ricker = smallWavelet;

ix=find(ricker(:,1)==max(ricker));
Wmatrix = convmtx(ricker,samplenum);
W = Wmatrix(ix:ix-1+samplenum,:);
%形成褶积子波矩阵W 