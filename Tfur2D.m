function [tfur]  = Tfur(t, m, theta, velocity)
global Tfurdata;
    furnaceLength = 30.5; % 熔炉长度
    furnaceGap = 5;  % 熔炉间隙
    edgeGap = 25; % 炉前与炉后
    if (nargin < 4)
        % 指定默认速度
        V = 70;
    else
        V = velocity; % 速度， cm/min
    end
    tempEnv = 25; % 环境温度
    
     % 附件 - 拟合实验温区温度配置
%       t1 = 175; 
%       t2 = 195;
%       t3 = 235;
%       t4 = 255;
%       t5 = 25;
     
     % Q1 - 预测温区温度配置
%     t1 = 173; 
%     t2 = 198;
%     t3 = 230;
%     t4 = 257;
%     t5 = 25;
        
    % Q2 - 制程界限温区温度配置
     t1 = 182; 
     t2 = 203;
     t3 = 237;
     t4 = 254;
     t5 = 25;
    
    hf = 1e-4; % 炉间温度传播系数
    
    
    if t < 0.5
        t = 0.5;
    end
    
    tempMat = TfurNew([tempEnv, t1, t2, t3, t4, t5], hf);
    distance = V / 60 * t + (furnaceLength + furnaceGap - edgeGap);
    furnaceTemp = tempMat(ceil(t * 2), 1:13);

%     if distance < 0
%         tfur = furnaceTemp(1);
%         return
%     end
    fCount = ceil(distance / (furnaceLength + furnaceGap));
    fCount(fCount < 1) = 1;
    dd = distance - (furnaceLength + furnaceGap) * (fCount - 1);
    if(fCount < 11)
        if dd <= furnaceLength
            tfur = furnaceTemp(fCount);
        else
            tfur = (furnaceTemp(fCount) + furnaceTemp(fCount + 1)) / 2;
        end
    else
        tfur = furnaceTemp(11);
    end
    if(fCount > 10)
          tfur = theta * nthroot((m - tfur), 3) + tfur;
%         tfur = theta * (m - tfur) ^ 2 + tfur;
    end
    Tfurdata(ceil(t * 2))= tfur;
%     furnaceTemp = furnaceTemp + (m - furnaceTemp) * theta;
%    furnaceTemp = furnaceTemp .* theta .* exp(m ./ furnaceTemp - 1);
end




