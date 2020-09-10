function [COP_ff,COP_gf] = COP_func(x)
%COP_FUNC Calculates center of pressure of the biped. 
%   See paper Forces Acting on a Biped Robot. Center of Pressure—Zero
%   Moment Point, equations (8),(9),(20)
    global flowdata
    g = flowdata.Parameters.Environment.g;
    dim = flowdata.Parameters.dim;
    R_gf = flowdata.getRgf();
    
    %use data to get equation inputs
    xdot_joints = dynamics(0,x);
    tau = dynamics(0,x,'H');
    params = cell2mat(flowdata.Parameters.Biped.values);
    a_COM = COM_accel_func(x,xdot_joints(dim/2:end),params);
    p_COM = COM_pos_func(x,params);
    stf_pose = Foot_St_pos_func(x,params);
    QG_vec = p_COM - stf_pose(1:3,4)';
    Hdot = tau(3);
    
    %equations from paper
    MTotal = flowdata.Parameters.Biped('Mh') + 2*flowdata.Parameters.Biped('Mt') + 2*flowdata.Parameters.Biped('Ms');
    R_gi = MTotal*[0,-g,0] - MTotal*a_COM;
    M_gi = cross(QG_vec,MTotal*[0,-g,0]) - [0,0,Hdot];
    n = [eye(3),zeros(3,1)]*inv(R_gf)*[0;1;0;0];
    COP_gf = (cross(n,M_gi)/dot(R_gi,n))';
    COP_ff = R_gf(1:3,1:3)*COP_gf;
end

