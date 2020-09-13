
%% 设定温度曲线绘制

x = 0.5:0.5:400;
y = 1:800;
for i = 1:800
    y(i) = Tfur(x(i));
end
% figure;
box on; grid on; hold on;
width = 900;
height = 350;
set(gcf,'position',[0,0,width,height])
red = '#EB4537';
green = '#55AF7B';
blue = '#4286F3';

title('拟合结果')
xlabel('t (s)')
ylabel('T (^{\circ}C)')

t = xlsread('temp.xlsx')
plot(t(:,1), t(:,2), 'Color', green, 'LineWidth', 1)
plot(x, y, 'Color',red, 'LineWidth', 1)

for i=1:11
    lines = [lines, (25 + i * (furnaceLength + furnaceGap)) / (70 / 60)];
end

for i=1:12
    line([lines(i) lines(i)], [0 300], 'linewidth', 0.7, 'color', green);
    if i ~= 1
        text(lines(i) - 18, 290,['#', num2str(i - 1)]);
    else
        text(lines(i) - 18, 290,['炉前']);

    end
end


lgd = {'拟合结果', '实际试验数据', '理想炉温曲线'};
legend(lgd,'location','southoutside','NumColumns',3,'FontSize',10);
xlim([0 370])
exportgraphics(gcf,'pic/FitResult.png','Resolution',300)

% saveas(gcf,['pic/','FurnacePreTemp','.png'])

%% 控制方程






