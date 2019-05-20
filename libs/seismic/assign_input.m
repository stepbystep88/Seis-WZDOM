function param=assign_input(param,arguments,fcn)
% Function matches keywords in cell array "arguments" to fields of "param", and 
% replaces them with new values. Used to assign input arguments in certain functions
% Written by: E. R.: December 20, 2000
% Last updated: October 28, 2005: Handle differences in dbstack between R13 and R14
%
%          param=assign_input(param,arguments,fcn)
% INPUT
% param    structure
% arguments cell array, each element of "arguments" is a 2-element cell array
%          whose first element is a field name of "param"
% fcn      string with the name of the function calling "assign_input"
% OUTPUT
% param    input structure updated with values in "arguments"
%                     param=assign_input(param,arguments}
% Input can also be provided via global variable "PARAMETERS4FUNCTION"
% GLOBAL VARIABLE
%          PARAMETERS4FUNCTION structure with field "fcn" which, in turn, has fields
%                   'default' and/or 'actual'
%          Example: PARAMETERS4FUNCTION.s_iplot.default
%                   PARAMETERS4FUNCTION.s_iplot.actual
%          PARAMETERS4FUNCTION.s_iplot.actual is a structure with the actually used parameters
%          i.e. it has has the same fields as "param" on output

global PARAMETERS4FUNCTION

ier=0;

%	Check if arguments are supplied via global variable "PARAMETERS4FUNCTION.fcn.default"
			if nargin > 2
if isfield(PARAMETERS4FUNCTION,fcn)
   temp=getfield(PARAMETERS4FUNCTION,fcn);
   if isfield(temp,'default')  &  ~isempty(temp.default)
      defaults=temp.default;
      fields=fieldnames(defaults);
      params=fieldnames(param);
      bool=ismember(fields,params);
      if ~all(bool)
         disp(['Parameters specified via "PARAMETERS4FUNCTION.',fcn,'.default":'])
         disp(cell2str(fields,', '))

         fields=fields(~bool);
         disp('Parameters that are not keywords of function:')
         disp(cell2str(fields,', '))

         disp('Possible keywords: ')
         disp(cell2str(params,', '))
	 temp.default=[];

%	Set "PARAMETERS4FUNCTION.functionname.default" to the empty matrix to
%       prevent it from being used again in another function
	
         PARAMETERS4FUNCTION=setfield(PARAMETERS4FUNCTION,fcn,temp); 
	
         error(['Not all fields of "PARAMETERS4FUNCTION.',fcn,'.default" are keywords'])
      end
  
      for ii=1:length(fields)
         param=setfield(param,fields{ii},getfield(temp.default,fields{ii}));
      end

%     Set "PARAMETERS4FUNCTION.functionname.default" to the empty matrix to prevent
                                % it from being used again in another function

      temp.default=[];
      PARAMETERS4FUNCTION=setfield(PARAMETERS4FUNCTION,fcn,temp); 
   end
end
			end

%	Use input arguments of the function calling "assign_input"
for ii=1:length(arguments)
   arg=arguments{ii};
   try
      field=lower(arg{1});
   catch
      error('Problem with keyword-controlled input arguments.')
   end
   if ~isfield(param,field)
      if ier == 0
         funct=name_of_calling_function(3);
	 ier=1;  
      end
      disp([' "',field,'" is not a valid input argument keyword for function "',funct,'"'])
  
   else
      if length(arg) == 2 & ~iscell(arg{2})      % Modification 
         param=setfield(param,field,arg{2});
      else
         param=setfield(param,field,arg(2:end));
      end
   end
end

if ier
   disp('Recognized keywords are:')
   disp(fieldnames(param)')
   error(['Input error in ',funct]) 
end

if nargin > 2
   temp.actual=param;
   PARAMETERS4FUNCTION=setfield(PARAMETERS4FUNCTION,fcn,temp); 
end
