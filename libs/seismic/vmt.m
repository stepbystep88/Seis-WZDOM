function mato=vmt(mati,vector)
% Vector matrix multiplication (scaling of matrix rows)
% Written by: E. R.: June 12, 2004
% Last updated: 
%
%         mato=vmt(mati,vector)
% INPUT
% mati    input matrix
% vector  input vector (number of entries must equal the number of 
%         columns of "mati")
% OUTPUT
% mato    scaled input matrix

% nvector=length(vector);
[n,m]=size(mati);
if n ~= length(vector)
   error('Matrix and vector are incompatible')
end

mato=zeros(n,m);
for ii=1:m
   mato(:,ii)=mati(:,ii).*vector(:);
end
