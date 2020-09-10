function E = E_func(x,params)
    %E_FUNC Summary of this function goes here
    %   Detailed explanation goes here
    E = PE_func(x,params) + KE_func(x,params) + Spring_E_func(x,params);
end

