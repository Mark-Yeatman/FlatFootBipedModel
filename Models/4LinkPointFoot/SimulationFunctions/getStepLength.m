function length = getStepLength(xstart,xend)
    %GETSTEPLENGTH Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    params = cell2mat(flowdata.Parameters.Biped.values);
    temp = Foot_Sw_pos_func(xend',params) - Foot_Sw_pos_func(xstart',params );
    length = norm(temp(:,4));
end

