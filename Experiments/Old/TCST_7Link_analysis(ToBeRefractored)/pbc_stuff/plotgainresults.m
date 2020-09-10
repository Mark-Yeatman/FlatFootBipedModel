
% ratiospace = [0,0.1,0.25,0.5,0.75,0.9,1];
% kdspace = [1,2,3,4,5,6,7,8,9];
% s=scatter(0,0);
% s.LineWidth = 5;
% for i=1:length(kdspace) %grid kd  
%     m = 5*length(ratiospace);
%     for j=8:-1:4% grid joints
%         for k=length(ratiospace):-1:1 %grid gains
%             s.YData(end+1) = i;
%             s.XData(end+1) = m;
%             if iscell(output{i}.exps{j,k}) && output{i}.exps{j,k}{2}<1
%                 s.CData(end+1,:) = [0,1,0];
%             else
%                 s.CData(end+1,:) = [1,0,0];
%             end
%             m = m-1;
%         end
%     end
% end

ratiospace = [0,0.1,0.25,0.5,0.75,0.9,1];
kdspace = [1,2,3,4,5,6,7,8,9];
for i=1:length(kdspace) %grid kd  
    m = 5*length(ratiospace);
    for j=8:-1:4% grid joints
        for k=length(ratiospace):-1:1 %grid gains
            if m == 31
               disp(j)
               disp(k)
            end
            m = m-1;
        end
    end
end