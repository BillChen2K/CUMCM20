%% 使用最小二乘方拟合 lambda 和 h

dt = 0.1;
% 优化参数
options=optimset('TolX',1e-5,'TolFun',1e-5,'MaxFunEvals',1200,'Display','iter');
expdata = xlsread('temp.xlsx');
t = 19:0.5:373;

