function Adot = Adot_DSupp_func(x)
%AHEEL Summary of this function goes here
%   Detailed explanation goes here
global flowdata   
    la = flowdata.Parameters.Biped.la;
    lf = flowdata.Parameters.Biped.lf;
    l1 = flowdata.Parameters.Biped.ls;
    l2 = flowdata.Parameters.Biped.lt;
    dim = flowdata.Parameters.dim;
    q = x(1:dim/2);
    qdot = x(dim/2+1:dim);   

    %trailing toe constraint, still "stance leg"
    Adot=zeros(2,8);

    Adot(1,3)=lf*cos(q(3))*qdot(3);
    Adot(2,3)=lf*sin(q(3))*qdot(3); 

    %new lead heel constraint pre relabeling
    temp = [[0;0;la.*sin(x(3)).*x(11)+l1.*sin(x(3)+x(4)).*(x(11)+x(12))+l2.*sin(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+(-1).*l2.*sin(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+(-1).*l1.*sin(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16));l1.*sin(x(3)+x(4)).*(x(11)+x(12))+l2.*sin(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+(-1).*l2.*sin(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+(-1).*l1.*sin(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16));l2.*sin(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+(-1).*l2.*sin(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+(-1).*l1.*sin(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16));(-1).*l2.*sin(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+(-1).*l1.*sin(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16));(-1).*(l1.*sin(x(3)+x(4)+x(5)+x(6)+x(7))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))).*(x(11)+x(12)+x(13)+x(14)+x(15))+(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*x(16);(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))],[0;0;(-1).*la.*cos(x(3)).*x(11)+(-1).*l1.*cos(x(3)+x(4)).*(x(11)+x(12))+(-1).*l2.*cos(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+l2.*cos(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+l1.*cos(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16));(-1).*l1.*cos(x(3)+x(4)).*(x(11)+x(12))+(-1).*l2.*cos(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+l2.*cos(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+l1.*cos(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16));(-1).*l2.*cos(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+l2.*cos(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+l1.*cos(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16));l2.*cos(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+l1.*cos(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16));(l1.*cos(x(3)+x(4)+x(5)+x(6)+x(7))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))).*(x(11)+x(12)+x(13)+x(14)+x(15))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*x(16);la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))]];
    Adot = [Adot;temp'];
end

