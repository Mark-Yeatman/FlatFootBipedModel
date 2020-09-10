function outputs = PhaseOutputs(t,y,xin)
global flowdata
    outputs.name = flowdata.State.c_phase;
    outputs.configs = flowdata.State.c_configs;
    outputs.ConstForces = nan(4,length(t))';
    outputs.x_start = xin;
    for i = 1:length(t)
        [cop_ff,cop_gf] = COP_func(y(i,:)');
        cop_xy = -cop_gf(1:2)'+xin(1:2);
        outputs.COP(i,:) = cop_xy;
        outputs.u(i,:) = flowdata.eqnhandle(t(i),y(i,:)','u');
        outputs.FootClearance(i) = swingFootClearance(y(i,:)');
        outputs.GRF(i,:) = getGroundReactionForces(t(i),y(i,:)');  
    end
end