function E = SLIP_E_func(x)
    %Calculates mechanical energy of the 4 link biped by calling the
    %pregenerated kinetic and potential energy. 
    global flowdata
    M = flowdata.Parameters.Biped.Mh;
    xdatum = x;    
    xdatum(2) = x(2) - flowdata.State.PE_datum;
    
    L0 = flowdata.Parameters.SLIP.L0;
    k = flowdata.Parameters.SLIP.k;
    L = Spring_Length_Heel_func(xdatum);
    Ldot = Spring_vel_Heel_func(xdatum);
    Ehip = 1/2*Ldot^2;% + (L-L0)*M*9.81; %kinetic and potential energy of slip model
    Espring = 1/2*k*(L-L0)^2; %virtual spring potential energy
    E = Espring + Ehip;
end

