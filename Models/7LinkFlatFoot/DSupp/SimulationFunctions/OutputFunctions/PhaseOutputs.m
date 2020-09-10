function outputs = PhaseOutputs(t,y,xin)
global flowdata
     dim = flowdata.Parameters.dim;
     outputs.name = flowdata.State.c_phase;
     outputs.configs = flowdata.State.c_configs;
    %     outputs.ConstForces = nan(4,length(t))';
     outputs.x_start = xin;
    for i = 1:length(t)
%         [cop_ff,cop_gf] = COP_func(y(i,:)');
%         cop_xy = -cop_gf(1:2)'+xin(1:2);
%         outputs.COP(i,:) = cop_xy;
        Ltemp = feval(flowdata.eqnhandle, t(i), y(i,:)', 'L');
        if strcmp(outputs.name,"Flat")
            outputs.COP(i) = Foot_CoP(Ltemp);
        elseif strcmp(outputs.name,"Toe") ||  strcmp(outputs.name,"DSupp")
            outputs.COP(i) = -flowdata.Parameters.Biped.lf;
        else
            outputs.COP(i) =0;
        end
        outputs.u(i,:) = flowdata.eqnhandle(t(i),y(i,:)','u');
        q = y(i,1:dim/2);
        qdot = y(i,dim/2+1:dim);
        outputs.u_pd(i,:) = PDControl4Phase(y(i,:)');
        outputs.FootClearance(i) = swingFootClearance(y(i,:)');
        %outputs.GRF(i,:) = getGroundReactionForces(t(i),y(i,:)');  
        outputs.MechE(i) = flowdata.E_func(y(i,:)');
        outputs.Work(i) = y(i,end);
    end
    if strcmp(outputs.name,"Flat")
            outputs.minFC = min(outputs.FootClearance);
    end
    %make coloumn vectors
    outputs.COP = outputs.COP(:);
end