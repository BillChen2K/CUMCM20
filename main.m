clear;
clf; close all;

%% 设定温度曲线绘制

x = 0:0.1:350;
y = 0:3500;
for i = 1:3501
    y(i) = Tfur(x(i));
end
figure
width = 800;
height = 400;
set(gcf,'position',[0,0,width,height])
red = '#EB4537';
green = '#55AF7B';
blue = '#4286F3';
box on
grid on
hold on
plot(x, y, 'Color',red, 'LineWidth', 1)
title('炉温设定温度')
xlabel('t (s)')
ylabel('T_{fur} (^{\circ}C)')

saveas(gcf,['pic/','FurnacePreTemp','.png'])

t = xlsread('temp.xlsx')
plot(t(:,1), t(:,2), 'Color',green, 'LineWidth', 1)


