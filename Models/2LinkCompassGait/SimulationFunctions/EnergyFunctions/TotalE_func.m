function E = TotalE_func(x,Params)
%TOTALE_FUNC Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    x(2) = x(2) - flowdata.State.PE_datum;
    E = KE_func(x,Params) + PE_func(x,Params);
end

