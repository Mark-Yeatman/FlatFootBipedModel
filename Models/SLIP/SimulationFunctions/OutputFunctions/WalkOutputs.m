function outputs = WalkOutputs(t,x,stepOutputs)
    outputs.L1thetaCords = [];
    outputs.L2thetaCords = [];
    
    outputs.Forces = [];
    outputs.Net_Force = [];
    
    outputs.KineticEnergy = [];
    outputs.PotentialEnergy = [];
    outputs.Spring1Energy = [];
    outputs.Spring2Energy = [];
    outputs.SpringAxisEnergy = [];
    outputs.Energy = [];
    
    for i=1:length(stepOutputs)
        data = stepOutputs{i};
        
        %vectors
        outputs.Net_Force = [outputs.Net_Force, data{1}.Net_Force]; 
        outputs.Forces = cat(3,outputs.Forces,data{1}.Forces);
        
        outputs.KineticEnergy = [outputs.KineticEnergy, data{1}.KineticEnergy];   
        outputs.PotentialEnergy = [outputs.PotentialEnergy, data{1}.PotentialEnergy];   
        outputs.Spring1Energy = [outputs.Spring1Energy, data{1}.Spring1Energy];  
        outputs.Spring2Energy = [outputs.Spring2Energy, data{1}.Spring2Energy];   
        outputs.SpringAxisEnergy  = [outputs.SpringAxisEnergy, data{1}.SpringAxisEnergy];
        outputs.Energy  = [outputs.Energy, data{1}.Energy];
        
        outputs.L1thetaCords = [outputs.L1thetaCords; data{1}.L1thetaCords];  
        outputs.L2thetaCords = [outputs.L2thetaCords; data{1}.L2thetaCords];  
                
        %scalar
        outputs.steps{i}.phases = data{1}.phases;
        outputs.steps{i}.speed = data{1}.speed;
        outputs.steps{i}.steplength = data{1}.steplength;
        tlast = data{2};
        for j = 1:length(outputs.steps{i}.phases)    %Iterate over phases
            outputs.steps{i}.phases{j}.tstart = outputs.steps{i}.phases{j}.tstart + tlast;
            outputs.steps{i}.phases{j}.tend = outputs.steps{i}.phases{j}.tend + tlast;
        end
    end
        
end

