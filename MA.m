%% 导入库存数据
filename = 'E:\MatlabProject\data\SVQ03001train.csv';
data = readtable(filename);
PeriodStrings = string(data.Period);
Period = datetime(PeriodStrings, 'InputFormat', 'yyyyMM', 'Format', 'yyyy-MM');
yt = data.Demand;
m = length(yt);
n = [2, 5];

%% MA body
yhat = cell(length(n), 1);
yp = zeros(length(n), 1);
s = zeros(length(n), 1);
for i=1:length(n)
    yhat{i} = zeros(m - n(i) + 1, 1);
    for j=1:m-n(i)+1
        yhat{i}(j)=sum(yt(j:j+n(i)-1))/n(i);
        
    end
    yp(i)=yhat{i}(end);
    s(i)=sqrt(mean((yt(n(i)+1:m)-yhat{i}(1:end-1)).^2));
end
for i = 1:length(n)
    fprintf('当N = %d时,预测值为 %d, 均方根误差为 %f\n', n(i), yp(i), s(i));
end

%% Plot data
figure(1);
plot(Period, yt, '.-', 'Color',  [0, 0.4470, 0.7410]);
legend('Actually');
hold on;
%{
for j = 1:length(n)
    plot(Period, yhat(:, j), 'LineWidth', 1.5, 'DisplayName', sprintf('N = %.1f', n(j)));
end
% plot(Period(end), yp, 'o');
%}
xlabel('Period');
ylabel('Demand');
grid on;
legend();
hold off;
