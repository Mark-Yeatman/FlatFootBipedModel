function Adot = Adot_DSuppToeHeel_func(q,qdot)
%AHEEL Summary of this function goes here
%   Detailed explanation goes here
global flowdata   
    la = flowdata.Parameters.Biped.la;
    lf = flowdata.Parameters.Biped.lf;
    ls = flowdata.Parameters.Biped.ls;
    lt = flowdata.Parameters.Biped.lt;
    
    %trailing toe constraint, still "stance leg"
%     Adot=zeros(2,8);
% 
%     Adot(1,3)=lf*cos(q(3))*qdot(3);
%     Adot(2,3)=-lf*sin(q(3))*qdot(3);    
%     
     x=[q;qdot];
%     %new lead heel constraint pre relabeling
%     temp = [[0,0,la.*sin(x(3)).*x(11)+ls.*sin(x(3)+x(4)).*(x(11)+x(12))+lt.*sin(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+(-1).*lt.*sin(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+(-1).*ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),ls.*sin(x(3)+x(4)).*(x(11)+x(12))+lt.*sin(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+(-1).*lt.*sin(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+(-1).*ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),lt.*sin(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+(-1).*lt.*sin(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+(-1).*ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),(-1).*lt.*sin(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+(-1).*ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),(-1).*ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))];[0,0,(-1).*la.*cos(x(3)).*x(11)+(-1).*ls.*cos(x(3)+x(4)).*(x(11)+x(12))+(-1).*lt.*cos(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+lt.*cos(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),(-1).*ls.*cos(x(3)+x(4)).*(x(11)+x(12))+(-1).*lt.*cos(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+lt.*cos(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),(-1).*lt.*cos(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+lt.*cos(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),lt.*cos(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))]];
%     Adot = [Adot;temp];
    
    %% Changed so stance foot is leading.
    Aheeldot=zeros(2,8);
    
    Atoedot =[0,0,la.*sin(x(3)).*x(11)+ls.*sin(x(3)+x(4)).*(x(11)+x(12))+lt.*sin(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+(-1).*lt.*sin(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+(-1).*ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+(-1).*lf.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))+(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),ls.*sin(x(3)+x(4)).*(x(11)+x(12))+lt.*sin(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+(-1).*lt.*sin(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+(-1).*ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+(-1).*lf.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))+(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),lt.*sin(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+(-1).*lt.*sin(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+(-1).*ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+(-1).*lf.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))+(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),(-1).*lt.*sin(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+(-1).*ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+(-1).*lf.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))+(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),(-1).*ls.*sin(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+(-1).*lf.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))+(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),(-1).*lf.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))+(-1).*la.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16));
              0,0,(-1).*la.*cos(x(3)).*x(11)+(-1).*ls.*cos(x(3)+x(4)).*(x(11)+x(12))+(-1).*lt.*cos(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+lt.*cos(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))+(-1).*lf.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),(-1).*ls.*cos(x(3)+x(4)).*(x(11)+x(12))+(-1).*lt.*cos(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+lt.*cos(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))+(-1).*lf.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),(-1).*lt.*cos(x(3)+x(4)+x(5)).*(x(11)+x(12)+x(13))+lt.*cos(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))+(-1).*lf.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),lt.*cos(x(3)+x(4)+x(5)+x(6)).*(x(11)+x(12)+x(13)+x(14))+ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))+(-1).*lf.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),ls.*cos(x(3)+x(4)+x(5)+x(6)+x(7)).*(x(11)+x(12)+x(13)+x(14)+x(15))+la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))+(-1).*lf.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16)),la.*cos(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))+(-1).*lf.*sin(x(3)+x(4)+x(5)+x(6)+x(7)+x(8)).*(x(11)+x(12)+x(13)+x(14)+x(15)+x(16))];
    
    Adot = [Atoedot;];%Aheeldot];
end
