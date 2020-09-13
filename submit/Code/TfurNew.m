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