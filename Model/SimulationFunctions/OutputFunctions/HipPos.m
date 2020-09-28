function Hip = HipPos(t,y,~)
    %COMPOSOUTPUT Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    params = flowdata.Parameters.Biped.asvec;
    Hip = zeros(length(t),2);
    for i=1:length(t)
       temp = Hip_pos_func(y(i,:)',params);
       Hip(i,:) = temp(1:2,4);
    end
end

