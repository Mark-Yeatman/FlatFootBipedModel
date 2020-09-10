function outputs = PhaseOutputs(t,y,xin)
global flowdata
    %dim = flowdata.Parameters.dim;

    for i = 1:length(t)
       outputs.u(i,:) = flowdata.eqnhandle(t(i),y(i,:)','u');
       outputs.KineticEnergy(i,:) = KE_func(y(i,:)');
       outputs.PotentialEnergy(i,:) = PE_func(y(i,:)');
       outputs.SpringEnergy(i,:) = SE_func(y(i,:)');

       
       %Control Forces
       for j = 1:length(flowdata.Controls.Internal)
            outputs.Force(j,:,i) = flowdata.Controls.Internal{j}(y(i,:)');
       end 
     end
end