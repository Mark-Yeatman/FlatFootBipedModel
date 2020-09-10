function [t, x, tcontact, xcontact, ie, out] = phase(t,xin)
%Handle continuous dynamics
global flowdata
    %display the contact condition
    myprint([flowdata.State.c_phase,'-->']) ;
      
    %prep and call ode solver
    if isprop(flowdata,'tspan')
        tspan = flowdata.tspan;
    else
        tspan = 1;
    end

    %Initial work or energy of 'external' controllers
    if isfield(flowdata.State,'Einit')
        Work = flowdata.State.Einit;
    else
        Work = zeros(1,length(flowdata.Controls.External));
    end

    tplus = [0, tspan];
    yin = [xin, Work];
    ie = [];
    if isempty(flowdata.odeoptions.Events)
        [t,y] = ode15s(flowdata.eqnhandle, t+tplus, yin, flowdata.odeoptions);
    else
        [t,y,~,~,ie] = ode15s(flowdata.eqnhandle, t+tplus, yin, flowdata.odeoptions);
    end
       
    %Check if an event even happened 
    if isempty(ie)
        x = y(:, 1:length(xin));
        xcontact = [];
        tcontact = [];
    else 
        x = y(:, 1:length(xin));
        tcontact = t(end);
        xcontact = y(end,1:length(xin)); %pre impact state
    end   
    
    %Check if biped fell over
    if any(abs(x(:,3))>pi/2) && ~flowdata.Flags.ignore
       warning('Biped fell over. ')
       flowdata.Flags.terminate = true;
    end
    
    out = PhaseOutputs(t,y,xin);   
end

