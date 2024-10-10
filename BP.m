num=31;
len=9;
data=xlsread('data_out');
data=data(2:len+1,:);

%����ѵ�������Լ�
x_train=[data(1:len-2,:).'];
x_test=[data(len-1,:).'];
y_train=[data(2:len-1,:).'];
test=[data(len,:).'];

%����BP������
net=newff(minmax(x_train),[7,31],{'tansig','purelin'},'trainlm');%������Ԫ�������������Ԫ����,��1������Ϊ������������뷶Χ
% net = feedforwardnet([7,31],'trainlm');
%����ѵ������
net.trainParam.epochs = 100;
%�����������
net.trainParam.goal=0.001;
%ѵ������
[net,tr]=train(net,x_train,y_train);
%��ѵ�����Ͳ��Լ��ϵı���
y_train_predict=sim(net,x_train);
Predict=sim(net,x_test);

x=0:1:30;
plot(x,x_test,x,Predict);
grid on;
xlabel('ʱ��'),ylabel('������');
legend('ʵ��ֵ','Ԥ��ֵ');

rmse=(sum((Predict-test).^2)/31)^0.5;
mae=sum(abs(Predict-test))/31;
mape=sum(abs(Predict-test)./test)/31*100;

