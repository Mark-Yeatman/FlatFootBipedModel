function outputs = StepOutputs(t,y,phase_outputs,xin)
    outputs.phases={};
    
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
    
    outputs.steplength = norm( y(end,1)' - xin(1)' );             
    outputs.speed = outputs.steplength /(max(t)-min(t));
    for i=1:length(phase_outputs)
        
        data = phase_outputs{i};
        
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
        outputs.phases{i} = data{1};
        outputs.phases{i}.tstart = data{2};
        outputs.phases{i}.tend = data{3};
        outputs.phases{i}.impact_name = data{4};

    end

end