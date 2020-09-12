
%% 使用最小二乘方拟合 lambda 和 h

    lambdaguess = 50;
    hguess = 1500;
    dt = 0.1;
    % 优化参数
    options=optimset('TolX',1e-5,'TolFun',1e-5,'MaxFunEvals',1200,'Display','iter');
    expdata = xlsread('temp.xlsx');
    t = 19:0.5:373; % 生成横向坐标
    xdata = expdata(:,1);
    xdata = (xdata - 19) * 2 + 1;
    ydata = expdata(:,2);
    
    % LSQ
    [coef,~, residual] = lsqcurvefit(@(para, data) PDF_for_fitting(para, data), ...
        [lambdaguess, hguess], xdata, ydata, [30 1000], [100 5000], options);
    
    lambdafit = coef(1)
    hfit = coef(2)

    function r =  PDF_for_fitting(params, x)
    %% 用于拟合的 PDF 函数
        res = TPDESolve(params(1), params(2), 70); % 70 = Velocity
        sol = res(:,15);
        sol = sol(19:728);
        r = sol(x);
    end



