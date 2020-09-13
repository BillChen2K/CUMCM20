% 从最大速度开始筛选
detail = [];
red = '#EB4537';
green = '#55AF7B';
blue = '#4286F3';
for vv = 75.4:-0.001:75.3
% for vv = 100:-0.5:65
    out = vv
    % 指定拟合的模型参数
    lambda = 99.7964;
    h = 1813.6;
    theta = 21.2916;
    sol = TPDESolve(lambda, h, theta, vv);
    sol = sol(:,15);
    restrains = {@RestrainDiff @RestrainRising @RestrainPeakTime @RestrainPeakTemp};
    flag = 0;
    [r1, dd(2), dd(3)] = RestrainDiff(sol);
    [r2, dd(4)] = RestrainRising(sol);
    [r3, dd(5)] = RestrainPeakTime(sol);
    [r4, dd(6)] = RestrainPeakTemp(sol);
    
    dd(1) = vv;
    if ~r1
        flag = 1;
    end
    
    if ~r2
        flag = 2;
    end
    
    if ~r3
        flag = 3;
    end
    
    if ~r4
        flag = 4;
    end
    dd(7) = flag;
    detail = [detail; dd];

end

writematrix(detail, 'Q2.csv');

%% 可视化
figure;
hold on;
grid on;
box on;

set(gcf,'position',[0,0,1000,450])
subplot(2,3,1);
plot(detail(:,1), detail(:,2),  'Color', red, 'LineWidth', 1);
xlabel('v (cm/min)')
ylabel('最大梯度 (^{\circ}C / s)');
subplot(2,3,2);
plot(detail(:,1), detail(:,3),  'Color', red, 'LineWidth', 1);
xlabel('v (cm/min)')
ylabel('最小梯度 (^{\circ}C / s)');
subplot(2,3,3);
plot(detail(:,1), detail(:,4),  'Color', red, 'LineWidth', 1);
xlabel('v (cm/min)')
ylabel('升温时间 (s)');
subplot(2,3,4);
plot(detail(:,1), detail(:,5),  'Color', red, 'LineWidth', 1);
xlabel('v (cm/min)')
ylabel('高温时间 (s)');
subplot(2,3,5);
plot(detail(:,1), detail(:,6),  'Color', red, 'LineWidth', 1);
xlabel('v (cm/min)')
ylabel('峰值温度 (^{\circ}C / s)');
exportgraphics(gcf,'pic/Trend.png','Resolution',300);


function [res, valueMax, valueMin] = RestrainDiff(sol)
%% 斜率是否超过 3？
    tdiff = 2 * diff(sol);
    rising = tdiff(tdiff > 0);
    descending = tdiff(tdiff < 0);
    [rc,~] = size(rising(rising > 3));
    [dc,~] = size(descending(descending < -3));
    if rc ~= 0
        sprintf("升温速度过大。")
        res = false;
        return;
    end
    if dc ~= 0
        sprintf("降温速度过大。")
        res = false;
        return;
    end
    valueMax = max(tdiff);
    valueMin = min(tdiff);
    res = true;
end

function [res, value] = RestrainRising(sol)
%% 升温时间是否符合要求？
    % 只考虑升温过程
    sol = sol(1:600);
    count = sol(sol > 150 & sol < 190);
    [t, ~] = size(count);
    if t / 2 > 60 && t / 2 < 120
        res = true;
    else
        res = false;
        sprintf("升温时间不合要求。")
    end
    value = t / 2;
end


function [res, value] = RestrainPeakTime(sol)
%% 高温时间是否符合要求？

    count = sol(sol > 217);
    [t, ~] = size(count);
    if t / 2 > 40 && t / 2 < 90
        res = true;
    else
        res = false;
        sprintf("高温时间不合要求。")
    end
    value = t / 2;
end


function [res, value] = RestrainPeakTemp(sol)
%% 峰值温度是否符合要求？
    mt = max(sol);
    if mt > 240 && mt < 250
        res = true;
    else
        res = false;
        sprintf("峰值温度不合要求。")
    end
    value = mt;
end