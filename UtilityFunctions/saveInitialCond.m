function saveInitialCond(name,fstate)
    %SAVEINITIALCOND Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    state_extra = flowdata.State;
    save(name,'fstate','state_extra')
end

