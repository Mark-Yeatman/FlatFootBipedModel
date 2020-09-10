clear all

path(pathdef)
addpath('Experiments')
addpath('Experiments\EnergyShapeAndTrack_Compass\')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath(genpath('Models\2LinkCompassGait\'))

initializeCompassGaitLimitCycle

%Add Control Function
flowdata.Controls.Internal = {@Shaping};

%Shaping Control Parameters
flowdata.Parameters.Shape.Mh = 9.5;
flowdata.Parameters.Shape.Ms = 5;
flowdata.Parameters.Shape.a = 0.5;
flowdata.Parameters.Shape.b = 0.5;
flowdata.Parameters.Shape.asvector = [5,5,0.5,0.5];

flowdata.Flags.do_validation = false;
[fstate, xout, tout, out_extra] = walk(xi,25);
