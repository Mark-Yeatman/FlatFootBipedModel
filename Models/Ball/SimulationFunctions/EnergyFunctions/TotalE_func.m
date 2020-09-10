function E = TotalE_func(x)
    %TOTALE_FUNC Calculates total mechanical energy in the SLIP model
    %   SpringE_func detects Single Support vs Double vs Flight
    E = KE_func(x) + PE_func(x) + SE_func(x);
end

