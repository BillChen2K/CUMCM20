
%% 使用最小二乘方拟合 lambda 和 h

global TfurCalced;
TfurCalced = false;
lambdaguess = 50;
hguess = 1500;
thetaguess = 10;
dt = 0.5;
% 优化参数
options=optimset('TolX',1e-5,'TolFun',1e-5,'MaxFunEvals',1200,'Display','iter');
expdata = xlsread('temp.xlsx');
t = 19:0.5:373; % 生成横向坐标
xdata = expdata(:,1);
xdata = (xdata - 19) * 2 + 1;
ydata = expdata(:,2);

% LSQ
[coef,~, residual] = lsqcurvefit(@(para, data) PDF_for_fitting(para, data), ...
    [lambdaguess, hguess, thetaguess], xdata, ydata, [30 1000 0], [100 5000 100], options);

lambdafit = coef(1)
hfit = coef(2)
thetafit = coef(3)


function r =  PDF_for_fitting(params, x)
%% 用于拟合的 PDF 函数
    res = TPDESolve(params(1), params(2), params(3), 70); % 70 = Velocity
    sol = res(:,15);
    sol = sol(19:728);
    r = sol(x);
end



