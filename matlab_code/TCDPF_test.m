function [Better_Pred,Mfarm_Pred_Better,Ch_test_Better,Better_code,Mfarm_Partition_all] = TCDPF_test(Power,capp,K)
%TCDPF_test: 动态划分预测的测试函数，需要输入外部数据（powermatrix）,聚类个数(maxcluster)
%动态平均时间尺度K,特征输入时延lookback
%建议测试样本与训练样本紧挨
%   此处显示详细说明
load ('TCDPF_TrainedReuslt.mat')

tic
farmsitting=1:size(Power,2);  %准备比较组合的风电场组合 %1,2,3,5,6,9,10；；1,2,3,4,6,9,10

%% 循环前参数设置
% time=[30001:31000,13001:13500];                    %时间参数
% %lookback=4;           %时间尺度，预测多少个点以后的值,实际上是一共有多少个输入
% trainNum1 = 1000;                    %576=24天*24小时
% data_M=length(time);             %数据量
% testNum1 = data_M-trainNum1;         %168=7天*24小时，测试集是总体样本减去训练集


PowerClass=[]; CappClass=[];
for i=1:length(Tstar)
    PowerClass=[PowerClass,sum(Power(:,Tstar{i}),2)];
    CappClass=[CappClass;sum(capp(Tstar{i}))];  %分别计算已经划分好子集群的功率和与容量和
end

farmCluster=1:length(Tstar);  %新的子集群的编号

B=ff2n(length(farmCluster));
[m n]=find(B'==1);    %find 对于矩阵是按列进行计算的，m和n分别表示对应的行列
WPC=cell(2^length(farmCluster)-1,1); % 出除空集的情况，包括全部集的情况 2^n
for i=2:2^length(farmCluster)
    D=find(n==i);  %第i个子集中的非零元素
    WPC{i-1}=(farmCluster(m(D)));  %所有对应的风电场编号融入风电集群编号中WPC
end

farmCluster1=length(farmCluster):-1:1;
WPCS=cell(2^length(farmCluster)-1,1); % 出除空集的情况，包括全部集的情况 ,按照风电场从前到后排列
for i=2:2^length(farmCluster1)
    D=find(n==i);  %第i个子集中的非零元素
    WPCS{i-1}=(farmCluster1(m(D)));  %所有对应的风电场编号融入风电集群编号中WPC
end



%% 计算结果存放
testY_prediction=cell(2^length(farmCluster)-1,1); %用cell记录每次预测的结果

for group=1:2^length(farmCluster)-1
    farm=WPC {group};  %选入的编号
    dataset=sum(PowerClass(:,farm),2);
%    MaxPower(group)=max(dataset);   %记录最大值
    
    %划分输入组和输出期望值
    [scaler_testX,scaler_testY]=Divide(dataset,lookback+1:size(Power,1)-15,lookback,ps_data);
  %% 选取训练组、测试组（可随机，待数据组合好之后  ，见下面）
    testY_scalerPre=zeros(16,size(scaler_testX,2)); %记录每个时间尺度每个样本下的预测结果
    Model=cell(16,1);
    for steps=1:16
        Mdl=SVMModel{steps,group};
        testY_scalerPre(steps,:)= predict(Mdl,scaler_testX');  %新版本需要后面加一个‘-b 0’表示输出,而且输出要加三个参数
    end
    %% 数据整理测试
    testY_pre=mapminmax('reverse',testY_scalerPre,ps_data);
    testY_real=mapminmax('reverse',scaler_testY,ps_data);
    errTest=testY_real-testY_pre;
    testScore=sqrt(sum(sum(errTest.^2))/numel(errTest));              %RMSE误差
    imf_test=testY_pre;
    testreal=testY_real;
    testY_prediction{group}= imf_test;   %记录每次计算的结果
    err_test=testreal-imf_test;

%%     总的结果  训练结果
        testNum   =numel(err_test);
        
        testResult.test_RMSE =sqrt(sum(sum(err_test.^2))/testNum)/sum(CappClass(farm));
        testResult.test_MAE  =sum(sum(abs(err_test)))/testNum;
        testResult.test_MAPE =sum(sum(abs(err_test./sum(CappClass(farm)))))/testNum;
        testResult.test_MSE  =sum(sum(err_test.^2))/testNum;  
              
%%      分项结果
        for i=1:size(err_test,1)
            ChildtestNum   =size(err_test,2);
            Ch_testResult(i).RMSE =sqrt(sum(err_test(i,:).^2)/ChildtestNum)/sum(CappClass(farm));
            Ch_testResult(i).MAE  =sum(abs(err_test(i,:)))/ChildtestNum;
            Ch_testResult(i).MAPE =sum(abs(err_test(i,:))./sum(CappClass(farm)))/ChildtestNum;
            Ch_testResult(i).MSE  =sum(sum(err_test(i,:).^2))/ChildtestNum;          
        end      
end
%% 比较不同风电场组合下的整体风电集群的最大值
    [scaler_testX,testreal]=Divide(sum(PowerClass,2),lookback+1:size(Power,1)-15,lookback);
    timematrix=toc;    
    [Mfarm_Pred,Mfarm_Partition,Ch_Mfarm] = Farmdetection(farmCluster,testY_prediction,testreal,CappClass);
    [Mfarm_Pred_Best,testb_code,Best_Pred,Ch_test_Best] = Childsample(farmCluster,testY_prediction,testreal,CappClass);
    [Mfarm_Pred_Better,Better_code,Better_Pred,Ch_test_Better,Pred_sorting] = AutoPredict(farmCluster,testY_prediction,testreal,CappClass,K);
    fprintf('%d Partitions are considered and use  %f s \n',Bell(maxcluster),timematrix);
    Mfarm_Partition_all=Mfarm_Partition;
    for i=1:Bell(maxcluster)
        for j=1:length(Mfarm_Partition{i})
            temp_cell=[];
            for p=1:length(Mfarm_Partition{i}{j})
                temp_cell=[temp_cell,Tstar{Mfarm_Partition{i}{j}(p)}];
            end
            Mfarm_Partition_all{i}{j}=sort(temp_cell);
        end
    end
end

