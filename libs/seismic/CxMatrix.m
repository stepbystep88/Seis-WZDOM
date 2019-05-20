function  [Cx_part,S,V,inv_V]= CxMatrix(r_RalphaRbeta,r_RalphaRrho,g,f,m)

Cx_part = [1                                    (r_RalphaRbeta*r_RalphaRbeta)/(m)           g; 
           (r_RalphaRbeta*r_RalphaRbeta)/(m)    (r_RalphaRbeta/(m))*(r_RalphaRbeta/(m))     f*(r_RalphaRbeta/(m))*(r_RalphaRbeta/(m));
            g                                   f*(r_RalphaRbeta/(m))*(r_RalphaRbeta/(m))   (g/r_RalphaRrho)*(g/r_RalphaRrho)];

% S = eig(Cx_part);
% V = zeros(size(Cx_part));
% S = sort(S,'descend');
% for i = 1:3
%     eigmax = Cx_part-S(i)*eye(size(Cx_part));
%     v1 = pinv(eigmax(1:3,1:2))*(-eigmax(:,3))
%     V(:,i) = [v1;1];
% end    
% D = diag(S);
% 
% inv_V = inv(V);

[C,D]=eig(Cx_part);
% D = diag(S);

S = sort(diag(D),'descend');
V = [C(:,3) C(:,2) C(:,1)];
inv_V = inv(V);