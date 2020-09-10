function outputs = PhaseOutputs(t,y,xin)
global flowdata
    outputs.name = flowdata.State.c_phase;
    outputs.ConstForces = nan(4,length(t))';
    outputs.E = nan(1,length(t))';
    outputs.Eref = nan(1,length(t))';
    for i = 1:length(t)
        %[~,cop_gf] = COP_func(y(i,:)');
        %cop_xy = cop_gf(1:2)+xin(1:2);
        %outputs.COP(i,:) = cop_xy;
        outputs.u(i,:) = flowdata.eqnhandle(t(i),y(i,:)','u');
        outputs.FootClearance(i) = swingFootClearance(y(i,:)');
        outputs.GRF(i,:) = getGroundReactionForces(t(i),y(i,:)'); 
        outputs.E(i) =  flowdata.E_func(y(i,:)',cell2mat(flowdata.Parameters.Biped.values));
        %[outputs.Eref(i),~] = Eref_func(y(i,:)');
        outputs.Eref(i) = 0;
    end
end