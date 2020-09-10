function E = MechE_func(x,params)
    %Calculates mechanical energy of the 4 link biped by calling the
    %pregenerated kinetic and potential energy. 
    E = KE_func(x,params) + PE_func(x,params);
end

