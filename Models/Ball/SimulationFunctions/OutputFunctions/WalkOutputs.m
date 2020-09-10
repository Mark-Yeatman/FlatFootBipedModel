function outputs = WalkOutputs(t,x,stepOutputs)
    global flowdata
    outputs = [];
    outputs.u = [];
    outputs.KineticEnergy = [];
    outputs.PotentialEnergy = [];
    outputs.SpringEnergy = [];
    outputs.Force = [];
    
     for i=1:length(stepOutputs)
         data = stepOutputs{i};
         outputs.u = [outputs.u; data{1}.u];   
         outputs.KineticEnergy = [outputs.KineticEnergy; data{1}.KineticEnergy];   
         outputs.PotentialEnergy = [outputs.PotentialEnergy; data{1}.PotentialEnergy];   
         outputs.SpringEnergy = [outputs.SpringEnergy; data{1}.SpringEnergy];   
         outputs.Force = cat(3,outputs.Force,data{1}.Force);

     end
   outputs.E = outputs.KineticEnergy + outputs.PotentialEnergy + outputs.SpringEnergy;
end

