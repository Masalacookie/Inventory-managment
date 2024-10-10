num=31;
len=9;
data=xlsread('data_out');
data=data(2:len+1,:);

%建立训练集测试集
x_train=[data(1:len-2,:).'];
x_test=[data(len-1,:).'];
y_train=[data(2:len-1,:).'];
test=[data(len,:).'];

%创建BP神经网络
net=newff(minmax(x_train),[7,31],{'tansig','purelin'},'trainlm');%隐层神经元个数，输出层神经元个数,第1个参数为测试输入的输入范围
% net = feedforwardnet([7,31],'trainlm');
%设置训练次数
net.trainParam.epochs = 100;
%设置收敛误差
net.trainParam.goal=0.001;
%训练网络
[net,tr]=train(net,x_train,y_train);
%在训练集和测试集上的表现
y_train_predict=sim(net,x_train);
Predict=sim(net,x_test);

x=0:1:30;
plot(x,x_test,x,Predict);
grid on;
xlabel('时间'),ylabel('出库量');
legend('实际值','预测值');

rmse=(sum((Predict-test).^2)/31)^0.5;
mae=sum(abs(Predict-test))/31;
mape=sum(abs(Predict-test)./test)/31*100;

