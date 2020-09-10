function struct2vars(s)
%STRUCT2VARS Extract values from struct fields to WORKSPACE variables,
%will not put data in local function variables if called from a function
names = fieldnames(s);
for i = 1:numel(names)
    assignin('caller', names{i}, s.(names{i}));
end