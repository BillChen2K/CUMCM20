clf; close all;
%% 特定条件下的预测

% 预测得到的参数
lambda = 99.7964;
h = 1813.6;
theta = 21.2916;
V = 78;
sol = TPDESolve(lambda, h, theta, V);
res = sol(:,15);
lines = [25 / (V / 60)];

furnaceLength = 30.5; % 熔炉长度
furnaceGap = 5;  % 熔炉间隙
edgeGap = 25; % 炉前与炉后

% 绘制炉
% figure;
width = 900; height = 350;
set(gcf,'position',[0,0,width,height])
red = '#EB4537';
green = '#55AF7B';
blue = '#4286F3';
plot(0.5:0.5:400, res, 'LineWidth', 2, 'Color', blue);
grid on;
hold on;

% 温度曲线
x = 0.5:0.5:400;
y = 1:800;
for i = 1:800
    y(i) = Tfur(x(i));
end
plot(x, y, 'Color', red, 'LineWidth', 1)

for i=1:11
    lines = [lines, (25 + i * (furnaceLength + furnaceGap)) / (V / 60)];
end

for i=1:12
    line([lines(i) lines(i)], [0 300], 'linewidth', 0.7, 'color', green);
    if i ~= 1
        text(lines(i) - 18, 290,['#', num2str(i - 1)]);
    else
        text(lines(i) - 18, 290,['炉前']);

    end
end
title('问题一预测结果')
xlabel('t (s)');
ylabel('T (^{\circ}C)');

% Mark maximum.
amax = max(res);
tmax = find(res==amax) / 2;
plot(tmax,amax,'Color',red,'Marker','v','LineStyle','none','LineWidth',1);
text(tmax-2,amax*0.9,['最大值: ', num2str(amax), '^{\circ}C']);

lgd = {'预测结果', '炉内理想温度曲线'};
legend(lgd,'location','southoutside','NumColumns',2,'FontSize',10);
xlim([0, 350]);
exportgraphics(gcf,'pic/Q1.png','Resolution',300)



%% 3D Surface
figure;
t = 0.5:0.5:800;
% surf(1:10:300,t(1:10:800),sol(1:10:800,:));
surf(1:30:900,linspace(0,450,80),sol(1:10:800,:));

set(gcf,'position',[0,0,width,height])
title('各温区间温度交换变化曲线');
ylabel('s (cm)');
xlabel('t (s)');
zlabel('T_{furj} (^{\circ}C)');
xlim([0 250])
ylim([0 380])

for i=1:12
    line([0 0], [lines(i) lines(i)], [0 300], 'linewidth', 0.7, 'color', green);
    line([250 250], [lines(i) lines(i)], [0 300], 'linewidth', 0.7, 'color', green);

    if i ~= 1
       
        text(0, lines(i) - 6, 310,['#', num2str(i - 1)]);
    else
        text(0, lines(i) - 6, 310,['炉前']);

    end
end

lgd = {'温区间温度交换曲线'};
legend(lgd,'location','southoutside','NumColumns',2,'FontSize',10);
exportgraphics(gcf,'pic/TempExchange.png','Resolution',300)

