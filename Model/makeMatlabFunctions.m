function makeMatlabFunctions()
% Turns the mathematica derivation of the robot dynamics into optimized executable matlab functions. 

%% Setup
    %Where to put the matlab functions
    mylocation = which(mfilename);
    [thisdir,~,~] = fileparts(mylocation);
    configFolder = strcat(thisdir,'\SimulationFunctions');

    %Where to get the "mathematica" functions
    SymFuncsPath = strcat(pwd,"\Derivations\ToMatlabOutputs\7LinkFlatFoot");
    addpath(genpath(SymFuncsPath))
   
    %Make readme for the model and config. 
    %fid = fopen(strcat(configFolder,'\info.txt'), 'wt' );
    %fprintf( fid,'Current Configuration: Double Support\nThis configuration has a heel, flat, toe, and double support walking phases. The mass parameters are baked into the simulation functions by makeMatlabFunctionsCompass.m ');
    %fclose(fid);
    
    %Which physical parameters to use
    %load('MassInertiaGeometry.mat') 
    lt = 0;
    ls = 0;
    syms Mt Ms Mh Mf lt ls lf la Itz Ity Itx Isz Isx Isy Ihz Ihx Ihy
    g = 9.81;
    params = [Mt Ms Mh Mf lt ls lf la Itz Ity Itx Isz Isx Isy Ihz Ihx Ihy];
%% Make the matlabfunctions
    dim = 16;
    x = sym('x',[dim,1]);
    a = sym('a',[dim/2,1]);

%     M_matrix
%     C_matrix
%     G_matrix
    COM_accel
    folder = strcat(configFolder,'\DynamicsFunctions\');
    status = mkdir(folder);
    %The mass matrix isn't quite right for some reason
%     matlabFunction(M,   'File',strcat(folder,'M_func'),'Vars',{x,params})
%     matlabFunction(Cmat,'File',strcat(folder,'C_func'),'Vars',{x,params})
%     matlabFunction(G,   'File',strcat(folder,'G_func'),'Vars',{x,params})
    matlabFunction(ddCoM,'File',strcat(folder,'COM_accel_func'),'Vars',{x,a,params})

    %Kinetic_energy
    Potential_energy

    folder = strcat(configFolder,'\EnergyFunctions\');
    status = mkdir(folder);
    %matlabFunction(Ke,'File',strcat(folder,'KE_func'),'Vars',{x,params})
    %I put this in a custom function that calls M_func because it was taking a
    %while to make the kinetic energy function from the mathematica output
    matlabFunction(Pe,'File',strcat(folder,'PE_func'),'Vars',{x,params})
    
    Toe_st_pos
    Ankle_st_pos
    Knee_st_pos
    Hip_pos
    Knee_sw_pos
    Ankle_sw_pos
    Toe_sw_pos
    Heel_sw_pos
    COM_pos
    
    folder = strcat(configFolder,'\KinematicFunctions\');
    status = mkdir(folder);
    matlabFunction(posToest,'File',strcat(folder,'Toe_St_pos_func'),'Vars',{x,params})
    matlabFunction(posAst,  'File',strcat(folder,'Ankle_St_pos_func'),'Vars',{x,params})
    matlabFunction(posKst,  'File',strcat(folder,'Knee_St_pos_func'),'Vars',{x,params})
    matlabFunction(posH,    'File',strcat(folder,'Hip_pos_func'),'Vars',{x,params})
    matlabFunction(posKsw,  'File',strcat(folder,'Knee_Sw_pos_func'),'Vars',{x,params})
    matlabFunction(posToesw,'File',strcat(folder,'Toe_Sw_pos_func'),'Vars',{x,params})
    matlabFunction(posAsw,  'File',strcat(folder,'Ankle_Sw_pos_func'),'Vars',{x,params})
    matlabFunction(posHeelsw,'File',strcat(folder,'Heel_Sw_pos_func'),'Vars',{x,params})
    matlabFunction(posCoM,  'File',strcat(folder,'COM_pos_func'),'Vars',{x,params})
    
    Toe_st_vel
    Ankle_st_vel
    Knee_st_vel
    Hip_vel
    Knee_sw_vel
    Ankle_sw_vel
    Toe_sw_vel
    Heel_sw_vel
    COM_vel
    matlabFunction(velToest,'File',strcat(folder,'Toe_St_vel_func'),'Vars',{x,params})
    matlabFunction(velAst,  'File',strcat(folder,'Ankle_St_vel_func'),'Vars',{x,params})
    matlabFunction(velKst,  'File',strcat(folder,'Knee_St_vel_func'),'Vars',{x,params})
    matlabFunction(velH,    'File',strcat(folder,'Hip_vel_func'),'Vars',{x,params})
    matlabFunction(velKsw,  'File',strcat(folder,'Knee_Sw_vel_func'),'Vars',{x,params})
    matlabFunction(velToesw,'File',strcat(folder,'Toe_Sw_vel_func'),'Vars',{x,params})
    matlabFunction(velAsw,  'File',strcat(folder,'Ankle_Sw_vel_func'),'Vars',{x,params})
    matlabFunction(velHeelsw,  'File',strcat(folder,'Heel_Sw_vel_func'),'Vars',{x,params})
    matlabFunction(velCoM,  'File',strcat(folder,'COM_vel_func'),'Vars',{x,params})

    Toe_st_Jacobian
    Ankle_st_Jacobian
    Knee_st_Jacobian
    Hip_Jacobian
    Knee_sw_Jacobian
    Ankle_sw_Jacobian
    Toe_sw_Jacobian

    matlabFunction(js0, 'File',strcat(folder,'Toe_St_Jacobian_func'),'Vars',{x,params})
    matlabFunction(js1, 'File',strcat(folder,'Ankle_St_Jacobian_func'),'Vars',{x,params})
    matlabFunction(js2, 'File',strcat(folder,'Knee_St_Jacobian_func'),'Vars',{x,params})
    matlabFunction(js3, 'File',strcat(folder,'Hip_Jacobian_func'),'Vars',{x,params})
    matlabFunction(js4, 'File',strcat(folder,'Knee_Sw_Jacobian_func'),'Vars',{x,params})
    matlabFunction(js5, 'File',strcat(folder,'Toe_Sw_Jacobian_func'),'Vars',{x,params})
    matlabFunction(js6, 'File',strcat(folder,'Ankle_Sw_Jacobian_func'),'Vars',{x,params})
       
    %% Test the functions
%     load xi.mat
%     M_func(xi');
%     C_func(xi');
%     G_func(xi');
%     %DSLIP_func_1(xi',1,1);
%     %DSLIP_func_2(xi',1,1);
% 
%     Foot_St_pos_func(xi');
%     Knee_St_pos_func(xi');
%     Hip_pos_func(xi');
%     Knee_Sw_pos_func(xi');
%     Foot_Sw_pos_func(xi');
%     COM_pos_func(xi');

end
