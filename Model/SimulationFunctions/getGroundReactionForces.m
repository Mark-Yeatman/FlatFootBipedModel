function [GRF,F] = getGroundReactionForces(t,y)
global flowdata
    F = flowdata.eqnhandle(t,y,'L');
    R_gf = flowdata.getRgf();
    R_gf = R_gf(1:2,1:2);
    if length(F)>=4
       F1 = F(1:2);
       F2 = F(3:4);
       GRF1 = R_gf*F1;
       GRF2 = R_gf*F2;
    elseif length(F) >= 2
       F1 = F(1:2);
       F2 = nan(size(F1));
       GRF1 = R_gf*F1;
       GRF2 = R_gf*F2;
    else
       GRF1 = nan(2,1);
       GRF2 = nan(2,1);
    end
    GRF = [GRF1',GRF2'];
end