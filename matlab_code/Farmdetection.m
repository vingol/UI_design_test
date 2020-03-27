function [Mfarm_Pred,Mfarm_Partition,Ch_Mfarm] = Farmdetection(farmsitting,testY_prediction,testreal,capp)
%风电场划分下 遍历集群预测
%这里应用Set Partition算法，将集合分为几个非空，交集为空，并集为全的子集之和形式，共有Bell个
%感谢MATLAB FILE中 Bruno Luong于2009年进行的算法贡献

%   Input： 
%   风电场的编号，farmsitting
%   预测结果，testY_prediction 按照风电场的编号的二进制进行划分，应该有2^N-1个
%   真实功率，testreal
%   风电集群装机容量，capp 所有的装机容量
%   
%   Output： 
%   风电集群的组合预测，Mfarm_Pred
%   风电集群的对应组合，Mfarm_Partition
%   风电集群的预测效果，Ch_Mfarm 每一列代表1个组合的16步预测，每1行表示预测时间尺度
%% 数据预处理
 N=length(farmsitting);   %计算风电集群的维数
 Bel=Bell(N);          %风电集群组合维数
 Mfarm_Partition=SetPartition(farmsitting);  %给出所有风电集群组合，其中数字代表风电场的编号
 Index=SetPartition(N:-1:1);     %这里默认farmsitting的编号是从后往前为1,2,3,4,5 这里与早期编号一致
 Mfarm_Pred=struct('RMSE',zeros(Bel,1),'MAPE',zeros(Bel,1),'MSE',zeros(Bel,1),'MAE',zeros(Bel,1)); %Mfarm_prediction,记录每次的预测结果
  Ch_Mfarm=struct('RMSE',zeros(Bel,16),'MAPE',zeros(Bel,16),'MSE',zeros(Bel,16),'MAE',zeros(Bel,16)); %Mfarm_prediction,记录每次的预测结果



%% 数据整理测试
   for i=1:Bel  %i表示遍历风电集群的个数
       prediction=zeros(16,size(testreal,2));   %size(testreal,2)是所有的测试样本
       for j=1:size(Index{i},2)  %判断每一个场群划分策略有多少个子联盟
            prediction=prediction+testY_prediction{sum(2.^(Index{i}{j}-1))}; 
       end
       err_test=testreal-prediction;     %当前集群预测值和实际值的误差
       
        %测试结果
        testNum   =numel(err_test);
        
        testResult.test_RMSE =sqrt(sum(sum(err_test.^2))/testNum)/sum(capp(farmsitting));
        testResult.test_MAE  =sum(sum(abs(err_test)))/testNum;
        testResult.test_MAPE =sum(sum(abs(err_test./sum(capp(farmsitting)))))/testNum;
        testResult.test_MSE  =sum(sum(err_test.^2))/testNum;
        testResult.test_errMAX =max(abs(err_test));

        Mfarm_Pred.RMSE(i)=testResult.test_RMSE; %记录每一种组合的预测值
        Mfarm_Pred.MAPE(i)=testResult.test_MAPE; %记录每一种组合的预测值
        Mfarm_Pred.MSE(i)=testResult.test_MSE; %记录每一种组合的预测值  
        Mfarm_Pred.MAE(i)=testResult.test_MAE; %记录每一种组合的预测值 
   
        for j=1:size(err_test,1)   %j是每一个时间尺度
            ChildtestNum   =size(err_test,2);
            
            Ch_testResult(j).RMSE =sqrt(sum(err_test(j,:).^2)/ChildtestNum)/sum(capp(farmsitting));
            Ch_testResult(j).MAE  =sum(abs(err_test(j,:)))/ChildtestNum;
            Ch_testResult(j).MAPE =sum(abs(err_test(j,:))./sum(capp(farmsitting)))/ChildtestNum;
            Ch_testResult(j).MSE  =sum(sum(err_test(j,:).^2))/ChildtestNum;
            Ch_testResult(j).MAX  =max(err_test(j,:));
            Ch_testResult(j).MIN  =-max(-err_test(j,:));
            
            Ch_Mfarm.RMSE(i,j)=Ch_testResult(j).RMSE; %记录每一种组合的预测值
            Ch_Mfarm.MAPE(i,j)=Ch_testResult(j).MAPE; %记录每一种组合的预测值
            Ch_Mfarm.MSE(i,j)=Ch_testResult(j).MSE; %记录每一种组合的预测值  
            Ch_Mfarm.MAE(i,j)=Ch_testResult(j).MAE; %记录每一种组合的预测值 
        end 
   end  
end

