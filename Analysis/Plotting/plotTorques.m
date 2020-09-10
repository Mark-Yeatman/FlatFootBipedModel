[I,J,L] = size(out_extra.Forces);
cords = {'x','y'};
legendstrs = {};
figure('Name','Torques and Forces','NumberTitle','off')
for i = 1:I
    for j = 1:J
        F = squeeze(out_extra.Forces(i,j,:));
        plot(tout,F)
        hold on
        fname  = replace(func2str(flowdata.Controls.Internal{i}),"_func"," ");
        fname  = replace(fname,"_"," ");
        legendstrs{end+1} = strcat(fname,cords{j});
    end
end
legend(legendstrs)
xlabel('time')
ylabel('Torque/Force')