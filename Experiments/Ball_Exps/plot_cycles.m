%% Load choice
load(strcat(pwd,'\Experiments\Ball_Exps\Data\Level_Ground_Data'))
cmap = color_interpolate([1,0,0],[0,0,1],length(results));

%load(strcat(pwd,'\Experiments\Ball_Exps\Data\Stairs_Data'))
%cmap = color_interpolate([0,0,1],[1,0,0],length(results));

%load(strcat(pwd,'\Experiments\Ball_Exps\Data\Level_Ground_KPBC_Data'))
%cmap = zeros(length(results),3); %make the plot all black
%%
%Plot
figure
line_array = zeros(length(results),1);
for i = length(results):-1:1
    xout = results{i}{3};
    y = xout(:,2);
    x = xout(:,4);
    line_array(i) = plot(x,y,'Color',cmap(i,:),'LineWidth',1);
    hold on
end

title("Phase Portraits")
xlabel('$\dot{y}$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')

limits = axis;
hold on
plot([limits(1),0],[0,0],'k --','LineWidth',3);
axis(limits)

E_labels = flip(E_labels);
for i = 1:length(E_labels)
    E_labels{i} = num2str(round(str2double(E_labels{i}),2)); 
end
L = legend(E_labels,'Location','eastoutside');
title(L,'Energy (Joules)');

for i = length(results):-1:1
     xminus = results{i}{5}.istate_minus;
     xplus = results{i}{5}.istate_plus;
     p = plot(xplus(4),xplus(2),...
         'LineStyle','none','Marker','o','MarkerEdgeColor',cmap(i,:),...
         'MarkerFaceColor',cmap(i,:));
     set( get( get( p, 'Annotation'), 'LegendInformation' ), 'IconDisplayStyle', 'off' );
     p = plot(xminus(4),xminus(2),...
         'LineStyle','none','Marker','d','MarkerEdgeColor',cmap(i,:),...
         'MarkerFaceColor',cmap(i,:));
     set( get( get( p, 'Annotation'), 'LegendInformation' ), 'IconDisplayStyle', 'off' );  
end

grid on
%% 
% limits = axis;
% axis(limits);
% LEG = legend(E_labels);
% % [X,Y,Z] = meshgrid(h,limits(3):0.5:limits(4),limits(5):0.5:limits(6));
% % surf(X,Y,Z,'C
% x0 = h;
% x1 = h;
% y0 = limits(3);
% y1 = limits(4);
% z0 = limits(5);
% z1 = limits(6);
% p = patch([h,h,h,h], [y0,y0,y1,y1], [z0, z1, z1, z0], 'black');
% alpha(p,0.2);
% title(LEG,'Energy (Joules)')
% grid on