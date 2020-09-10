% Plots the energy of the SLIP model "super-imposed" on human data. 

if ~exist('Gaitcycle','var')
    load("C:\Users\mxy110230\Documents\KylesData\InclineExperiment.mat","Gaitcycle")
end

path(pathdef)
addpath('Experiments')
addpath('Analysis\')
addpath('UtilityFunctions\')

%Get all the simulations functions
addpath(genpath('Models\Prosthesis'))

%Initialize flowdata and other variables
global flowdata

flowdata = flowData;
flowdata.E_func = @MechE_func;

%Simulation parameters
flowdata.Parameters.Environment.slope = 0;   %ground slope
dim = 10;
flowdata.Parameters.dim = dim;                %state variable dimension

%Biped Parameters
flowdata.Parameters.Biped = load('MassInertiaGeometry');
load('MassInertiaGeometry')
Mh = 80; %kg
flowdata.Parameters.Biped.asvector = [Mh, Mt, Ms, Mf, Ihz, Itz, Isz, lt, ls, la, lf]; %From ordering in makeMatlabFunctionsProthesis

cut_i =  89;
cut_v = 89/150;
switch_i = 0.12*150;

Subjects = fieldnames(Gaitcycle);
%Subjects = {'AB10'};
trial = 's1i0';


set(0,'DefaultFigureWindowStyle','docked')

for j = 1:length(Subjects)   
    
    s = Subjects{j};
    scale = Gaitcycle.(s).subjectdetails{4,2}/1000;
    step = 20;
%     lf = Limbs.(s).FromMarkers.BallOFoot/1000; 
%     la = lf*(0.039)/0.152; %magic numbers from from page 83 in winter's biomechanics
%     ls = Limbs.(s).FromMarkers.Shank/1000;
%     lt = Limbs.(s).FromMarkers.Thigh/1000; 
    
    lf = 0.6*Gaitcycle.(s).subjectdetails{3,2}/1000 *(0.152); %magic numbers from from page 83 in winter's biomechanics
    la = Gaitcycle.(s).subjectdetails{3,2}/1000 *(0.039); 
    ls = Gaitcycle.(s).subjectdetails{3,2}/1000 *(0.285)-la; 
    lt = Gaitcycle.(s).subjectdetails{3,2}/1000 *(0.530)-ls-la; 
    
    %Get data out of struct  
    ankle_pos = Gaitcycle.(s).(trial).kinematics.jointangles.right.ankle.x(1:cut_i, step);
    knee_pos = Gaitcycle.(s).(trial).kinematics.jointangles.right.knee.x(1:cut_i , step);
    hip_pos = Gaitcycle.(s).(trial).kinematics.jointangles.right.hip.x(1:cut_i, step);         
    ti = Gaitcycle.(s).(trial).cycles.right.time(1:cut_i, step);
    
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
    
    k = k_0 * Gaitcycle.(s).subjectdetails{4,2} / m_0;
    L0 = Spring_Length_Heel_func(xstart');
    
    q = zeros(length(ti),10);    
    SpringEnergy = zeros(length(ti),1);  
    PotentialEnergy = zeros(length(ti),1);  
    heel_vel = zeros(length(ti),1);  
    KineticEnergy = zeros(length(ti),1); 
    HipVelLin = zeros(length(ti),3); %x, y, norm 
    %The human coords --> biped coords
    for i = 1:length(ti)  
       heel_angle = hip_pos(i)-knee_pos(i)+ankle_pos(i);
       heel_vel(i) = hip_vel(i)-knee_vel(i)+ankle_vel(i);      
       %Don't forget to convert degrees to radians
       if deg2rad(heel_angle) > flowdata.Parameters.Environment.slope 
           q(i,:) = deg2rad([0,0,heel_angle, -ankle_pos(i), knee_pos(i)...
                             0,0,heel_vel(i), ankle_vel(i), knee_vel(i)]);
       else
           q(i,:) = deg2rad([0,0,heel_angle, -ankle_pos(i),knee_pos(i)...
                             0,0,heel_vel(i), ankle_vel(i), -knee_vel(i)]);
           %Lock the toe to the ground
           %q(i,1:2) = -[-lf*cosd(-flowdata.Parameters.Environment.slope),lf*sind(-flowdata.Parameters.Environment.slope)]+[-lf*cosd(-hip_pos(i)),lf*sind(-hip_pos(i))];
           %q(i,1+dim/2:2+dim/2) = [hip_vel(i)*lt*sind(hip_pos(i)),-hip_vel(i)*lt*cosd(hip_pos(i))];
       end
       %Calculate energies
       L = Spring_Length_func(q(i,:)');
       SpringEnergy(i) = 1/2*k*(L - L0)^2;
       KineticEnergy(i) = KE_func(q(i,:)',flowdata.Parameters.Biped.asvector);
       PotentialEnergy(i) = PE_func(q(i,:)',flowdata.Parameters.Biped.asvector);
       temp = Hip_vel_func(q(i,:)');
       HipVelLin(i,1) = temp(1,4);
       HipVelLin(i,2) = temp(2,4);
       HipVelLin(i,3) = norm(HipVelLin(i,1:2),2);
    end
    TotalEnergy = SpringEnergy + KineticEnergy + PotentialEnergy;
    
    figure('Name',s,'NumberTitle','off')
    subplot(2,2,1)
    t = linspace(0, cut_v, cut_i);
    plot(t, SpringEnergy, t, PotentialEnergy, t, KineticEnergy, t, TotalEnergy );
    title('SLIP Energy Comparisons')
    xlabel('Normalized Time')
    ylabel('Energy (J)')
    legend('Spring','Potential', 'Kinetic', 'Total')

    subplot(2,2,2)
    t = linspace(0, cut_v, cut_i);
    plot(t, KineticEnergy);
    title('Kinetic Energy')
    xlabel('Normalized Time')
    ylabel('Energy (J)')
    
    subplot(2,2,3)
    t = linspace(0, cut_v, cut_i);
    plot(t,HipVelLin, t,hip_vel);
    title('Hip Velocities')
    xlabel('Normalized Time')
    ylabel('Velocity (m/s)')
    legend('x','y','norm','hip angluar')
    
    subplot(2,2,4)
    t = linspace(0, cut_v, cut_i);
    plot(t, SpringEnergy, t, PotentialEnergy);
    title('Spring and Potential Energy')
    xlabel('Normalized Time')
    ylabel('Energy (J)')
    legend('Spring','Potential')
end
set(0,'DefaultFigureWindowStyle','normal')