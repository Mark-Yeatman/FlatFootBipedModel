set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gcf, 'Position',[1     1   747   495])
set(findall(gcf,'-property','FontSize'),'FontSize',18)
set(findall(gcf,'-property','Interpreter'),'Interpreter','Latex')
set(get(gca,'YLabel'), 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
set(get(gca,'YLabel'),'Rotation',0)
set(get(gca,'Legend'),'Location','eastoutside')