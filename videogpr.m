%% 导入库存数据
clear; close all;
filename = 'E:\MatlabProject\data\SVQ03001data.csv';
data = readtable(filename);
PeriodStrings = string(data.Period);
Period = datetime(PeriodStrings, 'InputFormat', 'yyyyMM', 'Format', 'yyyy-MM');

%% 数据处理
yt = data.Demand;
trainX = (1:69)';
testX = (70:78)';
trainY = yt(1:69);
testYreal = yt(70:78);
m = length(testYreal);

%% GPR模型
v = VideoWriter('gpr_iteration_process.mp4', 'MPEG-4');
open(v);
% 设置图形窗口大小
figure('Position', [0, 0, 590, 540]);

% 初始化 GPR 模型
gprMdl = fitrgp(trainX, trainY, ...
    'KernelFunction', 'matern32', 'BasisFunction', 'pureQuadratic', ...
    'FitMethod', 'sr', 'PredictMethod', 'fic', ...
    'Standardize', true, 'ComputationMethod', 'v', ...
    'ActiveSetMethod', 'likelihood', 'Optimizer', 'quasinewton', ...
    'OptimizeHyperparameters', 'auto');
% 定义迭代次数
numIterations = 30;
% 迭代过程
for iter = 1:numIterations
    [pred_demand,~,limit] = predict(gprMdl,testX);%pred_demand预测值，limit为上限和下限
    % 将当前图像帧添加到视频中
    frame = getframe(gcf);
    writeVideo(v, frame);
    % 更新 GPR 模型
    gprMdl = fitrgp(trainX, trainY, 'KernelFunction', 'matern32', ...
        'BasisFunction', 'pureQuadratic', 'FitMethod', 'sr', ...
        'PredictMethod', 'fic', 'Standardize', true, ...
        'ComputationMethod', 'v', 'ActiveSetMethod', 'likelihood', ...
        'Optimizer', 'quasinewton', 'OptimizeHyperparameters', 'auto');
end
% 关闭 VideoWriter 对象
close(v);

limit=round(limit);
limit(limit<0)=0;
Lower=limit(:,1);
Upper=limit(:,2);

%% 计算误差和准确率
erravg=sum(abs(pred_demand-testYreal))/m;
fprintf('预测未来%d个月需求量的平均绝对误差为 %f\n', m,erravg);
y3=(testYreal-Lower>=0)&(Upper-testYreal>=0);
errarea=sum(y3)/length(y3);
fprintf('实际需求量在预测上下限区间的概率为 %.2f\n',errarea);

%% Plot data
figure('units','normalized','outerposition',[0 0 1 1]);
plot(trainX,trainY,'o-','LineWidth', 1.5,'MarkerSize', 5, 'Color', 'b');
xlabel('时间/月');
ylabel('需求量/个');
hold on;
plot(testX,testYreal,'o-','LineWidth', 1.5,'MarkerSize', 5, 'Color', 'g');
plot(testX,pred_demand,'d-','LineWidth', 2,'MarkerSize', 5, 'Color', 'm');
fill([testX;flipud(testX)], [Lower;flipud(Upper)],[0.93333, 0.83529, 0.82353],'edgealpha', '0', 'facealpha', '.5');
grid on;
legend('历史需求','实际需求','预测需求','最低库存');
hold off;
