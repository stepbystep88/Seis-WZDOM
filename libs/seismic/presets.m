function presets
% Set default parameters for SeisLab

%       Set system default parameters
systemDefaults

%       Set user-defined parameters (or override system parameters) if desired
try
   userDefaults
catch
end
