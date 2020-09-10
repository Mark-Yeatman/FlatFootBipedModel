function make2LinkCompassGaitFunctions()
% Turns the mathematica derivation of the robot dynamics into optimized executable matlab functions. 

    %Where to put the matlab functions
    mylocation = which(mfilename);
    [thisdir,~,~] = fileparts(mylocation);
    idcs   = strfind(thisdir,'\');
    configFolder = thisdir;%(1:idcs(end)-1);

    %Where to get the "mathematica" functions
    SymFuncsPath = (strcat(pwd,'\Derivations\ToMatlabOutputs\2LinkCompassGait'));
    addpath(genpath(SymFuncsPath))

    %What to comment

    %Make readme for the model and config. 
    fid = fopen(strcat(configFolder,'\SimulationFunctions\info.txt'), 'wt' );
    fprintf( fid,'Current Configuration: CompassGait\nThis configuration is supposed to act like the compass gait model, by locking the knees on the 4 link biped. The mass parameters come from Spongs 2007 Passivity Based Control of Biped Walking. The mass parameters are baked into the simulation functions by makeMatlabFunctionsCompass.m ');
    fclose(fid);

    syms Mh Ms Isx Isy Isz a b g
    params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
    params_values = {Mh, Ms, Isz, a, b, g};
    temp = containers.Map(params_keys,params_values);
    temp = temp.values();
    
    params = [temp{:}]; %gets the ordering right   
    x = sym('x',[8,1]);   
    ac = sym('ac',[4,1]);

    M_matrix
    C_matrix
    G_matrix
    COM_accel
    
    folder = strcat(configFolder,'\SimulationFunctions\DynamicsFunctions\');
    status = mkdir(folder);
    matlabFunction(M,   'File',strcat(folder,'M_func'),'Vars',{x,params})
    matlabFunction(Cmat,'File',strcat(folder,'C_func'),'Vars',{x,params})
    matlabFunction(G,   'File',strcat(folder,'G_func'),'Vars',{x,params})
    matlabFunction(ddCoM,'File',strcat(folder,'COM_accel_func'),'Vars',{x,ac,params})

    ASSupp_matrix
    ASwap_matrix
    AVHC_matrix
    AdotSSupp_matrix
    AdotSwap_matrix
    AdotVHC_matrix
    VHC
    
    folder = strcat(configFolder,'\SimulationFunctions\ConstraintFunctions\');
    status = mkdir(folder);
    matlabFunction(sym(Assupp),     'File',strcat(folder,'A_SSupp_func'),'Vars',{x,params})
    matlabFunction(Aswap,           'File',strcat(folder,'A_Swap_func'),'Vars',{x,params})
    matlabFunction(sym(Avhc),   'File',strcat(folder,'A_VHC_func'),'Vars',{x,params})

    matlabFunction(sym(Adotssupp),  'File',strcat(folder,'Adot_SSupp_func'),'Vars',{x,params})
    matlabFunction(Adotswap,        'File',strcat(folder,'Adot_Swap_func'),'Vars',{x,params})
    matlabFunction(sym(Adotvhc),'File',strcat(folder,'Adot_VHC_func'),'Vars',{x,params})

    matlabFunction(sym(vhc),   'File',strcat(folder,'VHC_func'),'Vars',{x,params})
    
    Kinetic_energy
    Potential_energy

    folder = strcat(configFolder,'\SimulationFunctions\EnergyFunctions\');
    status = mkdir(folder);
    matlabFunction(Ke,'File',strcat(folder,'KE_func'),'Vars',{x,params})
    matlabFunction(Pe,'File',strcat(folder,'PE_func'),'Vars',{x,params})
    
    Foot_st_pos
    Hip_pos
    Foot_sw_pos
    COM_pos
    
    folder = strcat(configFolder,'\SimulationFunctions\KinematicFunctions\');
    status = mkdir(folder);
    matlabFunction(posFst,  'File',strcat(folder,'Foot_St_pos_func'),'Vars',{x,params})
    matlabFunction(posH,    'File',strcat(folder,'Hip_pos_func'),'Vars',{x,params})
    matlabFunction(posFsw,  'File',strcat(folder,'Foot_Sw_pos_func'),'Vars',{x,params})
    matlabFunction(posCoM,  'File',strcat(folder,'COM_pos_func'),'Vars',{x,params})
    
    Foot_st_vel
    Hip_vel
    Foot_sw_vel
    COM_vel
    
    matlabFunction(velFst,  'File',strcat(folder,'Foot_St_vel_func'),'Vars',{x,params})
    matlabFunction(velH,    'File',strcat(folder,'Hip_vel_func'),'Vars',{x,params})
    matlabFunction(velFsw,  'File',strcat(folder,'Foot_Sw_vel_func'),'Vars',{x,params})
    matlabFunction(dCoM,'File',strcat(folder,'COM_vel_func'),'Vars',{x,params})

%     Foot_st_Jacobian
%     Hip_Jacobian
%     Foot_sw_Jacobian
% 
%     matlabFunction(sym(js0),  'File',strcat(folder,'Foot_St_Jacobian_func'),'Vars',{x,params})
%     matlabFunction(sym(js2),    'File',strcat(folder,'Hip_Jacobian_func'),'Vars',{x,params})
%     matlabFunction(sym(js4),  'File',strcat(folder,'Foot_Sw_Jacobian_func'),'Vars',{x,params})
%     
end
