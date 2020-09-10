path(pathdef)
addpath('Experiments\KPBC_7Link\')
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
flowdata.Controls.External = {@DKPBC};

%Setup KPBC parameters
flowdata.Parameters.KPBC.Eref.Heel = 4.660213725063600e+02;
flowdata.Parameters.KPBC.Eref.Flat = 4.597261434307048e+02;
flowdata.Parameters.KPBC.Eref.Toe  = 4.511036703555230e+02;

flowdata.Parameters.KPBC.satU = inf;
flowdata.Parameters.KPBC.k = 1;
flowdata.Parameters.KPBC.omega = diag([0,0,0,1,1,0,0,0]);

disturbance = [zeros(1,8),rand(1,8)*0.01];
xtest = xi + disturbance;

flowdata.State.Einit = Energy_Sub(xtest');

[fstate, xout, tout, out_extra] = walk(xtest,10);

videopath = 'Experiments\Data\Videos\';
% animate(@draw7Link,xout,tout,out_extra,1)