function [values, data] = bsGetFieldsWithDefaults(data, pairs)
%% get the value or set a default value of input field names in pairs to struct data.
% Bin She, bin.stepbystep@gmail.com, February, 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
% data is a struct. 
%
% pairs is a n*2 cell; the first columns is the name of the field, the
% second columns save the default values of each corresponding field name.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
% values refers to the values of all input fields names of struct 'data'.
%
% data, if some field names are set to default value, data needs to output.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    nFields = size(pairs, 1);
    
    if nFields == 1
        % only check one fieldName
        if isfield(data, pairs{1, 1})
            values = getfield(data, pairs{1, 1});
        else
            values = pairs{1, 2};
            data = setfield(data, pairs{1, 1}, pairs{1, 2});
        end
    else
        values = cell(1, nFields);
        
        for i = 1 : nFields
            fieldName = pairs{i, 1};

            if isfield(data, fieldName)
                values{i} = getfield(data, fieldName);
            else
                value{i} = pairs{i, 2};
                data = setfield(data, fieldName, pairs{i, 2});
            end
        end
    end
    
    
    
end