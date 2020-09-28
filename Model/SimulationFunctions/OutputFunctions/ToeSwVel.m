function v = ToeSwVel(t,y,~)
    %COMPOSOUTPUT Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    params = flowdata.Parameters.Biped.asvec;
    v = zeros(length(t),3);
    for i=1:length(t)
       temp =  Toe_Sw_vel_func(y(i,:)',params);
       v(i,:) = temp(1:3,4);
    end
end

