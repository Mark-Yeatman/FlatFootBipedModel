function makeMatlabFunctions()
% Turns the mathematica derivation of the robot dynamics into optimized executable matlab functions. 

    %Where to put the matlab functions
    mylocation = which(mfilename);
    [thisdir,~,~] = fileparts(mylocation);
    idcs   = strfind(thisdir,'\');
    configFolder = thisdir;%(1:idcs(end)-1);

    %Where to get the "mathematica" functions
    SymFuncsPath = strcat(pwd,"\Derivations\ToMatlabOutputs\4LinkPointFoot");
    addpath(genpath(SymFuncsPath))

    %What to comment
    comment = "Compass Gait Configuration file. Only needs state as inputs, parameters are already substituted in";
    
    %Make readme for the model and config. 
    fid = fopen(strcat(configFolder,'\SimulationFunctions\info.txt'), 'wt' );
    fprintf( fid,'Current Configuration: CompassGait\nThis configuration is supposed to act like the compass gait model, by locking the knees on the 4 link biped. The mass parameters come from Spongs 2007 Passivity Based Control of Biped Walking. The mass parameters are baked into the simulation functions by makeMatlabFunctionsCompass.m ');
    fclose(fid);
    
    %Which physical parameters to use
    load('MassInertiaGeometryCompass.mat') 
    syms k L0 %DSLIP parameters
    Isx = 0;
    Isy = 0;
    Itx = 0;
    Ity = 0;
    g = 9.81;

    %Make the matlabfunctions
    %dim = 12;

    
    a = sym('a',[6,1]);

    M_matrix
    C_matrix
    G_matrix
    %DSLIP_matrix1
    %DSLIP_matrix2
    COM_accel
    folder = strcat(configFolder,'\SimulationFunctions\DynamicsFunctions\');
    status = mkdir(folder);
    matlabFunction(M,   'File',strcat(folder,'M_func'),'Vars',{x},'Comments',comment)
    matlabFunction(Cmat,'File',strcat(folder,'C_func'),'Vars',{x},'Comments',comment)
    matlabFunction(G,   'File',strcat(folder,'G_func'),'Vars',{x},'Comments',comment)
    %matlabFunction(tau1,'File','SimulationFunctions\DynamicsFunctions\DSLIP_func_1','Vars',{x,k,L0})
    %matlabFunction(tau2,'File','SimulationFunctions\DynamicsFunctions\DSLIP_func_2','Vars',{x,k,L0})
    matlabFunction(ddCoM,'File',strcat(folder,'COM_accel_func'),'Vars',{x,a})

    ASSupp_matrix
    ADSupp_matrix
    ASwap_matrix
    AKLockSw_matrix
    AKLockSt_matrix
    AVHC_matrix
    AdotSSupp_matrix
    AdotDSupp_matrix
    AdotSwap_matrix
    AdotKLockSw_matrix
    AdotKLockSt_matrix
    AdotVHC_matrix
    
    folder = strcat(configFolder,'\SimulationFunctions\ConstraintFunctions\');
    status = mkdir(folder);
    matlabFunction(Adsupp,          'File',strcat(folder,'A_DSupp_func'),'Vars',{x},'Comments',comment)
    matlabFunction(sym(Assupp),     'File',strcat(folder,'A_SSupp_func'),'Vars',{x},'Comments',comment)
    matlabFunction(Aswap,           'File',strcat(folder,'A_Swap_func'),'Vars',{x},'Comments',comment)
    matlabFunction(sym(Aklocksw),   'File',strcat(folder,'A_KLockSw_func'),'Vars',{x},'Comments',comment)
    matlabFunction(sym(Aklockst),   'File',strcat(folder,'A_KLockSt_func'),'Vars',{x},'Comments',comment)
    matlabFunction(sym(Avhc),   'File',strcat(folder,'A_VHC_func'),'Vars',{x},'Comments',comment)

    matlabFunction(Adotdsupp,       'File',strcat(folder,'Adot_DSupp_func'),'Vars',{x},'Comments',comment)
    matlabFunction(sym(Adotssupp),  'File',strcat(folder,'Adot_SSupp_func'),'Vars',{x},'Comments',comment)
    matlabFunction(Adotswap,        'File',strcat(folder,'Adot_Swap_func'),'Vars',{x},'Comments',comment)
    matlabFunction(sym(Adotklocksw),'File',strcat(folder,'Adot_KLockSw_func'),'Vars',{x},'Comments',comment)
    matlabFunction(sym(Adotklockst),'File',strcat(folder,'Adot_KLockSt_func'),'Vars',{x},'Comments',comment)
    matlabFunction(sym(Adotvhc),'File',strcat(folder,'Adot_VHC_func'),'Vars',{x},'Comments',comment)

    Kinetic_energy
    Potential_energy
    %Spring_energy

    folder = strcat(configFolder,'\SimulationFunctions\EnergyFunctions\');
    status = mkdir(folder);
    matlabFunction(Ke,'File',strcat(folder,'KE_func'),'Vars',{x},'Comments',comment)
    matlabFunction(Pe,'File',strcat(folder,'PE_func'),'Vars',{x},'Comments',comment)
    %matlabFunction(pespring,'File','SimulationFunctions\EnergyFunctions\SpringE_func','Vars',{x,k,L0})
    
    Foot_st_pos
    Knee_st_pos
    Hip_pos
    Knee_sw_pos
    Foot_sw_pos
    COM_pos
    
    folder = strcat(configFolder,'\SimulationFunctions\KinematicFunctions\');
    status = mkdir(folder);
    matlabFunction(posFst,  'File',strcat(folder,'Foot_St_pos_func'),'Vars',{x},'Comments',comment)
    matlabFunction(posKst,  'File',strcat(folder,'Knee_St_pos_func'),'Vars',{x},'Comments',comment)
    matlabFunction(posH,    'File',strcat(folder,'Hip_pos_func'),'Vars',{x},'Comments',comment)
    matlabFunction(posFsw,  'File',strcat(folder,'Foot_Sw_pos_func'),'Vars',{x},'Comments',comment)
    matlabFunction(posKsw,  'File',strcat(folder,'Knee_Sw_pos_func'),'Vars',{x},'Comments',comment)
    matlabFunction(posCoM,  'File',strcat(folder,'COM_pos_func'),'Vars',{x},'Comments',comment)
    
    Foot_st_vel
    Knee_st_vel
    Hip_vel
    Knee_sw_vel
    Foot_sw_vel

    matlabFunction(velFst,  'File',strcat(folder,'Foot_St_vel_func'),'Vars',{x},'Comments',comment)
    matlabFunction(velKst,  'File',strcat(folder,'Knee_St_vel_func'),'Vars',{x},'Comments',comment)
    matlabFunction(velH,    'File',strcat(folder,'Hip_vel_func'),'Vars',{x},'Comments',comment)
    matlabFunction(velFsw,  'File',strcat(folder,'Foot_Sw_vel_func'),'Vars',{x},'Comments',comment)
    matlabFunction(velKsw,  'File',strcat(folder,'Knee_Sw_vel_func'),'Vars',{x},'Comments',comment)

    Foot_st_Jacobian
    Knee_st_Jacobian
    Hip_Jacobian
    Knee_sw_Jacobian
    Foot_sw_Jacobian

    matlabFunction(sym(js0),  'File',strcat(folder,'Foot_St_Jacobian_func'),'Vars',{x},'Comments',comment)
    matlabFunction(sym(js1),  'File',strcat(folder,'Knee_St_Jacobian_func'),'Vars',{x},'Comments',comment)
    matlabFunction(sym(js2),    'File',strcat(folder,'Hip_Jacobian_func'),'Vars',{x},'Comments',comment)
    matlabFunction(sym(js3),  'File',strcat(folder,'Knee_Sw_Jacobian_func'),'Vars',{x},'Comments',comment)
    matlabFunction(sym(js4),  'File',strcat(folder,'Foot_Sw_Jacobian_func'),'Vars',{x},'Comments',comment)
    
    %Copy over custom functions unique to a configuration
    %copyfile(strcat(thisdir,'\CustomFunctions'), strcat(configFolder,'\SimulationFunctions'))
    
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
