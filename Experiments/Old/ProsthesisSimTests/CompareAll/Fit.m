path(pathdef)
addpath('Experiments\ProsthesisSimTests\CompareAll\')
addpath('Analysis\')
addpath('UtilityFunctions\')

%Get all the simulations functions
addpath(genpath('Models\Prosthesis'))

%Initialize flowdata and other variables
global flowdata human_torques human_trajectories 

flowdata = flowData;
flowdata.E_func = @MechE_func;

%Simulation parameters
flowdata.Parameters.Environment.slope = 0;   %ground slope
flowdata.Parameters.dim = 10;                %state variable dimension

%Biped Parameters
flowdata.Parameters.Biped = load('MassInertiaGeometry');
load('MassInertiaGeometry')
%flowdata.Parameters.Biped.asvector = [Mh, Mt, Ms, Mf, Ihz, Itz, Isz, lt, ls, la, lf]; %From ordering in makeMatlabFunctionsProthesis

%Extra psuedoparameters
R = 0.3*(ls+lt); %curved foot radius
phi = 0; %radial ankle angle offset
flowdata.Parameters.Biped.R = R;
flowdata.Parameters.Biped.phi = phi;
flowdata.Parameters.Biped.asvector = [Mh, Mt, Ms, Mf, Ihz, Itz, Isz, lt, ls, la, lf, R, phi];

%Discrete Mappings 
flowdata.setPhases({'Heel','Flat','Toe'})
flowdata.setConfigs({})
impactlist =  {'Footslap','Tiptoe','Heelstrike'};
n_phaselist = {'Flat','Toe','Heel'};
n_configlist = {'keep','keep','keep'};
flowdata.setImpacts(impactlist,n_phaselist,n_configlist);
flowdata.End_Step.event_name = 'Heelstrike';

%Control Functions
flowdata.Controls.Internal = {@LinSpring_Flat,@LinDamp_Flat,@LinSpring_Curved, @LinDamp_Curved};

%Control Parameters
flowdata.Parameters.SLIP.L0 = 0;
flowdata.Parameters.SLIP.k = 0; 
flowdata.Parameters.SLIP.d = 0;

%Set initial phase and contact conditions
flowdata.State.c_phase = 'Heel';
flowdata.State.c_configs = {};
flowdata.State.Eref = 0;
flowdata.odeoptions.Events = flowdata.Phases.('Heel').eventf;

%Only use stance data, I know from the data format spec that each stride
%has exactly 150 time points

cut_i =  89;
cut_v = 89/150;
switch_i = 0.12*150;

Subjects = fieldnames(Gaitcycle);
%Subjects = {'AB10'};
trial = 's1i0';

%Control parameters 
R = 0.19*(ls+lt); %*0.175
phi = deg2rad(-30); %-30

%Output Data
OptData = struct();
FigArray = cell(length(Subjects),1);
AxisArray = cell(length(Subjects),2);

set(0,'DefaultFigureWindowStyle','docked')
for j = 1:length(Subjects)   
    s = Subjects{j};
    scale = Gaitcycle.(s).subjectdetails{4,2}/1000;
    
    lf = Limbs.(s).FromMarkers.BallOFoot/1000; 
    la = lf*(0.039)/0.152; %magic numbers from from page 83 in winter's biomechanics
    ls = Limbs.(s).FromMarkers.Shank/1000;
    lt = Limbs.(s).FromMarkers.Thigh/1000; 

    flowdata.Parameters.Biped.R = R;
    flowdata.Parameters.Biped.phi = phi;
    flowdata.Parameters.Biped.asvector = [Mh, Mt, Ms, Mf, Ihz, Itz, Isz, lt, ls, la, lf, R, phi];
    flowdata.Parameters.Biped.lf = lf;
    
    ankle_pos = Gaitcycle.(s).(trial).kinematics.jointangles.right.ankle.x_mean(1:cut_i);
    knee_pos = Gaitcycle.(s).(trial).kinematics.jointangles.right.knee.x_mean(1:cut_i);
    hip_pos = Gaitcycle.(s).(trial).kinematics.jointangles.right.hip.x_mean(1:cut_i);
          
    ti = 1:cut_i;
    
    hipspline = spline(ti, hip_pos);
    p_der=fnder(hipspline,1);
    hip_vel = ppval(p_der,ti);
    
    kneespline = spline(ti, knee_pos);
    p_der=fnder(kneespline,1);
    knee_vel = ppval(p_der,ti);
    
    anklespline = spline(ti, ankle_pos);
    p_der=fnder(anklespline,1);
    ankle_vel = ppval(p_der,ti);
    
    m_0 = Gaitcycle.AB06.subjectdetails{4,2};
    k_0 = 15250;
    
    i = 1;
    heel_angle = hip_pos(i)-knee_pos(i)+ankle_pos(i);
    heel_vel = hip_vel(i)-knee_vel(i)+ankle_vel(i);

    xstart = deg2rad([0,0,heel_angle, -ankle_pos(i), knee_pos(i)...
                     0,0,heel_vel, ankle_vel(i), knee_vel(i)]);
    
    flowdata.Parameters.SLIP.k = k_0 * Gaitcycle.(s).subjectdetails{4,2} / m_0;
    flowdata.Parameters.SLIP.d = (0)*flowdata.Parameters.SLIP.k;
    
    q = zeros(length(ti),10);    
    
    iswitch = -1;
    %The human coords --> biped coords
    for i = 1:length(ti)  
       heel_angle = hip_pos(i)-knee_pos(i)+ankle_pos(i);
       heel_vel = hip_vel(i)-knee_vel(i)+ankle_vel(i);
       if deg2rad(heel_angle) > flowdata.Parameters.Environment.slope %i<switch_i
           %convert degrees to radians
           q(i,:) = deg2rad([0,0,heel_angle, -ankle_pos(i), knee_pos(i)...
                             0,0,heel_vel, ankle_vel(i), knee_vel(i)]);
       else
           if iswitch == -1
               iswitch = i;
           end
           q(i,:) = deg2rad([0,0,heel_angle, -ankle_pos(i),knee_pos(i)...
                             0,0,heel_vel, ankle_vel(i), -knee_vel(i)]);
           q(i,1:2) = -[-lf*cosd(-flowdata.Parameters.Environment.slope),lf*sind(-flowdata.Parameters.Environment.slope)]+[-lf*cosd(-heel_angle),lf*sind(-heel_angle)];
       end      
    end
    
    human_trajectories = q;
    
    %data filter
    cutoff_f = 25;
    sample_f = 150;
    [cf_b,cf_a] = butter(5, cutoff_f/(sample_f/2), 'low'); %5th order butterworth, 50 Hz cutoff frequency
    knee_filt =  filtfilt(cf_b,cf_a,Gaitcycle.(s).(trial).kinetics.jointmoment.right.knee.x_mean(1:cut_i)*scale);
    ankle_filt =  filtfilt(cf_b,cf_a,Gaitcycle.(s).(trial).kinetics.jointmoment.right.ankle.x_mean(1:cut_i)*scale);
    
    %Pre setup visualization
    FigArray{j} = figure('Name',s,'NumberTitle','off');
    
    AxisArray{j,1} = subplot(2,1,1);
    %plot(ti,Gaitcycle.(s).(trial).kinetics.jointmoment.right.ankle.x_mean(1:cut_i)*scale,'LineWidth',1.5,'DisplayName','Human')
    plot(ti,ankle_filt,'LineWidth',1.5,'DisplayName','Human')
    drawnow();
    r = refline(0,0);
    r.Color = 'k';
    r.HandleVisibility = 'off';
    axis tight
    grid on
    legend('Location','northwest')
    title('Ankle Torque Comparison')
    xlabel('Normalized Time')
    ylabel('Torque(N m)')
    
    AxisArray{j,2} = subplot(2,1,2);
    %plot(ti,Gaitcycle.(s).(trial).kinetics.jointmoment.right.knee.x_mean(1:cut_i)*scale,'LineWidth',1.5,'DisplayName','Human')
    plot(ti,knee_filt,'LineWidth',1.5,'DisplayName','Human')
    drawnow();
    r = refline(0,0);
    r.Color = 'k';
    r.HandleVisibility = 'off';
    axis tight
    grid on
    legend('Location','northwest')
    title('Knee Torque Comparison')
    xlabel('Normalized Time')
    ylabel('Torque(N m)')
    
    %% Optimization time
    DoubleSpringOpt %2 springs, 1 at heel, 1 at toe, params are the set lengths and stiffnesses
    LinSpringFlatOpt %1 spring, params are foot length, set length, stiffness
    LinSpringCurvedOpt %1 spring, params are radius, curve to ankle angle, set length, stiffness
    
%     filename = strcat('Experiments\ProsthesisSimTests\Figures\CompareAll',s);
%     saveas(fig, filename)
%     saveas(fig, strcat(filename,'.png'))
end
set(0,'DefaultFigureWindowStyle','normal')
