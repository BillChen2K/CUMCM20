% 模型参数

Output = [];
OutputFail = [];

lambda = 99.7964;
h = 1813.6;
theta = 21.2916;

% 优化参数

% V = 70;
% t1 = 175;
% t2 = 195;
% t3 = 240;
% t4 = 257;
% t5 = 25; % t5 恒定为 25

% ROUND 1
% dt = 3;
% % 
% Vb = [89 100];
% t1b = [165 185];
% t2b = [185 205];
% t3b = [225 245];
% t4b = [245 265];

% % ROUND 2
dt = 1;

Vb = [94 96];
t1b = [180 186];
t2b = [197 203];
t3b = [237 243];
t4b = [260 265];

% ROUND 3
dt = 0.15;
Vb = [98.3 98.6];
t1b = [181.4 182.6];
t2b = [202.4 203.6];
t3b = [242.4 243.6];
t4b = [263.4 264.6];

for V=Vb(1):dt:Vb(2)
    for t1=t1b(1):dt:t1b(2)
        for t2=t2b(1):dt:t2b(2)
            for t3=t3b(1):dt:t3b(2)
                for t4=t4b(1):dt:t4b(2)
                    [Aera, sol] = FF(lambda, h, theta, V, [t1 t2 t3 t4 t5]);
                    [success, flag] = Restrain(sol(:,15));
                    if success
                        Output = [Output; [V, t1, t2, t3, t4, t5, Aera]];
                    else
                        OutputFail = [OutputFail; [V, t1, t2, t3, t4, t5, flag]];
                    end
                    disp([V t1 t2 t3 t4 success flag round(Aera)]);
                end
            end
        end
    end
end





% 参数上下界

%% 优化目标函数
function [aera, sol] = FF(lambda, h, theta, V, mat)
    sol = TPDESolveFO(lambda, h, theta, V, [mat(1) mat(2) mat(3) mat(4) mat(5)]);
    aera = getAera(sol(:,15));
    
    function res = getAera(sol)
        peakTemp = max(sol);
        peakTime = find(sol==peakTemp);
        sol = sol(1:peakTime);
        count = sol(sol > 217 & sol <= peakTemp);
        [l,~] = size(count);
        res = sum(count) / 2 - (l / 2) * 217;
    end
end

%% 约束条件

function [success, flag] = Restrain(sol)
    flag = 0;
    [r1] = RestrainDiff(sol);
    [r2] = RestrainRising(sol);
    [r3] = RestrainPeakTime(sol);
    [r4] = RestrainPeakTemp(sol);
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
    
    if flag == 0
        success = true;
    else
        success = false;
    end
    
    function [res, valueMax, valueMin] = RestrainDiff(sol)
    % 斜率是否超过 3？
        tdiff = 2 * diff(sol);
        rising = tdiff(tdiff > 0);
        descending = tdiff(tdiff < 0);
        [rc,~] = size(rising(rising > 3));
        [dc,~] = size(descending(descending < -3));
        if rc ~= 0
            res = false;

        end
        %if dc ~= 0
           % res = false;

        %end
        valueMax = max(tdiff);
        valueMin = min(tdiff);
        res = true;
    end

    function [res, value] = RestrainRising(sol)
        % 升温时间是否符合要求？
        % 只考虑升温过程
        sol = sol(1:600);
        count = sol(sol > 150 & sol < 190);
        [t, ~] = size(count);
        if t / 2 > 60 && t / 2 < 120
            res = true;
        else
            res = false;
        end
        value = t / 2;
    end


    function [res, value] = RestrainPeakTime(sol)
        % 高温时间是否符合要求？

        count = sol(sol > 217);
        [t, ~] = size(count);
        if t / 2 > 40 && t / 2 < 90
            res = true;
        else
            res = false;
        end
        value = t / 2;
    end


    function [res, value] = RestrainPeakTemp(sol)
        % 峰值温度是否符合要求？
        mt = max(sol);
        if mt > 240 && mt < 250
            res = true;
        else
            res = false;
        end
        value = mt;
    end
end



