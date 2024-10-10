%% 导入库存数据
clear; close all;
filename = 'E:\MatlabProject\data\SVQ03001train2.csv';
data = readtable(filename);
PeriodStrings = string(data.Period);
Period = datetime(PeriodStrings, 'InputFormat', 'yyyyMM', 'Format', 'yyyy-MM');

%% 差分指数模型
yt = data.Demand;
m = length(yt);
alpha = [0.2 0.5 0.8];    % ~
n = length(alpha);

st = zeros(m, n);
st(1, 1:n) = (yt(1) + yt(2)) / 2;
ypl = zeros(m, n);
for i = 2:m
    dt = yt(i) - yt(i-1);  % 一次差分
    st(i, :) = alpha .* (yt(i-1) + dt) + (1 - alpha) .* st(i-1, :);  % 差分指数平滑
    ypl(i, :) = alpha .* (st(i-1, :) + dt) + (1 - alpha) .* st(i, :);
    ypl(ypl<0) = 0;
end
s = sqrt(mean(bsxfun(@minus, repmat(yt, 1, n), st).^2));
ypm = alpha .* (yt(m) + (yt(m) - yt(m-1))) + (1 - alpha) .* st(m, :);
yp = round(ypm);
for i = 1:n
    fprintf('当 alpha = %.1f 时，预测值为 %d，均方根误差为 %f\n', alpha(i), yp(i), s(i));
end

%% Plot data
figure(1);
plot(Period, yt, '.-', 'Color',  [0, 0.4470, 0.7410]);
legend('DES-Act');
hold on;
for j = 1:n
    plot(Period, ypl(:, j), 'LineWidth', 1.5, 'DisplayName', sprintf('Alpha = %.1f', alpha(j)));
end
% plot(Period(end), yp, 'o');
xlabel('时间（差分指数平滑）');
ylabel('需求量/个');
grid on;
legend();
hold off;  
