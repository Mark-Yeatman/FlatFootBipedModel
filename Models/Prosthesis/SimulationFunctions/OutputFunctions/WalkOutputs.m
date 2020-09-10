function outputs = WalkOutputs(t,x,stepOutputs)
global flowdata
    outputs = [];
    outputs.GenE = zeros(length(x),1);
    outputs.u = []; 
    for i = 1:length(x)
        outputs.GenE(i) = flowdata.E_func(x(i,:)');
    end
  
    for i=1:length(stepOutputs)
        data = stepOutputs{i};        
        %over walk data
        outputs.u = [outputs.u; data{1}.u]; 
    end
    
end