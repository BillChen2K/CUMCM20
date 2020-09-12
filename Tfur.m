function [tfur]  =Tfur(t)
    furnaceLength = 30.5; % 熔炉长度
    furnaceGap = 5;  % 熔炉间隙
    edgeGap = 25; % 炉前与炉后
    V = 70; % 速度， cm/min

    % 默认温度：
    % furnaceTemp = [175, 175, 175, 175, 175, 195, 235, 255, 255, 25, 25];

    tempEnv = 25; % 环境温度

    % 温区温度配置
    tempZone1 = 175;
    tempZone2 = 195;
    tempZone3 = 235;
    tempZone4 = 255;
    tempZone5 = 25;
    furnaceTemp = [repmat(tempZone1, 1, 5) tempZone2 tempZone3 ...
        repmat(tempZone4,1,2) repmat(tempZone5, 1,2)];

    distance = V / 60 * t - edgeGap;
    fCount = ceil(distance / (furnaceLength + furnaceGap));
    fCount(fCount < 1) = 1;
    dd = distance - (furnaceLength + furnaceGap) * (fCount - 1);
    if dd <= furnaceLength
        tfur = furnaceTemp(fCount);
    else
        if(fCount < 11)
            tfur = (furnaceTemp(fCount) + furnaceTemp(fCount + 1)) / 2;
        else
            tfur = tempEnv;
        end
    end
end




