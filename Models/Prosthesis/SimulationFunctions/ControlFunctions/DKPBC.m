function u = DKPBC(x)
global flowdata
    k = flowdata.Parameters.KPBC.k;
    omega = flowdata.Parameters.KPBC.omega;
    satU = flowdata.Parameters.KPBC.sat;
    
    W = x(dim+1);
    GenE = flowdata.State.Einit - W;
    phase = flowdata.State.c_phase;
    Eref = flowdata.Parameters.KPBC.Eref.(phase);

    u = -k*omega*(GenE - Eref)*qdot;
    u(abs(u)>satU) = sign(u(abs(u)>satU)) * satU; 
    
    %Biomemetic torque saturation
%     if u(3)*qdot(3) < 0
%         u(3) = 0;
%     end
%     if u(4)*qdot(4) > 0
%         u(4) = 0;
%     end
    
end