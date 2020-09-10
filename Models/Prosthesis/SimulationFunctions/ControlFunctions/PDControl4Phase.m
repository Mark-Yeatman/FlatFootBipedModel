function u = PDControl4Phase(x)
global flowdata     

    kp = flowdata.Parameters.PD.kp; 
    kd = flowdata.Parameters.PD.kd;
    setpos = flowdata.Parameters.PD.setpos;
    contact = flowdata.State.c_phase;
    dim = flowdata.Parameters.dim;

    q = x(1:dim/2);         %position
    qdot = x(dim/2+1:dim);  %velocity

    if strcmp(contact,"DSupp")
        Kd = diag(kd);
        Kp = diag(kp);    
        derp = setpos*0;
        derp(5) = -setpos(5) + -0.2;
        u = -Kp*(q-setpos-derp) - Kd*qdot;   
    else 
        Kd = diag(kd);
        Kp = diag(kp);    
        u = -Kp*(q-setpos) - Kd*qdot;     
    end
    
end
