Spring1_energy = 1/2*flowdata.Parameters.SLIP.k*(out_extra.L1-flowdata.Parameters.SLIP.L0).^2;
Spring2_energy = 1/2*flowdata.Parameters.SLIP.k*(out_extra.L2-flowdata.Parameters.SLIP.L0).^2;

for i = 1:length(xout)
    ji = 0;
    ki = 0;
    for j = 1:length(out_extra.steps)
        for k =1:length(out_extra.steps{j}.phases)
            if out_extra.steps{j}.phases{k}.tstart <= tout(i) && tout(i) <= out_extra.steps{j}.phases{k}.tend
                ji = j;
                ki = k;

            end
        end
    end
    pf1 = out_extra.steps{ji}.phases{ki}.foot_pos_1;
    pf2 = out_extra.steps{ji}.phases{ki}.foot_pos_2;
    Ldot1(i) = Spring_Velocity_func(xout(i,:)',pf1);
    temp = XYtoLTheta(xout(i,:)', pf1);
    theta1(i) = temp(2);
    if ~isnan(pf2)
        temp = XYtoLTheta(xout(i,:)', pf2);
        Ldot2(i) = Spring_Velocity_func(xout(i,:)',pf2);
        theta2(i) = temp(2);
    else
        theta2(i) = nan;
        Ldot2(i) = nan;
    end
end

E1 = Spring1_energy + out_extra.PotentialEnergy + out_extra.KineticEnergy;
E2 = Spring2_energy + out_extra.PotentialEnergy + out_extra.KineticEnergy;
%E1 = Spring1_energy' + 1/2*flowdata.Parameters.Biped('m')*Ldot1.^2;
%E2 = Spring2_energy' + 1/2*flowdata.Parameters.Biped('m')*Ldot2.^2;