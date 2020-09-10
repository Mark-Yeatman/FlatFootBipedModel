function E = SpringAxisEnergy_func(x,pf)
    %SPRINGAXISENERGY_FUNC Kinetic Energy, Gravitional, and Spring
    %Potential of SLIP model with gravity shaped to be constant along
    %spring axis.
    %    
    global flowdata
    
    m = flowdata.Parameters.Biped('m');
    k = flowdata.Parameters.Shaping.k;
    g = flowdata.Parameters.Shaping.g;
    L0 = flowdata.Parameters.SLIP.L0;
    
    if ~isnan(pf)
        L = Spring_Length_func(x,pf);
        Ldot = Spring_Velocity_func(x,pf);
        E = 1/2*m*Ldot^2 + 1/2*k*(L-L0+m*g/k)^2;
    else
        E=0;
    end

end

