function E = Energy_Sub(x)
%ENERGY_PROS Summary of this function goes here
%   Detailed explanation goes here
global flowdata
Mh = flowdata.Parameters.Biped.Mh;
Mf = flowdata.Parameters.Biped.Mf;
Mt = flowdata.Parameters.Biped.Mt;
Ms = flowdata.Parameters.Biped.Ms;
Itx = flowdata.Parameters.Biped.Itx;
Isx = flowdata.Parameters.Biped.Isx;
lt = flowdata.Parameters.Biped.lt;
ls = flowdata.Parameters.Biped.ls;
la = flowdata.Parameters.Biped.la;
lf = flowdata.Parameters.Biped.lf;
g = flowdata.Parameters.Environment.g;
if ~any(size(x)==1)
    qdot = x(:,9:13);
    temp = size(x);
    index = temp(1);
    KE = zeros(index,1);
    PE = zeros(index,1);
    [a,~] = size(qdot);
    for i=1:a
        M = [Mt+Ms+Mf+Mh,0,-(Ms*ls*cos(x(i,3)+x(i,4)+x(i,5)))/2-Mh*ls*cos(x(i,3)+x(i,4)+x(i,5))-(Mt*lt*cos(x(i,3)+x(i,4)))/2-Ms*lt*cos(x(i,3)+x(i,4))-Mh*lt*cos(x(i,3)+x(i,4))-Mt*la*cos(x(i,3))-Ms*la*cos(x(i,3))-(Mf*la*cos(x(i,3)))/2-Mh*la*cos(x(i,3)),-(Ms*ls*cos(x(i,3)+x(i,4)+x(i,5)))/2-Mh*ls*cos(x(i,3)+x(i,4)+x(i,5))-(Mt*lt*cos(x(i,3)+x(i,4)))/2-Ms*lt*cos(x(i,3)+x(i,4))-Mh*lt*cos(x(i,3)+x(i,4)),-(ls*cos(x(i,3)+x(i,4)+x(i,5))*(Ms+2*Mh))/2;
                0,Mt+Ms+Mf+Mh,-(Ms*ls*sin(x(i,3)+x(i,4)+x(i,5)))/2-Mh*ls*sin(x(i,3)+x(i,4)+x(i,5))-(Mt*lt*sin(x(i,3)+x(i,4)))/2-Ms*lt*sin(x(i,3)+x(i,4))-Mh*lt*sin(x(i,3)+x(i,4))-Mt*la*sin(x(i,3))-Ms*la*sin(x(i,3))-(Mf*la*sin(x(i,3)))/2-Mh*la*sin(x(i,3)),-(Ms*ls*sin(x(i,3)+x(i,4)+x(i,5)))/2-Mh*ls*sin(x(i,3)+x(i,4)+x(i,5))-(Mt*lt*sin(x(i,3)+x(i,4)))/2-Ms*lt*sin(x(i,3)+x(i,4))-Mh*lt*sin(x(i,3)+x(i,4)),-(ls*sin(x(i,3)+x(i,4)+x(i,5))*(Ms+2*Mh))/2;
                -(Ms*ls*cos(x(i,3)+x(i,4)+x(i,5)))/2-Mh*ls*cos(x(i,3)+x(i,4)+x(i,5))-(Mt*lt*cos(x(i,3)+x(i,4)))/2-Ms*lt*cos(x(i,3)+x(i,4))-Mh*lt*cos(x(i,3)+x(i,4))-Mt*la*cos(x(i,3))-Ms*la*cos(x(i,3))-(Mf*la*cos(x(i,3)))/2-Mh*la*cos(x(i,3)),-(Ms*ls*sin(x(i,3)+x(i,4)+x(i,5)))/2-Mh*ls*sin(x(i,3)+x(i,4)+x(i,5))-(Mt*lt*sin(x(i,3)+x(i,4)))/2-Ms*lt*sin(x(i,3)+x(i,4))-Mh*lt*sin(x(i,3)+x(i,4))-Mt*la*sin(x(i,3))-Ms*la*sin(x(i,3))-(Mf*la*sin(x(i,3)))/2-Mh*la*sin(x(i,3)),Itx+Isx+Mt*la^2+Ms*la^2+(Mt*lt^2)/4+Ms*lt^2+(Ms*ls^2)/4+(Mf*la^2)/4+Mh*la^2+Mh*lt^2+Mh*ls^2+Ms*la*ls*cos(x(i,4)+x(i,5))+2*Mh*la*ls*cos(x(i,4)+x(i,5))+Mt*la*lt*cos(x(i,4))+2*Ms*la*lt*cos(x(i,4))+Ms*lt*ls*cos(x(i,5))+2*Mh*la*lt*cos(x(i,4))+2*Mh*lt*ls*cos(x(i,5)),Itx+Isx+(Mt*lt^2)/4+Ms*lt^2+(Ms*ls^2)/4+Mh*lt^2+Mh*ls^2+(Ms*la*ls*cos(x(i,4)+x(i,5)))/2+Mh*la*ls*cos(x(i,4)+x(i,5))+(Mt*la*lt*cos(x(i,4)))/2+Ms*la*lt*cos(x(i,4))+Ms*lt*ls*cos(x(i,5))+Mh*la*lt*cos(x(i,4))+2*Mh*lt*ls*cos(x(i,5)),Isx+(Ms*ls*(ls/2+la*cos(x(i,4)+x(i,5))+lt*cos(x(i,5))))/2+Mh*ls*(ls+la*cos(x(i,4)+x(i,5))+lt*cos(x(i,5)));
                -(Ms*ls*cos(x(i,3)+x(i,4)+x(i,5)))/2-Mh*ls*cos(x(i,3)+x(i,4)+x(i,5))-(Mt*lt*cos(x(i,3)+x(i,4)))/2-Ms*lt*cos(x(i,3)+x(i,4))-Mh*lt*cos(x(i,3)+x(i,4)),-(Ms*ls*sin(x(i,3)+x(i,4)+x(i,5)))/2-Mh*ls*sin(x(i,3)+x(i,4)+x(i,5))-(Mt*lt*sin(x(i,3)+x(i,4)))/2-Ms*lt*sin(x(i,3)+x(i,4))-Mh*lt*sin(x(i,3)+x(i,4)),Itx+Isx+(Mt*lt^2)/4+Ms*lt^2+(Ms*ls^2)/4+Mh*lt^2+Mh*ls^2+(Ms*la*ls*cos(x(i,4)+x(i,5)))/2+Mh*la*ls*cos(x(i,4)+x(i,5))+(Mt*la*lt*cos(x(i,4)))/2+Ms*la*lt*cos(x(i,4))+Ms*lt*ls*cos(x(i,5))+Mh*la*lt*cos(x(i,4))+2*Mh*lt*ls*cos(x(i,5)),Itx+Isx+(Mt*lt^2)/4+Ms*lt^2+(Ms*ls^2)/4+Mh*lt^2+Mh*ls^2+Ms*lt*ls*cos(x(i,5))+2*Mh*lt*ls*cos(x(i,5)),Isx+Mh*ls*(ls+lt*cos(x(i,5)))+(Ms*ls*(ls/2+lt*cos(x(i,5))))/2;
                -(ls*cos(x(i,3)+x(i,4)+x(i,5))*(Ms+2*Mh))/2,-(ls*sin(x(i,3)+x(i,4)+x(i,5))*(Ms+2*Mh))/2,Isx+(Ms*ls*(ls/2+la*cos(x(i,4)+x(i,5))+lt*cos(x(i,5))))/2+Mh*ls*(ls+la*cos(x(i,4)+x(i,5))+lt*cos(x(i,5))),Isx+Mh*ls*(ls+lt*cos(x(i,5)))+(Ms*ls*(ls/2+lt*cos(x(i,5))))/2,Isx+(Ms*ls^2)/4+Mh*ls^2];
        KE(i) = 1/2*qdot(i,:)'*M*qdot(i,:);
        PE(i) = (1/2)*g*(la*(4*Mt+4*Ms+3*Mf+2*Mh)*cos(x(i,3))...
                +lt*(3*Mt+2*(2*Ms+Mf+Mh))*cos(x(i,3)+x(i,4))...
                +2*ls*Mt*cos(x(i,3)+x(i,4)+x(i,5))...
                +3*ls*Ms*cos(x(i,3)+x(i,4)+x(i,5))...
                +2*ls*Mf*cos(x(i,3)+x(i,4)+x(i,5))...
                +2*ls*Mh*cos(x(i,3)+x(i,4)+x(i,5))...
                +2*(2*(Mt+Ms+Mf)+Mh)*x(i,2));
    end 
else
    qdot = x(9:13);
    M = [Mt+Ms+Mf+Mh,0,-(Ms*ls*cos(x(3)+x(4)+x(5)))/2-Mh*ls*cos(x(3)+x(4)+x(5))-(Mt*lt*cos(x(3)+x(4)))/2-Ms*lt*cos(x(3)+x(4))-Mh*lt*cos(x(3)+x(4))-Mt*la*cos(x(3))-Ms*la*cos(x(3))-(Mf*la*cos(x(3)))/2-Mh*la*cos(x(3)),-(Ms*ls*cos(x(3)+x(4)+x(5)))/2-Mh*ls*cos(x(3)+x(4)+x(5))-(Mt*lt*cos(x(3)+x(4)))/2-Ms*lt*cos(x(3)+x(4))-Mh*lt*cos(x(3)+x(4)),-(ls*cos(x(3)+x(4)+x(5))*(Ms+2*Mh))/2;0,Mt+Ms+Mf+Mh,-(Ms*ls*sin(x(3)+x(4)+x(5)))/2-Mh*ls*sin(x(3)+x(4)+x(5))-(Mt*lt*sin(x(3)+x(4)))/2-Ms*lt*sin(x(3)+x(4))-Mh*lt*sin(x(3)+x(4))-Mt*la*sin(x(3))-Ms*la*sin(x(3))-(Mf*la*sin(x(3)))/2-Mh*la*sin(x(3)),-(Ms*ls*sin(x(3)+x(4)+x(5)))/2-Mh*ls*sin(x(3)+x(4)+x(5))-(Mt*lt*sin(x(3)+x(4)))/2-Ms*lt*sin(x(3)+x(4))-Mh*lt*sin(x(3)+x(4)),-(ls*sin(x(3)+x(4)+x(5))*(Ms+2*Mh))/2;-(Ms*ls*cos(x(3)+x(4)+x(5)))/2-Mh*ls*cos(x(3)+x(4)+x(5))-(Mt*lt*cos(x(3)+x(4)))/2-Ms*lt*cos(x(3)+x(4))-Mh*lt*cos(x(3)+x(4))-Mt*la*cos(x(3))-Ms*la*cos(x(3))-(Mf*la*cos(x(3)))/2-Mh*la*cos(x(3)),-(Ms*ls*sin(x(3)+x(4)+x(5)))/2-Mh*ls*sin(x(3)+x(4)+x(5))-(Mt*lt*sin(x(3)+x(4)))/2-Ms*lt*sin(x(3)+x(4))-Mh*lt*sin(x(3)+x(4))-Mt*la*sin(x(3))-Ms*la*sin(x(3))-(Mf*la*sin(x(3)))/2-Mh*la*sin(x(3)),Itx+Isx+Mt*la^2+Ms*la^2+(Mt*lt^2)/4+Ms*lt^2+(Ms*ls^2)/4+(Mf*la^2)/4+Mh*la^2+Mh*lt^2+Mh*ls^2+Ms*la*ls*cos(x(4)+x(5))+2*Mh*la*ls*cos(x(4)+x(5))+Mt*la*lt*cos(x(4))+2*Ms*la*lt*cos(x(4))+Ms*lt*ls*cos(x(5))+2*Mh*la*lt*cos(x(4))+2*Mh*lt*ls*cos(x(5)),Itx+Isx+(Mt*lt^2)/4+Ms*lt^2+(Ms*ls^2)/4+Mh*lt^2+Mh*ls^2+(Ms*la*ls*cos(x(4)+x(5)))/2+Mh*la*ls*cos(x(4)+x(5))+(Mt*la*lt*cos(x(4)))/2+Ms*la*lt*cos(x(4))+Ms*lt*ls*cos(x(5))+Mh*la*lt*cos(x(4))+2*Mh*lt*ls*cos(x(5)),Isx+(Ms*ls*(ls/2+la*cos(x(4)+x(5))+lt*cos(x(5))))/2+Mh*ls*(ls+la*cos(x(4)+x(5))+lt*cos(x(5)));-(Ms*ls*cos(x(3)+x(4)+x(5)))/2-Mh*ls*cos(x(3)+x(4)+x(5))-(Mt*lt*cos(x(3)+x(4)))/2-Ms*lt*cos(x(3)+x(4))-Mh*lt*cos(x(3)+x(4)),-(Ms*ls*sin(x(3)+x(4)+x(5)))/2-Mh*ls*sin(x(3)+x(4)+x(5))-(Mt*lt*sin(x(3)+x(4)))/2-Ms*lt*sin(x(3)+x(4))-Mh*lt*sin(x(3)+x(4)),Itx+Isx+(Mt*lt^2)/4+Ms*lt^2+(Ms*ls^2)/4+Mh*lt^2+Mh*ls^2+(Ms*la*ls*cos(x(4)+x(5)))/2+Mh*la*ls*cos(x(4)+x(5))+(Mt*la*lt*cos(x(4)))/2+Ms*la*lt*cos(x(4))+Ms*lt*ls*cos(x(5))+Mh*la*lt*cos(x(4))+2*Mh*lt*ls*cos(x(5)),Itx+Isx+(Mt*lt^2)/4+Ms*lt^2+(Ms*ls^2)/4+Mh*lt^2+Mh*ls^2+Ms*lt*ls*cos(x(5))+2*Mh*lt*ls*cos(x(5)),Isx+Mh*ls*(ls+lt*cos(x(5)))+(Ms*ls*(ls/2+lt*cos(x(5))))/2;-(ls*cos(x(3)+x(4)+x(5))*(Ms+2*Mh))/2,-(ls*sin(x(3)+x(4)+x(5))*(Ms+2*Mh))/2,Isx+(Ms*ls*(ls/2+la*cos(x(4)+x(5))+lt*cos(x(5))))/2+Mh*ls*(ls+la*cos(x(4)+x(5))+lt*cos(x(5))),Isx+Mh*ls*(ls+lt*cos(x(5)))+(Ms*ls*(ls/2+lt*cos(x(5))))/2,Isx+(Ms*ls^2)/4+Mh*ls^2]; 
    KE = 1/2*qdot'*M*qdot;
    PE = (1/2)*g*(la*(4*Mt+4*Ms+3*Mf+2*Mh)*cos(x(3))...
        +lt*(3*Mt+2*(2*Ms+Mf+Mh))*cos(x(3)+x(4))...
        +2*ls*Mt*cos(x(3)+x(4)+x(5))...
        +3*ls*Ms*cos(x(3)+x(4)+x(5))...
        +2*ls*Mf*cos(x(3)+x(4)+x(5))...
        +2*ls*Mh*cos(x(3)+x(4)+x(5))...
        +2*(2*(Mt+Ms+Mf)+Mh)*x(2));
end
E= KE + PE;
% disp(['KE ',num2str(KE)])
% disp(['PE ',num2str(PE)])
end