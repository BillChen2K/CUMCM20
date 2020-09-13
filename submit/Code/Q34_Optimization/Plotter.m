%%  寻找最小值

 minRow = find(Output(:,7) == min(Output(:,7)));
 Output(minRow,:)
 
 

%% 优化结果绘制
scatter3(Output(:,1), Output(:,2),Output(:,7));
view(40, 35);
set(gcf,'position',[0,0,1000,400]);
box on;
grid on;
% title("粗粒度遍历 (dv = 3)");
% title("中粒度遍历 (dv = 1)");
title("细粒度遍历 (dv = 0.3)");
xlabel('v');
ylabel('T_{fur1}');
zlabel('A');
exportgraphics(gcf,'OROUND3.png','Resolution',300);
