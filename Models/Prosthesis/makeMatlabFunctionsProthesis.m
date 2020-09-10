function makeMatlabFunctionsProthesis()
% Turns the mathematica derivation of the robot dynamics into optimized executable matlab functions. 

    %Where to put the matlab functions
    mylocation = which(mfilename);
    [thisdir,~,~] = fileparts(mylocation);
    idcs   = strfind(thisdir,'\');
    configFolder = thisdir(1:idcs(end)-1);

    %Where to get the "mathematica" functions
    SymFuncsPath = strcat(pwd,"\Derivations\ToMatlabOutputs\Prosthesis");
    addpath(genpath(SymFuncsPath))

    SymFuncsPath = strcat(pwd,"\Derivations\ToMatlabOutputs\ProsthesisHeelFrame");
    addpath(genpath(SymFuncsPath))
    
    SymFuncsPath = strcat(pwd,"\Derivations\ToMatlabOutputs\ProsthesisHipFrame");
    addpath(genpath(SymFuncsPath))
    
    %What to comment
    comment = "Prosthesis file. Needs state and parameters as inputs";
     
    %Parameters as symbolic array
    lt = 0; %to get past lf() being a matlab function
    ls = 0; %ditto
    Parameters = cell2sym({'Mh', 'Mt', 'Ms', 'Mf', 'Ihz', 'Itz', 'Isz', 'lt', 'ls', 'la', 'lf'});
    g = 9.81;
    syms(Parameters);

    %Make the matlabfunctions
    dim = 10;

    %States as symbolic array
    x = sym('x',[dim,1]);
    y = sym('y',[3,1]);
    a = sym('a',[dim/2,1]);

    M_matrix
    C_matrix
    G_matrix
    %DSLIP_matrix1
    %DSLIP_matrix2
    COM_accel
    folder = strcat(configFolder,'\SimulationFunctions\DynamicsFunctions\');
    status = mkdir(folder);
    matlabFunction(M,   'File',strcat(folder,'M_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(Cmat,'File',strcat(folder,'C_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(G,   'File',strcat(folder,'G_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(ddCoM,'File',strcat(folder,'COM_accel_func'),'Vars',{x,a,Parameters })
    
    Kinetic_energy
    Potential_energy

    folder = strcat(configFolder,'\SimulationFunctions\EnergyFunctions\');
    status = mkdir(folder);
    matlabFunction(Ke,'File',strcat(folder,'KE_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(Pe,'File',strcat(folder,'PE_func'),'Vars',{x,Parameters },'Comments',comment)
    
    Toe_st_pos
    Ankle_st_pos
    Knee_st_pos
    Hip_pos
    COM_pos
    SpringLengthFlatHeel
    SpringLengthFlatHip
    
    folder = strcat(configFolder,'\SimulationFunctions\KinematicFunctions\');
    status = mkdir(folder);
    matlabFunction(posToest,  'File',strcat(folder,'Toe_St_pos_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(posAst,  'File',strcat(folder,'Ankle_St_pos_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(posKst,  'File',strcat(folder,'Knee_St_pos_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(posH,  'File',strcat(folder,'Hip_pos_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(posCoM,  'File',strcat(folder,'COM_pos_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(LFlatHeel,  'File',strcat(folder,'Spring_Length_Heel_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(LFlatHip,  'File',strcat(folder,'Spring_Length_Hip_func'),'Vars',{y,Parameters },'Comments',comment)
    
    Toe_st_vel
    Ankle_st_vel
    Knee_st_vel
    Hip_vel

    matlabFunction(velToest,  'File',strcat(folder,'Toe_St_vel_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(velAst,  'File',strcat(folder,'Ankle_St_vel_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(velKst,  'File',strcat(folder,'Knee_St_vel_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(velH,    'File',strcat(folder,'Hip_vel_func'),'Vars',{x,Parameters },'Comments',comment)

    Toe_st_Jacobian
    Ankle_st_Jacobian
    Knee_st_Jacobian
    Hip_Jacobian
    SpringJacobianFlatHeel
    SpringJacobianFlatHip
    
    matlabFunction(js0,  'File',strcat(folder,'Toe_St_Jacobian_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(js1,  'File',strcat(folder,'Ankle_St_Jacobian_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(js2,  'File',strcat(folder,'Knee_St_Jacobian_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(js3,    'File',strcat(folder,'Hip_Jacobian_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(LJacobFlatHeel,    'File',strcat(folder,'Spring_Jacobian_Heel_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(LJacobFlatHip,    'File',strcat(folder,'Spring_Jacobian_Hip_func'),'Vars',{y,Parameters },'Comments',comment)   
    
    AHip_matrix
    AdotHip_matrix
    
    folder = strcat(configFolder,'\SimulationFunctions\ConstraintFunctions\');
    status = mkdir(folder);
    matlabFunction(Ahip,  'File',strcat(folder,'A_Hip_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(Adothip,  'File',strcat(folder,'Adot_Hip_func'),'Vars',{x,Parameters },'Comments',comment)
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
