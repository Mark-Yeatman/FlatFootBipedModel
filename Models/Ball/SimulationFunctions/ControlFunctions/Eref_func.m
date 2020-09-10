function [Eref, Eref_part] = Eref_func(x)
    %EREF Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    Eref = flowdata.Parameters.KPBC.c + flowdata.Parameters.KPBC.b*x(1);
    Eref_part = zeros(2,1);
    Eref_part(1) = flowdata.Parameters.KPBC.b;
end

