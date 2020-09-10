function A = A_DSupp_func(x)
%AHEEL Summary of this function goes here
%   Detailed explanation goes here
global flowdata   
    la = flowdata.Parameters.Biped.la;
    lf = flowdata.Parameters.Biped.lf;
    l1 = flowdata.Parameters.Biped.ls;
    l2 = flowdata.Parameters.Biped.lt;
    dim = flowdata.Parameters.dim;
    q = x(1:dim/2);   
        %trailing toe constraint, still "stance leg"
        A=zeros(2,8);
        
        A(1,1)=1;
        A(1,3)=lf*sin(q(3));
        A(2,2)=1;
        A(2,3)=-lf*cos(q(3));
        
        %new lead heel constraint pre relabeling
        temp = [[1;0;(-1).*la.*cos(x(3))+(-1).*l1.*cos(x(3)+x(4))+(-1).*l2.*cos(x(3)+x(4)+x(5))+l2.*cos(x(3)+x(4)+x(5)+x(6))+l1.*cos(x(3)+x(4)+x(5)+x(6)+x(7))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8));(-1).*l1.*cos(x(3)+x(4))+(-1).*l2.*cos(x(3)+x(4)+x(5))+l2.*cos(x(3)+x(4)+x(5)+x(6))+l1.*cos(x(3)+x(4)+x(5)+x(6)+x(7))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8));(-1).*l2.*cos(x(3)+x(4)+x(5))+l2.*cos(x(3)+x(4)+x(5)+x(6))+l1.*cos(x(3)+x(4)+x(5)+x(6)+x(7))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8));l2.*cos(x(3)+x(4)+x(5)+x(6))+l1.*cos(x(3)+x(4)+x(5)+x(6)+x(7))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8));l1.*cos(x(3)+x(4)+x(5)+x(6)+x(7))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8));la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))],[0;1;(-1).*la.*sin(x(3))+(-1).*l1.*sin(x(3)+x(4))+(-1).*l2.*sin(x(3)+x(4)+x(5))+l2.*sin(x(3)+x(4)+x(5)+x(6))+l1.*sin(x(3)+x(4)+x(5)+x(6)+x(7))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8));(-1).*l1.*sin(x(3)+x(4))+(-1).*l2.*sin(x(3)+x(4)+x(5))+l2.*sin(x(3)+x(4)+x(5)+x(6))+l1.*sin(x(3)+x(4)+x(5)+x(6)+x(7))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8));(-1).*l2.*sin(x(3)+x(4)+x(5))+l2.*sin(x(3)+x(4)+x(5)+x(6))+l1.*sin(x(3)+x(4)+x(5)+x(6)+x(7))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8));l2.*sin(x(3)+x(4)+x(5)+x(6))+l1.*sin(x(3)+x(4)+x(5)+x(6)+x(7))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8));l1.*sin(x(3)+x(4)+x(5)+x(6)+x(7))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8));la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))]];
        A = [A;temp'];
end

