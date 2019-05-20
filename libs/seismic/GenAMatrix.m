function new_AA = GenAMatrix(N0_range,c1,c2,c3,Lp,Ls,Ld,K,k,m, wavelet)

if isempty(wavelet)
    W = stpWaveletMatrix(length(Lp) - 1);
elseif ~iscell(wavelet) 
    % 如果不是cell类型
    W = stpWaveletMatrix(length(Lp) - 1, wavelet);
end


new_c1 = (1/2)*c1+(1/2)*k*c2+0.5*m*c3;
new_c2 = (1/2)*c2;
D = zeros(length(Lp)-1,length(Lp));
for i=1:1:length(Lp)-1
    D(i,i) = -1;D(i,i+1) = 1;
end
for i = N0_range
    new_C1 = diag(new_c1(1:length(Lp)-1,i));
    new_C2 = diag(new_c2(1:length(Ls)-1,i));
    new_C3 = diag(c3(1:length(Ld)-1,i));
    
    if(iscell(wavelet))
        W = stpWaveletMatrix(length(Lp) - 1, wavelet{i});
    end
    
    new_a{i-N0_range(1)+1,1} = K*W*new_C1*D;
    new_a{i-N0_range(1)+1,2} = K*W*new_C2*D;
    new_a{i-N0_range(1)+1,3} = K*W*new_C3*D;
end
new_AA = cell2mat(new_a);
