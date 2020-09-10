function make4LinkPointFootFunctions()
% Turns the mathematica derivation of the robot dynamics into optimized executable matlab functions. 

    %Where to put the matlab functions
    mylocation = which(mfilename);
    [thisdir,~,~] = fileparts(mylocation);
    idcs   = strfind(thisdir,'\');
    configFolder = thisdir;%(1:idcs(end)-1);

    %Where to get the "mathematica" functions
    %SymFuncsPath = "Z:\Member Folders\Mark Yeatman\Codes\Matlab\StandardizedSimCode\Derivations\ToMatlabOutputs\4LinkPointFoot";
    SymFuncsPath = strcat(pwd,"\Derivations\ToMatlabOutputs\4LinkPointFoot");
    addpath(genpath(SymFuncsPath))

    %What to comment
    comment = "";
    
    %Which physical parameters to use
    lt = 0;
    ls = 0;
    syms k L0 Mh Mt Ms Itz Isz lt ls rt rs g 
    params_keys = {'Mh', 'Mt', 'Ms', 'Itz', 'Isz', 'lt', 'ls', 'rt', 'rs', 'g'};
    params_values = {Mh, Mt, Ms, Itz, Isz, lt, ls, rt, rs, g};
    temp = containers.Map(params_keys,params_values);
    temp = temp.values();
    
    params = [temp{:}]; %gets the ordering right   
    x = sym('x',[12,1]);
    a = sym('a',[6,1]);
    
    M_matrix
    C_matrix
    G_matrix
    COM_accel
    
    folder = strcat(configFolder,'\SimulationFunctions\DynamicsFunctions\');
    status = mkdir(folder);
    matlabFunction(M,   'File',strcat(folder,'M_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(Cmat,'File',strcat(folder,'C_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(G,   'File',strcat(folder,'G_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(ddCoM,'File',strcat(folder,'COM_accel_func'),'Vars',{x,a,params})

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
    matlabFunction(Adsupp,          'File',strcat(folder,'A_DSupp_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(sym(Assupp),     'File',strcat(folder,'A_SSupp_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(Aswap,           'File',strcat(folder,'A_Swap_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(sym(Aklocksw),   'File',strcat(folder,'A_KLockSw_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(sym(Aklockst),   'File',strcat(folder,'A_KLockSt_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(sym(Avhc),   'File',strcat(folder,'A_VHC_func'),'Vars',{x,params},'Comments',comment)

    matlabFunction(Adotdsupp,       'File',strcat(folder,'Adot_DSupp_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(sym(Adotssupp),  'File',strcat(folder,'Adot_SSupp_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(Adotswap,        'File',strcat(folder,'Adot_Swap_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(sym(Adotklocksw),'File',strcat(folder,'Adot_KLockSw_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(sym(Adotklockst),'File',strcat(folder,'Adot_KLockSt_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(sym(Adotvhc),'File',strcat(folder,'Adot_VHC_func'),'Vars',{x,params},'Comments',comment)

    Kinetic_energy
    Potential_energy

    folder = strcat(configFolder,'\SimulationFunctions\EnergyFunctions\');
    status = mkdir(folder);
    matlabFunction(Ke,'File',strcat(folder,'KE_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(Pe,'File',strcat(folder,'PE_func'),'Vars',{x,params},'Comments',comment)
    
    Foot_st_pos
    Knee_st_pos
    Hip_pos
    Knee_sw_pos
    Foot_sw_pos
    COM_pos
    
    folder = strcat(configFolder,'\SimulationFunctions\KinematicFunctions\');
    status = mkdir(folder);
    matlabFunction(posFst,  'File',strcat(folder,'Foot_St_pos_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(posKst,  'File',strcat(folder,'Knee_St_pos_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(posH,    'File',strcat(folder,'Hip_pos_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(posFsw,  'File',strcat(folder,'Foot_Sw_pos_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(posKsw,  'File',strcat(folder,'Knee_Sw_pos_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(posCoM,  'File',strcat(folder,'COM_pos_func'),'Vars',{x,params},'Comments',comment)
    
    Foot_st_vel
    Knee_st_vel
    Hip_vel
    Knee_sw_vel
    Foot_sw_vel

    matlabFunction(velFst,  'File',strcat(folder,'Foot_St_vel_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(velKst,  'File',strcat(folder,'Knee_St_vel_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(velH,    'File',strcat(folder,'Hip_vel_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(velFsw,  'File',strcat(folder,'Foot_Sw_vel_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(velKsw,  'File',strcat(folder,'Knee_Sw_vel_func'),'Vars',{x,params},'Comments',comment)

    Foot_st_Jacobian
    Knee_st_Jacobian
    Hip_Jacobian
    Knee_sw_Jacobian
    Foot_sw_Jacobian

    matlabFunction(sym(js0),  'File',strcat(folder,'Foot_St_Jacobian_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(sym(js1),  'File',strcat(folder,'Knee_St_Jacobian_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(sym(js2),    'File',strcat(folder,'Hip_Jacobian_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(sym(js3),  'File',strcat(folder,'Knee_Sw_Jacobian_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(sym(js4),  'File',strcat(folder,'Foot_Sw_Jacobian_func'),'Vars',{x,params},'Comments',comment)
    
    Spring_Length_1
    Spring_Length_2
    Spring_Jacobian_1
    Spring_Jacobian_2
    Spring_Velocity_1
    Spring_Velocity_2
    
    params_keys = {'lt', 'ls', 'rt', 'rs', 'k', 'L0'};
    params_values = {lt, ls, rt, rs, k, L0};
    temp = containers.Map(params_keys,params_values);
    temp = temp.values();
    params = [temp{:}]; %gets the ordering right   
    
    folder = strcat(configFolder,'\SimulationFunctions\KinematicFunctions\');
    status = mkdir(folder);
    matlabFunction(l1,  'File',strcat(folder,'Spring_Length_1_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(l2,  'File',strcat(folder,'Spring_Length_2_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(ljacob1,  'File',strcat(folder,'Spring_Jacobian_1_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(ljacob2,  'File',strcat(folder,'Spring_Jacobian_2_func'),'Vars',{x,params},'Comments',comment)  
    matlabFunction(l1dot,  'File',strcat(folder,'Spring_Velocity_1_func'),'Vars',{x,params},'Comments',comment)
    matlabFunction(l2dot,  'File',strcat(folder,'Spring_Velocity_2_func'),'Vars',{x,params},'Comments',comment)  
    
end
