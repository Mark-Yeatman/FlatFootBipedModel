function makeMatlabFunctionsProthesisTestBench()
% Turns the mathematica derivation of the robot dynamics into optimized executable matlab functions. 

    %Where to put the matlab functions
    mylocation = which(mfilename);
    [thisdir,~,~] = fileparts(mylocation);
    idcs   = strfind(thisdir,'\');
    configFolder = strcat(thisdir(1:idcs(end)-1),'\TestBench');

    %Where to get the "mathematica" functions
    SymFuncsPath = strcat(pwd,"\Derivations\ToMatlabOutputs\ProsthesisTestBench");
    addpath(genpath(SymFuncsPath))
    
    %What to comment
    comment = "Prosthesis file. Needs state and parameters as inputs";
     
    %Parameters as symbolic array
    lt = 0; %to get past lf() being a matlab function
    lf = 0;
    ls = 0; %ditto
    py = 0;
    Parameters = cell2sym({'Mt','Ms', 'Mf', 'lt', 'ls', 'la', 'lf', 'px',' py'});
    g = 9.81;
    syms(Parameters);

    %Make the matlabfunctions
    dim = 10;

    %States as symbolic array
    x = sym('x',[dim,1]);
    a = sym('a',[dim/2,1]);
    xshift = sym('xshift');
    
    M_matrix
    C_matrix
    G_matrix
    G_Shape_Law_matrix
    COM_accel
    folder = strcat(configFolder,'\SimulationFunctions\DynamicsFunctions\');
    status = mkdir(folder);
    matlabFunction(M,   'File',strcat(folder,'M_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(Cmat,'File',strcat(folder,'C_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(G,   'File',strcat(folder,'G_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(GShape,   'File',strcat(folder,'G_Shape_Law_func'),'Vars',{x,Parameters,xshift},'Comments',comment)
    matlabFunction(ddCoM,'File',strcat(folder,'COM_accel_func'),'Vars',{x,a,Parameters })
    
    Kinetic_energy
    Potential_energy

    folder = strcat(configFolder,'\SimulationFunctions\EnergyFunctions\');
    status = mkdir(folder);
    matlabFunction(Ke,'File',strcat(folder,'KE_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(Pe,'File',strcat(folder,'PE_func'),'Vars',{x,Parameters },'Comments',comment)
    
    Toe_pos
    Ankle_pos
    Knee_pos
    Heel_pos
    COM_pos
    SpringLength
    
    folder = strcat(configFolder,'\SimulationFunctions\KinematicFunctions\');
    status = mkdir(folder);
    matlabFunction(posToe,  'File',strcat(folder,'Toe_pos_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(posAnkle,  'File',strcat(folder,'Ankle_pos_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(posKnee,  'File',strcat(folder,'Knee_pos_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(posHeel,  'File',strcat(folder,'Heel_pos_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(posCoM,  'File',strcat(folder,'COM_pos_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(l1,  'File',strcat(folder,'Spring_Length_func'),'Vars',{x,Parameters },'Comments',comment)
    
    Toe_vel
    Ankle_vel
    Knee_vel
    Heel_vel
    SpringVelocity
    
    matlabFunction(velToe,  'File',strcat(folder,'Toe_vel_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(velAnkle, 'File',strcat(folder,'Ankle_vel_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(velKnee,  'File',strcat(folder,'Knee_vel_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(velHeel,  'File',strcat(folder,'Heel_vel_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(l1dot,   'File',strcat(folder,'Spring_vel_func'),'Vars',{x,Parameters },'Comments',comment)
    
    Ankle_Jacobian
    Knee_Jacobian
    SpringJacobian
    
    matlabFunction(js1,  'File',strcat(folder,'Ankle_Jacobian_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(js0,  'File',strcat(folder,'Knee_Jacobian_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(lJacob,    'File',strcat(folder,'Spring_Jacobian_func'),'Vars',{x,Parameters },'Comments',comment)
    
    AHip_matrix
    AdotHip_matrix
    
    folder = strcat(configFolder,'\SimulationFunctions\ConstraintFunctions\');
    status = mkdir(folder);
    matlabFunction(sym(Ahip),  'File',strcat(folder,'A_Mounted_func'),'Vars',{x,Parameters },'Comments',comment)
    matlabFunction(sym(Adothip),  'File',strcat(folder,'Adot_Mounted_func'),'Vars',{x,Parameters },'Comments',comment)
end
