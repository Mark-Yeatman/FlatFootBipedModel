function [Eref, Eref_part] = Eref_func(x)
    global flowdata
    persistent f
    if isempty(f)
        load CPG_3x7d_EnergyFit_2
        f = CPG_3x7d_EnergyFit_2;
    end
    %EREF Summary of this function goes here
    %   Detailed explanation goes here
    
    %Eref = 0.925*x(4) + 148.2; %flowdata.Parameters.KPBC.c + flowdata.Parameters.KPBC.b*x(3);
    Eref = f(x(4)) + 154.0099;
    Eref_part = zeros(flowdata.Parameters.dim/2,1);
    Eref_part(4) = differentiate(f,x(4));%flowdata.Parameters.KPBC.b;
end

