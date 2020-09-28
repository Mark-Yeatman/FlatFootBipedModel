function A = A_DSuppTF_func(q,qdot)
%AHEEL Summary of this function goes here
%   Detailed explanation goes here
global flowdata   
    la = flowdata.Parameters.Biped.la;
    lf = flowdata.Parameters.Biped.lf;
    ls = flowdata.Parameters.Biped.ls;
    lt = flowdata.Parameters.Biped.lt;
    dim = flowdata.Parameters.dim;
    x = [q;qdot];   
        
    %trailing toe constraint, still "stance leg"
%     A=zeros(2,8);
%     A(1,1)=1;
%     A(1,3)=lf*sin(q(3));
%     A(2,2)=1;
%     A(2,3)=lf*cos(q(3));
% 
     x=[q;qdot];
%     %new lead heel constraint pre relabeling
%     temp = [[1,0,(-1).*la.*cos(x(3))+(-1).*ls.*cos(x(3)+x(4))+(-1).*lt.*cos(x(3)+x(4)+x(5))+lt.*cos(x(3)+x(4)+x(5)+x(6))+ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),(-1).*ls.*cos(x(3)+x(4))+(-1).*lt.*cos(x(3)+x(4)+x(5))+lt.*cos(x(3)+x(4)+x(5)+x(6))+ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),(-1).*lt.*cos(x(3)+x(4)+x(5))+lt.*cos(x(3)+x(4)+x(5)+x(6))+ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),lt.*cos(x(3)+x(4)+x(5)+x(6))+ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))];[0,1,(-1).*la.*sin(x(3))+(-1).*ls.*sin(x(3)+x(4))+(-1).*lt.*sin(x(3)+x(4)+x(5))+lt.*sin(x(3)+x(4)+x(5)+x(6))+ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),(-1).*ls.*sin(x(3)+x(4))+(-1).*lt.*sin(x(3)+x(4)+x(5))+lt.*sin(x(3)+x(4)+x(5)+x(6))+ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),(-1).*lt.*sin(x(3)+x(4)+x(5))+lt.*sin(x(3)+x(4)+x(5)+x(6))+ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),lt.*sin(x(3)+x(4)+x(5)+x(6))+ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))]];
%     A = [A;temp];
    
    %% changed so that trailing foot is swing leg
    
    %stance heel constraint
    Aflat=[eye(3),zeros(3,5)];
    
    %swing toe constraint
    Atoe = [[1,0,(-1).*la.*cos(x(3))+(-1).*ls.*cos(x(3)+x(4))+(-1).*lt.*cos(x(3)+x(4)+x(5))+lt.*cos(x(3)+x(4)+x(5)+x(6))+ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))+(-1).*lf.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),(-1).*ls.*cos(x(3)+x(4))+(-1).*lt.*cos(x(3)+x(4)+x(5))+lt.*cos(x(3)+x(4)+x(5)+x(6))+ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))+(-1).*lf.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),(-1).*lt.*cos(x(3)+x(4)+x(5))+lt.*cos(x(3)+x(4)+x(5)+x(6))+ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))+(-1).*lf.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),lt.*cos(x(3)+x(4)+x(5)+x(6))+ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))+(-1).*lf.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))+(-1).*lf.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))+(-1).*lf.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))];[0,1,lf.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))+(-1).*la.*sin(x(3))+(-1).*ls.*sin(x(3)+x(4))+(-1).*lt.*sin(x(3)+x(4)+x(5))+lt.*sin(x(3)+x(4)+x(5)+x(6))+ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),lf.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))+(-1).*ls.*sin(x(3)+x(4))+(-1).*lt.*sin(x(3)+x(4)+x(5))+lt.*sin(x(3)+x(4)+x(5)+x(6))+ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),lf.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))+(-1).*lt.*sin(x(3)+x(4)+x(5))+lt.*sin(x(3)+x(4)+x(5)+x(6))+ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),lf.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))+lt.*sin(x(3)+x(4)+x(5)+x(6))+ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),lf.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))+ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)),lf.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))+la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8))]];
    A = [Atoe;Aflat];
end

