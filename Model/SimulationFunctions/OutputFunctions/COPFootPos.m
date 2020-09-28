function COP = COPFootPos(t,y,~)
    %COPPOS Summary of this function goes here
    %   Detailed explanation goes here
    COP = zeros(size(t));
    for i=1:length(t)
       COP(i) = Foot_COP(Lambda(t(i),y(i,:)));
    end
end

