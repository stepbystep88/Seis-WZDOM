function run_presets_if_needed
% Function runs set-up function "presets" in case global variable "S4M" is empty.
% This avoids an abort that would otherwise happen because subsequent code
% accesses a field of "S4M".
%
% Written by: E. R.: December 12, 2005
% Last updated:

global S4M

if isempty(S4M)
   presets
   S4M.script='';
   S4M.plot_label='';
end
