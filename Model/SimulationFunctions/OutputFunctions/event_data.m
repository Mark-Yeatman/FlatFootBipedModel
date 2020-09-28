function data = event_data(t,y)
    %EVENT_DATA Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    L = length(flowdata.Impacts);
    for i=1:length(t)
        [value, isterminal, direction] = guard(t(i),y(i,:)');
        data.value(i,1:L) = value;
        data.isterminal(i,1:L) = isterminal;
        data.direction(i,1:L) = direction;
    end
    if L>0
        for i=1:L
            data.names(i) = flowdata.Impacts{i};
        end
    end
end

