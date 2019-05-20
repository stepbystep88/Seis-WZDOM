function ascii=ebcdic2ascii(ebcdic)

% Function converts EBCDIC string to ASCII
% see http://www.room42.com/store/computer_center/code_tables.shtml
%
% Written by: E. Rietsch: Feb. 20, 2000
% Last updated:
%
%           ascii=ebcdic2ascii(ebcdic)
% INPUT
% ebcdic    EBCDIC string
% OUTPUT
% ascii	   ASCII string

pointer= ...
[ 0    16    32    46    32    38    45    46    46    46    46    46   123   125    92    48
  1    17    33    46    46    46    47    46    97   106   126    46    65    74    46    49
  2    18    34    50    46    46    46    46    98   107   115    46    66    75    83    50
  3    19    35    51    46    46    46    46    99   108   116    46    67    76    84    51
  4    20    36    52    46    46    46    46   100   109   117    46    68    77    85    52
  5    21    37    53    46    46    46    46   101   110   118    46    69    78    86    53
  6    22    38    54    46    46    46    46   102   111   119    46    70    79    87    54
  7    23    39    55    46    46    46    46   103   112   120    46    71    80    88    55
  8    24    40    56    46    46    46    46   104   113   121    46    72    81    89    56
  9    25    41    57    46    46    46    46   105   114   122    46    73    82    90    57
 10    26    42    58    46    33   124    58    46    46    46    46    46    46    46    46
 11    27    43    59    46    36    44    35    46    46    46    46    46    46    46    46
 12    28    44    60    60    42    37    64    46    46    46    46    46    46    46    46
 13    29    45    61    40    41    95    39    46    46    91    93    46    46    46    46
 14    30    46    46    43    59    62    61    46    46    46    46    46    46    46    46
 15    31    47    63   124    94    63    34    46    46    46    46    46    46    46    46];

pointer=reshape(pointer,1,256);

ascii=pointer(ebcdic+1);

end
