
s=scatter(0,0);
s.LineWidth = 5;
for i=1:13 %grid kd  
    for j=1:91% grid joints
        s.YData(end+1) = i;
        s.XData(end+1) = j;
        if iscell(output{i}.exps{j}) && output{i}.exps{j}{2}<1
            s.CData(end+1,:) = [0,1,0];
        else
            s.CData(end+1,:) = [1,0,0];
        end
    end
end