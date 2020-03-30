function [Mfarm_Pred_Best,bestcode,Best_Pred,Ch_test_Best] = Childsample(farmsitting,testY_prediction,testreal,capp)
%划分对于不同超前预测的时间尺度，计算每一次预测中的最优组合（child-不同时间尺度;sample-以样本为单位）
%这里应用Set Partition算法，将集合分为几个非空，交集为空，并集为全的子集之和形式，共有Bell个
%感谢MATLAB FILE中 Bruno Luong于2009年进行的算法贡献

%   Input： 
%   风电场的编号，farmsitting
%   预测结果，testY_prediction 按照风电场的编号的二进制进行划分，应该有2^N-1个
%   真实功率，testreal
%   风电集群装机容量，capp 所有的装机容量
%   
%   Output： 
%   风电集群的最优组合预测结果，Mfarm_Pred_Best
%   风电集群的每一个样本和每一个预测时间尺度下的最优组合的代码，bestcode
%   风电集群每一个最优组合下得到的实际预测结果: Best_Pred
%   风电集群按照预测时间尺度划分，每个预测时间尺度下得到的最优预测结果：Ch_test_Best 

%% 数据预处理
 N=length(farmsitting);   %计算风电集群的维数
         if iscell(farmsitting) %如果输入的是一个cell型数据
            H=[];
            for i=1:N
                H=[H,farmsitting{i}];
            end
            farmsitting=H;   %这是为了后面的功率计算做准备的
            clear H
        end
 Bel=Bell(N);          %风电集群组合维数
% Mfarm_Partition=SetPartition(farmsitting);  %给出所有风电集群组合，其中数字代表风电场的编号
 Index=SetPartition(N:-1:1);     %这里默认farmsitting的编号是从后往前为1,2,3,4,5 这里与早期编号一致
 Mfarm_Pred_Best=struct('RMSE',zeros(1,1),'MAPE',zeros(1,1),'MSE',zeros(1,1),'MAE',zeros(1,1)); %Mfarm_Pred_Best,记录联盟最优的预测结果
% err_test=zeros(16,size(testreal,2),Bel);     %err_test 表示所有的组合误差
 prediction=zeros(16,size(testreal,2),Bel);   %predcition 表示所有的组合测试结果
% bestcode=zeros(16,size(testreal,2));     %记录每个超前步数下，每个样本的最优组合编号
 Best_Pred=zeros(16,size(testreal,2));     %记录每一个样本，每一个超前预测尺度下最优的预测结果
 Ch_test_Best=struct('RMSE',zeros(16,1),'MAPE',zeros(16,1),'MSE',zeros(16,1),'MAE',zeros(16,1));  %Mfarm_prediction,记录每个超前步数下联盟最优的预测结果
 %% 数据整理测试
   for i=1:Bel  %i表示遍历风电集群的个数      
       for j=1:size(Index{i},2)  %判断每一个场群划分策略有多少个子联盟
            prediction(:,:,i)=prediction(:,:,i)+testY_prediction{sum(2.^(Index{i}{j}-1))}; 
       end
   end
   batchsize=50;
   if size(testreal,2)<=batchsize  %判断输入的数据长度是否过长
      err_test=repmat(testreal,1,1,Bel)-prediction;     %当前集群预测值和实际值的误差
      [~,code]=sort(abs(err_test),3);    %计算最小的误差，并用bestcode表示对应的编号
       bestcode=code(:,:,1);   %最好的一组解
%      [~,bestcode]=min(abs(err_test),[],3);    %计算最小的误差，并用bestcode表示对应的编号
   else   %假如长度过长,需要分批计算
       tempcode=[]; %分批计算时分别存储最优的code
       for batch=1:floor(size(testreal,2)/batchsize)
           err_test=repmat(testreal(:,batchsize*(batch-1)+1:batchsize*batch),1,1,Bel)-prediction(:,batchsize*(batch-1)+1:batchsize*batch,:);     %当前集群预测值和实际值的误差
           [~,code]=sort(abs(err_test),3);    %计算最小的误差，并用bestcode表示对应的编号
           tempcode=[tempcode,code(:,:,1)];   %最好的一组解           
       end
       if mod(size(testreal,2),batchsize)~=0 %假设最后的计算结果不能被500整分
           err_test=repmat(testreal(:,batchsize*floor(size(testreal,2)/batchsize)+1:size(testreal,2)),1,1,Bel)-prediction(:,batchsize*floor(size(testreal,2)/batchsize)+1:size(testreal,2),:);     %当前集群预测值和实际值的误差
           [~,code]=sort(abs(err_test),3);    %计算最小的误差，并用bestcode表示对应的编号
           tempcode=[tempcode,code(:,:,1)];   %最好的一组解
           bestcode=tempcode;
       else
           bestcode=tempcode;
       end      
   end

clear err_test   %这个变量太大了，赶快去掉
   for i=1:16     %计算每个对应的最小的组合
       for j=1:size(testreal,2)
      Best_Pred(i,j)=prediction(i,j,bestcode(i,j)); %每个最优的组合的结果都输入Best_Pred中
       end
   end
   clear prediction
   err_test=testreal-Best_Pred;   %注意这里是新的err_test，进行一步计算
   testNum   =numel(err_test);
        
        testResult.test_RMSE =sqrt(sum(sum(err_test.^2))/testNum)/sum(capp(farmsitting));
        testResult.test_MAE  =sum(sum(abs(err_test)))/testNum;
        testResult.test_MAPE =sum(sum(abs(err_test./sum(capp(farmsitting)))))/testNum;
        testResult.test_MSE  =sum(sum(err_test.^2))/testNum;
        testResult.test_errMAX =max(abs(err_test));

        Mfarm_Pred_Best.RMSE=testResult.test_RMSE; %记录每一种组合的预测值
        Mfarm_Pred_Best.MAPE=testResult.test_MAPE; %记录每一种组合的预测值
        Mfarm_Pred_Best.MSE=testResult.test_MSE; %记录每一种组合的预测值  
        Mfarm_Pred_Best.MAE=testResult.test_MAE; %记录每一种组合的预测值 
        
        
         for i=1:size(err_test,1)
            ChildtestNum   =size(err_test,2);

            Ch_test_Best.RMSE(i) =sqrt(sum(err_test(i,:).^2)/ChildtestNum)/sum(capp(farmsitting));
            Ch_test_Best.MAE(i)  =sum(abs(err_test(i,:)))/ChildtestNum;
            Ch_test_Best.MAPE(i) =sum(abs(err_test(i,:))./sum(capp(farmsitting)))/ChildtestNum;
            Ch_test_Best.MSE(i)  =sum(sum(err_test(i,:).^2))/ChildtestNum;

        end
   
end

 %测试结果
        