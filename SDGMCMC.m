%% 通过马尔可夫链蒙特卡罗 (MCMC) 生成合成数据
% MCMC 方法，例如 Metropolis-Hastings 和 Gibbs 采样，从目标生成样本
% 通过基于条件概率迭代更新状态来生成分布。

%% Load the dataset
clear;close all;
filename = 'E:\MatlabProject\data\SVQ03001train.csv';
data = readtable(filename);
PeriodStrings = string(data.Period);
Period = datetime(PeriodStrings, 'InputFormat', 'yyyyMM','Format','yyyyMM');
NF=size(data); row=NF(1); rank=NF(2);

%% MCMC Body
y=data.Demand;
num = numel(y);
target_mean = mean(y);target_std = std(y);    % ~
% Parameters for the Metropolis-Hastings algorithm
num_samples = num; % 要生成的合成数据点的数量
burn_in = 100000;      % burn-in迭代次数
proposal_std = std(y);  % 初始分布的标准差
current_state = mean(y); % 初始化马尔科夫链
synthetic_data = zeros(1, num_samples);% 预分配数组用于存储生成的样本

% Metropolis-Hastings algorithm
for t = 1:num_samples + burn_in
    proposed_state = current_state + proposal_std * randn();% 从当前分布中提出一个新的状态
    % Calculate acceptance ratio
    current_likelihood = normpdf(current_state, target_mean, target_std);
    proposed_likelihood = normpdf(proposed_state, target_mean, target_std);
    acceptance_ratio = min(1, proposed_likelihood / current_likelihood);
    % Accept or reject the proposed state
    if rand() < acceptance_ratio
        current_state = proposed_state;
    end
    
    % Store samples after burn-in
    if t > burn_in
        synthetic_data(t-burn_in) = current_state;
        syn(:,1)=synthetic_data;
        syn(syn<0)=0;syn=round(syn);
        s = sqrt(mean(bsxfun(@minus, y, syn).^2));
        if s^2<target_std
            syn(t-burn_in) = syn;
        else
            syn(t-burn_in) = 0;
        end
    end

end
s
mean=mean(syn)
std=std(syn)

%% Plot data
figure('units','normalized','outerposition',[0 0 1 1]);
plot(Period, y, 'o-', 'LineWidth', 1.5, 'MarkerSize', 10, 'Color',  [0, 0.4470, 0.7410]);
hold on;
plot(Period, syn, 'd-', 'LineWidth', 1.5, 'MarkerSize', 10);
xlabel('时间/月');ylabel('需求量/个');
grid on;
legend('Actually','Synthetic');
hold off;
