function u = SetPoint_PD_Control(t,x)
global flowdata     

    kp = flowdata.Parameters.PD.kp; 
    kd = flowdata.Parameters.PD.kd;
    setpos = flowdata.Parameters.PD.setpos;
    contact = flowdata.State.c_phase;
    dim = flowdata.Parameters.dim;

    q = x(1:dim/2);         %position
    qdot = x(dim/2+1:dim);  %velocity

    Kd = diag(kd);
    Kp = diag(kp);    
    u = -Kp*(q-setpos) - Kd*qdot;     
end
