function p = ToeSwPos(t,y,~)
    %COMPOSOUTPUT Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    params = flowdata.Parameters.Biped.asvec;
    p = zeros(length(t),3);
    for i=1:length(t)
       temp =  Toe_Sw_pos_func(y(i,:)',params);
       p(i,:) = temp(1:3,4);
    end
end

