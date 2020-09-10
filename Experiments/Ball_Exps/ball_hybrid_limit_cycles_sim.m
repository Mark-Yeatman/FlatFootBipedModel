clear all
path(pathdef)
addpath('Experiments\Ball_Exps\')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath(genpath('Models\Ball\'))

global flowdata

flowdata = flowData();
flowdata.E_func = @TotalE_func;
%ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-6, 'AbsTol', 1e-6, 'MaxStep',1e-3);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.warnings = false;

%simulation parameters
flowdata.Parameters.dim = 4; %state variable dimension

%Environment Parameters
e = 1;
h = 0;
flowdata.Parameters.Environment.e = e;
flowdata.Parameters.Environment.h = h;

%Biped Parameters
m = 80;
g = 9.81;
flowdata.Parameters.Biped = containers.Map({'m','g'},{m,g});

%Control Parameters
flowdata.Controls.Internal = {@MassSpringControl};

k = 0;
L0 = 0;
flowdata.Parameters.Spring.k = k;
flowdata.Parameters.Spring.L0 = L0;

%Discrete Mappings 
flowdata.setPhases({'Oscillate'})
flowdata.setConfigs({})
e1 = struct('name','Impact','nextphase','Oscillate','nextconfig','');
flowdata.Phases.Oscillate.events = {e1};
flowdata.End_Step.event_name = 'Impact';

%Set initial phase and contact conditions
flowdata.State.c_phase = 'Oscillate';
flowdata.State.c_configs = {};
flowdata.setImpacts();

%ODE event initialization
flowdata.tspan = 10; %seconds
v = 1:0.5:5;
results = {1,length(v)};
E_labels = {1,length(v)};

for i = 1:length(v)
    
    %Simulate
    xi = [0,0,0,v(i)];
    E = flowdata.E_func(xi');
    [fstate, xout, tout, out_extra] = walk(xi,1);
    results{i} = {E,fstate,xout,tout,out_extra};
    E_labels{i} = num2str(E);
    
end

save(strcat(pwd,'\Experiments\Ball_Exps\Data\Level_Ground_Data'),'results','E_labels','h')
