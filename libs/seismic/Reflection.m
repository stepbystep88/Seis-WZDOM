function [Y] = reflection(x_new)      

for j=1:1:length(x_new)-1
    ref(j,1)=(x_new(j+1)-x_new(j))./(x_new(j+1)+x_new(j));
%     ref(j+1,1)=0.5*(log(x_new(j+1)) - log(x_new(j)));
end
ref(j+1,1)=0;
Y=ref;