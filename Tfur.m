function [tfur]  = Tfur(t)
    furnaceLength = 30.5; % 熔炉长度
    furnaceGap = 5;  % 熔炉间隙
    edgeGap = 25; % 炉前与炉后
    V = 78; % 速度， cm/min
    
    tempEnv = 25; % 环境温度
    
    
     t1 = 175; % 附件 - 拟合实验温区温度配置
     t2 = 195;
     t3 = 235;
     t4 = 255;
     t5 = 25;

     
%     t1 = 173; % Q1 - 预测温区温度配置
%     t2 = 198;
%     t3 = 230;
%     t4 = 257;
%     t5 = 25;
        
    
%     t1 = 182; % Q2 - 制程界限温区温度配置
%     t2 = 203;
%     t3 = 237;
%     t4 = 254;
%     t5 = 25;
    
    hf = 0.00002; % 炉间温度传播系数
    
    if t < 0.5
        t = 0.5;
    end
    
    tempMat = TfurNew([tempEnv, t1, t2, t3, t4, t5], hf);
% 
%     tempZone1 = tempMat()
%     tempZone2 = 195;
%     tempZone3 = 235;
%     tempZone4 = 255;
%     tempZone5 = 25;
    
%     furnaceTemp = [repmat(tempZone1, 1, 5) tempZone2 tempZone3 ...
%         repmat(tempZone4,1,2) repmat(tempZone5, 1,2)];

    distance = V / 60 * t - edgeGap;
    furnaceTemp = tempMat(ceil(t * 2), 2:12);
    if distance < 0
        tfur = tempEnv;
        return
    end
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
%         tfur = 25;
    end
end




