function E = ETotal_func(x,biped_params,pf1,pf2)
%ETOTAL_FUNC Total mechanical energy of the SLIP model
    if any(isnan(pf1))
        S1 = 0;
    else
        S1 = SpringE_func(x,pf1);
    end
    if any(isnan(pf2))
        S2 = 0;
    else
        S2 = SpringE_func(x,pf2);
    end
        E = KE_func(x,biped_params) + PE_func(x,biped_params) + S1 + S2;
end

