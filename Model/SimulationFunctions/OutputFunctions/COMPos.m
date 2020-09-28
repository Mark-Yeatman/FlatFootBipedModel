function COM = COMPos(t,y,~)
    %COMPOSOUTPUT Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    params = flowdata.Parameters.Biped.asvec;
    COM = zeros(length(t),3);
    for i=1:length(t)
       COM(i,:) = COM_pos_func(y(i,:)',params);
    end
end

