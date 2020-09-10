function outputs = PhaseOutputs(t,y,xin)
global flowdata
%global outdata

    dim = flowdata.Parameters.dim;
    biped_params = cell2mat(flowdata.Parameters.Biped.values);
    num_cntrs = length(flowdata.Controls.Internal) + length(flowdata.Controls.External);
    
    outputs.phase_name = flowdata.State.c_phase;
    outputs.foot_pos_1 = flowdata.State.pf1;
    outputs.foot_pos_2 = flowdata.State.pf2;
    
    outputs.L1thetaCords = zeros(size(y));
    outputs.L2thetaCords = zeros(size(y));
    
    outputs.Forces = zeros(num_cntrs , dim/2, length(t));
    outputs.Net_Force = zeros(dim/2,length(t));
    
    outputs.KineticEnergy = zeros(1,length(t));
    outputs.PotentialEnergy = zeros(1,length(t));
    outputs.Spring1Energy = zeros(1,length(t));
    outputs.Spring2Energy = zeros(1,length(t));
    outputs.SpringAxisEnergy = zeros(1,length(t));
    outputs.Energy = zeros(1,length(t));
    
    for i = 1:length(t)
       outputs.Net_Force(:,i) = flowdata.eqnhandle(t(i),y(i,:)','u');
       outputs.KineticEnergy(i) = KE_func(y(i,:)',biped_params);
       outputs.PotentialEnergy(i) = PE_func(y(i,:)',biped_params);
       outputs.Spring1Energy(i) = SpringE_func(y(i,:)',flowdata.State.pf1);
       outputs.Spring2Energy(i) = SpringE_func(y(i,:)',flowdata.State.pf2);
       if isfield(flowdata.Parameters,"Shaping")
           outputs.SpringAxisEnergy(i) = SpringAxisEnergy_func(y(i,:)',flowdata.State.pf1);
       else
           outputs.SpringAxisEnergy(i) = 0;
       end
       outputs.Energy(i) = ETotal_func(y(i,:)',biped_params,flowdata.State.pf1,flowdata.State.pf2);
       
       %Control Forces
       for j = 1:length(flowdata.Controls.Internal)
            [outputs.Forces(j,:,i),~, ~] = flowdata.Controls.Internal{j}(y(i,:)');
       end 
       
       for j = length(flowdata.Controls.Internal)+1:length(flowdata.Controls.External)
            [outputs.Forces(j,:,i),~, ~] = flowdata.Controls.External{j}(y(i,:)');
       end 
       
       %Spring Lengths
       outputs.L1thetaCords(i,:) = XYtoLTheta(y(i,:)',flowdata.State.pf1);
       outputs.L2thetaCords(i,:) = XYtoLTheta(y(i,:)',flowdata.State.pf2);
        
       %ODE Event Data
        [outputs.eventdata.value(:,i),...
         outputs.eventdata.isterminal(:,i),...
         outputs.eventdata.direction(:,i)] = flowdata.odeoptions.Events(t(i),y(i,:)');
    end
end