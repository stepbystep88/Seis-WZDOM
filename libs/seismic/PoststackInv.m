function [x_new]=PoststackInv(dtrue,W,x_initial,itermax)

    G=RefRespecttoZ(x_initial);
    R=Reflection(x_initial);
    e=W*R-dtrue;  %初始化误差
    
    g=2*W'*G'*e;  %梯度方向
    dr=-g;%初始化搜索方向
    
    x_new=x_initial;
    iter=1;
    RMSE(iter)=sqrt(mse(e));
    
    while iter <= itermax 
        alpha_new =-(e'*(W'*G'*dr))/((W'*G'*dr)'*(W'*G'*dr));%新的搜索步长2015.0326
        x_new = x_new + alpha_new *dr; 
        
        G=RefRespecttoZ(x_new);
        R=Reflection(x_new);
        e = W*R-dtrue; %误差更新
        g_new=2*W'*G'*e;  %梯度方向
        bate=g_new'*(g_new-g)/(g'*g);%%PRP
        dr_new=-g_new+bate*dr;%搜索方向

        g=g_new;
        dr=dr_new;
        
        iter=iter+1;
        RMSE(iter)=sqrt(mse(e));
%         if abs(RMSE(iter-1)-RMSE(iter))<0.01 || RMSE(iter)>RMSE(iter-1)
%             break;
%         end
    end  
    %figure;plot(RMSE);