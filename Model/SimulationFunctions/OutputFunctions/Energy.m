function E= Energy(t,y,~)
    %EN Summary of this function goes here
    %   Detailed explanation goes here
    E = zeros(size(t));
    for i=1:length(t)
       E(i) = MechE_func(y(i,:)'); 
    end
end

