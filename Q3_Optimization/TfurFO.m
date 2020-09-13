function [tfur]  = TfurFO(t, mat, m, theta, velocity)
    furnaceLength = 30.5; % 熔炉长度
    furnaceGap = 5;  % 熔炉间隙
    edgeGap = 25; % 炉前与炉后
    V = velocity; % 速度， cm/min
    tempEnv = 25; % 环境温度
    
    t1 = mat(1);
    t2 = mat(2);
    t3 = mat(3);
    t4 = mat(4);
    t5 = mat(5);
    
    hf = 1e-4; % 炉间温度传播系数
    

    if t < 0.5
        t = 0.5;
    end
    
%     tempZone1 = tempMat()
%     tempZone2 = 195;
%     tempZone3 = 235;
%     tempZone4 = 255;
%     tempZone5 = 25;
    
    furnaceTemp = [repmat(t1, 1, 5) t2 t3 repmat(t4,1,2) repmat(t5, 1,2)];

    distance = V / 60 * t - edgeGap;
    
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
    
    
    
    return
    
    %% %%%%%%%%%%%%%
   
    
    if t < 0.5
        t = 0.5;
    end
    
    tempMat = TfurNew([tempEnv, t1, t2, t3, t4, t5], hf);
    distance = V / 60 * t + (furnaceLength + furnaceGap - edgeGap);
    furnaceTemp = tempMat(ceil(t * 2), 1:13);
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
    end
    Tfurdata(ceil(t * 2))= tfur;
    
        function [tfur] = TfurNew(mat, h)
        %% 考虑炉间热量传导的情况

        % if exist('dp.mat', 'file')
        %     load 'dp.mat' 'dp';
        %     tfur = dp;
        %     return;
        % end

        global dp;
        global TfurCalced;

        if TfurCalced
            tfur = dp;
            return;
        end


        % 13 * 800 矩阵
        tfur = zeros(800, 13);
        dp = zeros(800, 13);
        for i = 1 : 13
            if i == 1
                dp(1, i) = mat(1);
            elseif i <= 6
                dp(1, i) = mat(2);
            elseif i == 7
                dp(1, i) = mat(3);
            elseif i == 8
                dp(1, i) = mat(4);
            elseif i <= 10
                dp(1, i) = mat(5);
            else
                dp(1, i) = mat(6);
            end    
        end
        for i = 2 : 800
            for j = 1 : 13
                if j == 1
                    dp(i, j) = dp(i - 1, j) - h * nthroot((dp(i - 1, j) - dp(i - 1, j + 1)), 3);
                elseif j <= 12
                    dp(i, j) = dp(i - 1, j) - h * nthroot((dp(i - 1, j) - dp(i - 1, j + 1)), 3) - h * nthroot((dp(i - 1, j) - dp(i - 1, j - 1)), 3);
                else
                    dp(i, j) = dp(i - 1, j) - h * nthroot((dp(i - 1, j) - dp(i - 1, j - 1)), 3);
                end
            end
        end

        tfur = dp;
        TfurCalced = true;

        end
end


