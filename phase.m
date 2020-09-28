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

    %Run the ode solver
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
        event_name = 'None';
        xcontact = [];
        tcontact = [];
    else 
        x = y(:, 1:length(xin));
        event_name = flowdata.Impacts{ie(end)}.name;
        tcontact = t(end);
        xcontact = y(end,1:length(xin)); %pre impact state
    end   
    
    %Check if biped fell over
    if any(abs(x(:,3))>pi/2) && ~flowdata.Flags.ignore_fall
       warning('Biped fell over. ')
       flowdata.Flags.terminate = true;
    end
    
    %Generate additional output struct  
    out.phase_name = flowdata.State.c_phase;
    out.configs = flowdata.State.c_configs;
    out.x_start = xin;
    out.x_end = xcontact; 
    out.t_start = t(1);
    out.t_end = t(end);
    out.event_name = event_name;
    for i = 1:length(flowdata.PhaseOutputFuncs)
        f = flowdata.PhaseOutputFuncs{i};
        out.(func2str(f)) =  f(t,y);
    end
end

