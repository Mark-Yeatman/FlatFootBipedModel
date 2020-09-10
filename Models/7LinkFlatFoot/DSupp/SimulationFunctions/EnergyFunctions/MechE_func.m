function E = MechE_func(x)
    %Calculates mechanical energy of the 4 link biped by calling the
    %pregenerated kinetic and potential energy. 
    global flowdata
    
    xdatum = x;    
    xdatum(2) = x(2) - flowdata.State.PE_datum;
    
    E = KE_func(xdatum) + PE_func(xdatum);
end

