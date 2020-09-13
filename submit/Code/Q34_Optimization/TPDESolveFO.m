function [result] = TPDESolve(lambdaguess, hguess, thetaguess, velocity, tempMat) 
%% 使用 pdepe 求解元件温度的微分方程

% 参数配置
Tenv = 25; % 环境温度
V = velocity; % 传送速度
alpha = 3.2; % 物体长度 cm

% 物理参数
rho = 7.874; % 密度
C = 480; % 比热容
lambda = lambdaguess; % 导热系数
% h = lambda / (alpha / 100);
h = hguess;  % 对流换热系数;
x = linspace(0, alpha, 30);
t = linspace(0, 400, 800);
m = 0;

sol = pdepe(m, @TPDE, @TPDE_IC, @TPDE_BC, x, t);
hold off;
grid on;
plot(t, sol(:,15), 'LineWidth', 1)
title('PDE 数值解');

result = sol;

    %% PDF
    
    % PDE 方程
    function [c, f, s] = TPDE(x, t, T, dudx)
        % 转换为标准 PDE
        c = rho * C / lambda;
        f = dudx;
        s = 0;
    end
    
    % PDE 初始条件
    function T0 = TPDE_IC(x)
        % Initial Condition
        T0 = Tenv;
    end
    
    % PDE 边界值
    function [pl, ql, pr, qr] =  TPDE_BC(xl, ul, xr, ur, t)

%         pl = h * Tfur2D(t, ul, thetaguess, V) - h * ul;
        pl = h * TfurFO(t, tempMat, ul, thetaguess, V) - h * ul;
        ql = lambda;
%         pr = h * ur - h * Tfur2D(t - alpha / V, ur, thetaguess, V);
        pr = h * ur - h * TfurFO(t - alpha / V, tempMat, ul, thetaguess, V);
        qr = lambda;
    end
end


