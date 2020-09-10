function E = MechE_func(x)
    %Calculates mechanical energy of the 4 link biped by calling the
    %pregenerated kinetic and potential energy. 
    global flowdata
    in2 =  flowdata.Parameters.Biped.asvector;
    xdatum = x;    
    xdatum(2) = x(2) - flowdata.State.PE_datum;
    
    L0 = flowdata.Parameters.SLIP.L0;
    k = flowdata.Parameters.SLIP.k;
    L = Spring_Length_Heel_func(xdatum);
    
    E = KE_func(xdatum,in2) + PE_func(xdatum,in2) + 1/2*k*(L - L0)^2;
end

