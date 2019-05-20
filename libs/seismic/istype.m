function bool=istype(structure,typ)
% Check if structure has field "type" and that it matches the string "typ",
% or one of the strings in cell array "typ".
%
% Written by: E. R.: September 1, 2003
% Last updated: April 28, 2006: input argument "typ" can be a cell array
%
%            bool=istype(structure,typ)
% INPUT
% structure  Matlab structure
% typ        string or cell arry of strings, possible strings are: 'seismic',
%            'well_log','table','pdf','pseudo-wells'
% OUTPUT
% bool       logical variable; set to logical(1) if "structure has field "type"
%            and if it is set to string "typ"
%            otherwise it is set to logical(0)
% EXAMPLES
%     seis=s_data;
%     istype(seis,'seismic')
%     istype(seis,{'well_log','seismic'})

bool=logical(0);
if ~isempty(structure) & isstruct(structure(1))
   if isfield(structure(1),'type')
      bool=any(ismember({structure(1).type},typ));
   end
end
