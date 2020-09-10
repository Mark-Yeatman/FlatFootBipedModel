function makeMatlabFunctionsSLIP()
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
    comment = "SLIP Configuration file. Only needs state as inputs, parameters are already substituted in";
    
    %Make readme for the model and config. 
%     fid = fopen(strcat(configFolder,'\SimulationFunctions\info.txt'), 'wt' );
%     fprintf( fid,'Current Configuration: CompassGait\nThis configuration is supposed to act like the compass gait model, by locking the knees on the 4 link biped. The mass parameters come from Spongs 2007 Passivity Based Control of Biped Walking. The mass parameters are baked into the simulation functions by makeMatlabFunctionsCompass.m ');
%     fclose(fid);
    
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

    x = sym('x',[12,1]);
    
    Spring_Length_1
    Spring_Length_2
    Spring_Jacobian_1
    Spring_Jacobian_2
    Spring_Velocity_1
    Spring_Velocity_2
    
    folder = strcat(configFolder,'\SimulationFunctions\KinematicFunctions\');
    status = mkdir(folder);
    matlabFunction(l1,  'File',strcat(folder,'Spring_Length_1_func'),'Vars',{x},'Comments',comment)
    matlabFunction(l2,  'File',strcat(folder,'Spring_Length_2_func'),'Vars',{x},'Comments',comment)
    matlabFunction(ljacob1,  'File',strcat(folder,'Spring_Jacobian_1_func'),'Vars',{x},'Comments',comment)
    matlabFunction(ljacob2,  'File',strcat(folder,'Spring_Jacobian_2_func'),'Vars',{x},'Comments',comment)  
    matlabFunction(l1dot,  'File',strcat(folder,'Spring_Velocity_1_func'),'Vars',{x},'Comments',comment)
    matlabFunction(l2dot,  'File',strcat(folder,'Spring_Velocity_2_func'),'Vars',{x},'Comments',comment)  
    
end
