function RMSE_S2 = SIG_RMSE(S2_W)

diff_S2_W = diff(S2_W);
i1 = 0;i2 = 0;
for i = 1:length(diff_S2_W)-1
    if diff_S2_W(i)>0 && diff_S2_W(i+1)<0
        i1=i1+1;peak_pos(i1) = i+1;peak_Value(i1) = S2_W(i+1);
    elseif diff_S2_W(i)<0 && diff_S2_W(i+1)>0
        i2=i2+1;troughs_pos(i2) = i+1;troughs_Value(i2) = S2_W(i+1);
    end
end
am1_vec = sort([abs(peak_Value),abs(troughs_Value)],1);
RMSE_S2 = sqrt(mse(am1_vec(1:10)));