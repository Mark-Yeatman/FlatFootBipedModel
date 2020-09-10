function outputs = PhaseOutputs(t,y,xin)
global flowdata
    outputs = [];
    outputs.u = zeros(length(flowdata.Controls.Internal)+length(flowdata.Controls.External),length(y),flowdata.Parameters.dim/2);
    outputs.W = y(:,end);
    for i = 1:length(y)
        outputs.u(:,i,:) = flowdata.eqnhandle(t(i),y(i,:)','Z');
    end
end