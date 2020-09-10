path(pathdef)
addpath('Experiments')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath('Models\7LinkFlatFoot\SSupp')

%Get all the simulations functions
addpath(genpath('Models\7LinkFlatFoot\DSupp'))

%Use the sigle support constraints
rmpath('Models\7LinkFlatFoot\DSupp\SimulationFunctions\ConstraintFunctions\')
addpath('Models\7LinkFlatFoot\SSupp\SimulationFunctions\ConstraintFunctions\')

initialize_SSupp_0x095Slope
flowdata.Flags.do_validation = false;

%Control Functions
flowdata.Controls.External = {@KPBC};

%Setup KPBC reference energies
flowdata.Parameters.KPBC.Eref.Heel = 4.601579280228374e+02;
flowdata.Parameters.KPBC.Eref.Flat = 4.652659470336086e+02;
flowdata.Parameters.KPBC.Eref.Toe  = 4.442296098112448e+02;

%Setup gains
flowdata.Parameters.KPBC.satU = inf;
flowdata.Parameters.KPBC.k = 5;
flowdata.Parameters.KPBC.omega = diag([0,0,0,1,1,0.001,1,1]);

xtest = xi;
disturbance = [zeros(1,8),rand(1,8)*0.01];

[fstate, xout, tout, out_extra] = walk(xtest + disturbance,10);

videopath = 'Experiments\Data\Videos\';
animate(@draw7Link,xout,tout,out_extra,1)