function [G]=RrespecttoZ(x_new)

G=zeros(length(x_new),length(x_new));
for j = 1:length(x_new)
   if j==1
            G(j,1) = -2*x_new(j+1)/((x_new(j) + x_new(j+1)).^2);
   elseif j==length(x_new)
            G(j,j) =  2*x_new(j-1)/((x_new(j) + x_new(j-1)).^2);
   else
            G(j,j) = 2*x_new(j-1)/((x_new(j-1) + x_new(j)).^2);
            G(j,j+1) =-2*x_new(j+1)/((x_new(j) + x_new(j+1)).^2);
   end
end