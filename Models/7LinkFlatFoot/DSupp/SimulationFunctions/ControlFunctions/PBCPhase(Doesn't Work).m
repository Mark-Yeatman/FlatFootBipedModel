function u = PBCPhase(q,qdot,Esys)
global kd gainratios 
    satU = inf;
    alpha = 0.05;
    mod = eye(size(gainratios));
    %mod(4,4) = -(q(6)-0.5);
    %mod(5,5) = -(-q(6)+0.5);
    grmod = gainratios*mod;
    Eref = ErefPhase(q,qdot);
    u = -kd*grmod*(Esys - Eref)*qdot;
    %v = -kd*gainratios*(Esys - Eref*( 1 - alpha*sin(q(4)) ))*qdot;
    %u = v + [0,0,0,1,0,0,0,0]'*Eref*alpha*cos(q(4));
    u(abs(u)>satU) = sign(u(abs(u)>satU)) * satU; 
end