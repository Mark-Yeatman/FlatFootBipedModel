%clear all
path(pathdef)
addpath('Experiments\ModelTests\')
addpath('Analysis\')
addpath('UtilityFunctions\')

%Get all the simulations functions
addpath(genpath('Models\Prosthesis'))

initialize_Pros

%% Custom setup
%Control Functions
flowdata.Controls.Internal = {@SLIP,@KPBC};

%Control Parameters
flowdata.Parameters.SLIP.L0 = 1;
flowdata.Parameters.SLIP.k = 1500; 
flowdata.Parameters.SLIP.d = 0;

flowdata.Parameters.KPBC.k = 0;
flowdata.Parameters.KPBC.omega = diag([0,0,0,1,1]);
flowdata.Parameters.KPBC.sat = 100;
flowdata.Parameters.KPBC.Eref = 1;

%flowdata.E_func = @Energy_Sub;
flowdata.Flags.do_validation = false;
%xtest = xi;
xtest = zeros(1,10);
xtest(5) = deg2rad(10);
[fstate, xout, tout, out_extra] = walk(xtest,1);

videopath = 'Experiments\Videos\';
%animate(@drawProsthesis,xout,tout,[],1,strcat(videopath,'testSLIP_Pros'))
animate(@drawProsthesis,xout,tout,[],1)