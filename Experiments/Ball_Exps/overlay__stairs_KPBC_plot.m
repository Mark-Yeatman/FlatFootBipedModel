%%
load(strcat(pwd,'\Experiments\Ball_Exps\Data\Level_Ground_KPBC_Data'))
cmap = zeros(length(results),3); %make the plot all black
%% Plot
for i = length(results):-1:1
    xout = results{i}{3};
    y = xout(:,2);
    x = xout(:,4);
    p = plot(x,y,'Color',cmap(i,:),'LineWidth',1);
    set( get( get( p, 'Annotation'), 'LegendInformation' ), 'IconDisplayStyle', 'off' );
    hold on
end

xlabel('$\dot{y}$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')

limits = axis;
hold on
p = plot([limits(1),0],[0,0],'k --','LineWidth',3);
set( get( get( p, 'Annotation'), 'LegendInformation' ), 'IconDisplayStyle', 'off' );  
axis(limits)

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

%% Load choice
load(strcat(pwd,'\Experiments\Ball_Exps\Data\Level_Ground_Data'))
cmap = color_interpolate([1,0,0],[0,0,1],length(results));

%load(strcat(pwd,'\Experiments\Ball_Exps\Data\Stairs_Data'))
%cmap = color_interpolate([0,0,1],[1,0,0],length(results));
%% Plot
line_array = zeros(length(results),1);
for i = length(results):-1:1
    xout = results{i}{3};
    y = xout(:,2);
    x = xout(:,4);
    line_array(i) = plot(x,y,'Color',cmap(i,:),'LineWidth',1,'LineStyle','--');
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


