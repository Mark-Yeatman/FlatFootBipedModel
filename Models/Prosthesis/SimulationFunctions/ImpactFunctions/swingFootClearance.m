function h = swingFootClearance(x)
%SWINGFOOTCLEARANCE Summary of this function goes here
%   Detailed explanation goes here
global flowdata
    dim = flowdata.Parameters.dim;
    q = x(1:dim/2);
    qdot = x(dim/2+1:dim);
    temp = swingHeelClearance(q,qdot);
    pH = temp(1); %1st element is pos, 2nd is vel
    h = min(pH,swingToeClearance(q,qdot));
end

