function u = DSLIP(q,qdot,copf1,copf2)
%DSLIP Summary of this function goes here
%   Detailed eqplanation goes here
    global contact 
    global L0 k_dslip
    global l1 l2 la
    global kp kd setpos
    k = k_dslip;
    if ~strcmp(contact, "DSupp")      
        copf = copf1;   
        tau = SLIP_Torque(q,copf);
    else              
        %relabeling
        R = [zeros(1,8);
             zeros(1,8);
             0,0,1,1,1,1,1,1;
             0,0,0,0,0,0,0,-1;
             0,0,0,0,0,0,-1,0;
             0,0,0,0,0,-1,0,0;
             0,0,0,0,-1,0,0,0;
             0,0,0,-1,0,0,0,0];
        q = R*q;
        tau = zeros(8,1);
    end
    u = -tau; %Because tau was derived from a potential, and using the Euler-Lagrange equation, -p(L)/p(q) = u
end
function tau = SLIP_Torque(q,copf)
    global L0 k_dslip
    global l1 l2 la

    k = k_dslip;
    tau = [0;0;0;k.*(copf.*l1.*cos(q(4))+copf.*l2.*cos(q(4)+q(5))+(-1).*la.*(l1.*sin(q(4))+l2.*sin(q(4)+q(5)))).*(copf.^2+l1.^2+l2.^2+la.^2+2.*(l1.*la.*cos(q(4))+l1.*l2.*cos(q(5))+l2.*la.*cos(q(4)+q(5))+copf.*l1.*sin(q(4))+copf.*l2.*sin(q(4)+q(5)))).^(-1/2).*((-1).*L0+(copf.^2+l1.^2+l2.^2+la.^2+2.*(l1.*la.*cos(q(4))+l1.*l2.*cos(q(5))+l2.*la.*cos(q(4)+q(5))+copf.*l1.*sin(q(4))+copf.*l2.*sin(q(4)+q(5)))).^(1/2));k.*l2.*(copf.*cos(q(4)+q(5))+(-1).*l1.*sin(q(5))+(-1).*la.*sin(q(4)+q(5))).*(copf.^2+l1.^2+l2.^2+la.^2+2.*(l1.*la.*cos(q(4))+l1.*l2.*cos(q(5))+l2.*la.*cos(q(4)+q(5))+copf.*l1.*sin(q(4))+copf.*l2.*sin(q(4)+q(5)))).^(-1/2).*((-1).*L0+(copf.^2+l1.^2+l2.^2+la.^2+2.*(l1.*la.*cos(q(4))+l1.*l2.*cos(q(5))+l2.*la.*cos(q(4)+q(5))+copf.*l1.*sin(q(4))+copf.*l2.*sin(q(4)+q(5)))).^(1/2));0;0;0];
end
function L = SpringLength(q,copf)
    global contact 
    global L0 k_dslip
    global l1 l2 la
    global kp kd setpos
    k = k_dslip;
    L = [((la.*cos(q(3))+l1.*cos(q(3)+q(4))+l2.*cos(q(3)+q(4)+q(5))+(-1).*copf.*sin(q(3))).^2+(copf.*cos(q(3))+(-1).*la.*sin(q(3))+(-1).*l1.*sin(q(3)+q(4))+(-1).*l2.*sin(q(3)+q(4)+q(5))).^2).^(1/2);0];
end
function V = SpringPotential(q,copf)
    
end