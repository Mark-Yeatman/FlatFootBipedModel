function xout = map_End_Step(xprev,xnext)
    %MAP_FOOTSTRIKE Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    params = flowdata.Parameters.Biped.asvec;
    if flowdata.Flags.step_done
        nextpose = Heel_Sw_pos_func(xprev',params);            
        xnext(1:2) = nextpose(1:2,4)';
    end
    xout = xnext;
end

