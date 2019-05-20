function isSame = bsCompareTwoVectors(va, vb)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is designed for compare two vectors, if they are the same,
% return true, otherwise, return false
% Programmed by: Bin She (Email: bin.stepbystep@gmail.com)
% Programming dates: May 2019
% -------------------------------------------------------------------------    
    va = floor(va * 1e10)/1e10;
    vb = floor(vb * 1e10)/1e10;
    
    isSame = all( (va - vb) == 0);
end