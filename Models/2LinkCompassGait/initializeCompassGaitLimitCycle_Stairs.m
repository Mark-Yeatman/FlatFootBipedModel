global flowdata

flowdata = flowData;
flowdata.E_func = @TotalE_func;
%ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-10, 'AbsTol', 1e-10);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.ignore = true;

%simulation parameters
flowdata.Parameters.Environment.slope = -deg2rad(3.7);   %ground slope
flowdata.Parameters.dim = 8;        %state variable dimension
 
%Biped Parameters
flowdata.Parameters.Biped.Mh = 10;
flowdata.Parameters.Biped.Ms = 5;
flowdata.Parameters.Biped.a = 0.5;
flowdata.Parameters.Biped.b = 0.5;
flowdata.Parameters.Biped.asvector = [10,5,0.5,0.5];

%Discrete Mappings and Constraints
flowdata.setPhases({'SSupp'})
impactlist =  {'FootStrike'};
n_phaselist = {'SSupp'};
n_configlist = {'keep'};
flowdata.setImpacts(impactlist,n_phaselist,n_configlist);
flowdata.End_Step.event_name = 'FootStrike';
flowdata.Phases.SSupp.eventf = 'guardSSupp_Stairs';
%Set initial phase, contact conditions, and state
flowdata.State.c_phase = 'SSupp';
flowdata.State.c_configs = {};
load('xi.mat')

%ODE options 
flowdata.odeoptions.Events = flowdata.Phases.SSupp.eventf;

%Load more parameters and initial states
load('MassInertiaGeometryCompass.mat')
