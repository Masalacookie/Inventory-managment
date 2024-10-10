ParticleScope = [0.1,10];
ParticleSize=2;
SwarmSize=20;
LoopCount=10;
opt=zeros(LoopCount,3);
MeanAdapt=zeros(1,LoopCount);
OnLine=zeros(1,LoopCount);
OffLine=zeros(1,LoopCount);
%控制显示2维以下粒子维数的寻找最优的过程
% DrawObjGraphic(ParticleSize,ParticleScope,AdaptFunc(XX,YY));
[ParSwarm,OptSwarm]=InitSwarm(SwarmSize,ParticleSize,ParticleScope);
 
%开始更新算法的调用
for k=1:LoopCount
%显示迭代的次数：
disp('----------------------------------------------------------')
TempStr=sprintf('第 %g次迭代',k);
disp(TempStr);
disp('----------------------------------------------------------')
 
%在测试函数图形上绘制初始化群的位置
 %if 2==ParticleSize
 % for ParSwarmRow=1:SwarmSize
  %  stem3(ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,2),ParSwarm(ParSwarmRow,5),'r.','markersize',8);
  %end
 %end
%暂停让抓图
% disp('开始迭代，按任意键：')
 %pause
 
%调用一步迭代的算法
 
[ParSwarm,OptSwarm]=BaseStepPso(ParSwarm,OptSwarm,ParticleScope,0.9,0.4,LoopCount,k);
 
% if 2==ParticleSize
 % for ParSwarmRow=1:SwarmSize
 %   stem3(ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,2),ParSwarm(ParSwarmRow,5),'r.','markersize',8);
 % end
 %end
 
t=OptSwarm(SwarmSize+1,1);
u=OptSwarm(SwarmSize+1,2);
YResult=AdaptFunc(t,u);
str=sprintf('%g步迭代的最优目标函数值%g',k,YResult);
disp(str);
%记录每一步的平均适应度
MeanAdapt(1,k)=mean(ParSwarm(:,2*ParticleSize+1));
end
 
%for循环结束标志
 
%记录最小与最大的平均适应度
MinMaxMeanAdapt=[min(MeanAdapt),max(MeanAdapt)];
%计算离线与在线性能
for k=1:LoopCount
 OnLine(1,k)=sum(MeanAdapt(1,1:k))/k;
 OffLine(1,k)=max(MeanAdapt(1,1:k));
end
 
for k=1:LoopCount
   OffLine(1,k)=sum(OffLine(1,1:k))/k;
end