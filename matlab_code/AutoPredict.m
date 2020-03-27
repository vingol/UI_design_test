function [Mfarm_Pred_Better,Pred_Code,Better_Pred,Ch_test_Better,Pred_Sorting] = AutoPredict(farmsitting,testY_prediction,testreal,capp,K)
%根据最新数据计算最优预测划分水平，最近步数可以改变
%这里应用Set Partition算法，将集合分为几个非空，交集为空，并集为全的子集之和形式，共有Bell个
%感谢MATLAB FILE中 Bruno Luong于2009年进行的算法贡献

%   Input：
%   风电场的编号，farmsitting
%   预测结果，testY_prediction 按照风电场的编号的二进制进行划分，应该有2^N-1个
%   真实功率，testreal
%   风电集群装机容量，capp 所有的装机容量
%   判断超前步数： K
%
%   Output：
%   风电集群的预测较优组合预测结果，Mfarm_Pred_Better
%   风电集群的每一个样本和每一个预测时间尺度下的预测组合的编码，Pred_Code
%   风电集群每一个最优组合下得到的真实预测结果: Better_Pred
%   风电集群按照预测时间尺度划分，每个预测时间尺度下得到的较优预测结果：Ch_test_Better
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
Mfarm_Pred_Better=struct('RMSE',zeros(1,1),'MAPE',zeros(1,1),'MSE',zeros(1,1),'MAE',zeros(1,1)); %Mfarm_Pred_Best,记录联盟最优的预测结果
% err_test=zeros(16,size(testreal,2),Bel);     %err_test 表示所有的组合误差
prediction=zeros(16,size(testreal,2),Bel);   %predcition 表示所有的组合测试结果
% bestcode=zeros(16,size(testreal,2));     %记录每个超前步数下，每个样本的最优组合编号
Better_Pred=zeros(16,size(testreal,2)-(K+16-1));     %记录每一个样本，每一个超前预测尺度下最优的预测结果
Ch_test_Better=struct('RMSE',zeros(16,1),'MAPE',zeros(16,1),'MSE',zeros(16,1),'MAE',zeros(16,1)); %Mfarm_prediction,记录每个超前步数下联盟最优的预测结果
Pred_Code=zeros(16,size(testreal,2)-(K+16-1));   %记录每一组计算结果的最优值

%% 数据整理测试
    for i=1:Bel  %i表示遍历风电集群的个数
        for j=1:size(Index{i},2)  %判断每一个场群划分策略有多少个子联盟
            prediction(:,:,i)=prediction(:,:,i)+testY_prediction{sum(2.^(Index{i}{j}-1))};
        end
    end
    err_test=repmat(testreal,1,1,Bel)-prediction;     %当前集群预测值和实际值的误差
 %   [~,bestcode]=min(abs(err_test),[],3);    %计算最小的误差，并用bestcode表示对应的编号

    steping=1;   %观察超前预测尺度
    err_detect=zeros(Bel,size(testreal,2));  %设计某一个预测步数下比较不同模型的误差水平
    for j=1:size(testreal,2)
    err_detect(:,j)=err_test(steping,j,:);
    end
    
    for i=1:16     %计算每个对应的最小的组合
        H=1;    %H用来计数
        for j=K+16:size(testreal,2)    %放弃前面K+15组数据，单纯作为判断的结果（验证集）
            errK_temp=sum(abs(err_test(i,j-K-(i-1):j-i,:)),2);   %按列相加 这里编号复杂主要原因是不同时间尺度的结构不同
            %errK_temp=sum((err_test(i,j-K-(i-1):j-i,:).^2),2);
            [~,code_temp]=min(errK_temp,[],3);   %此时最优的编号
            Pred_Code(i,H)=code_temp;    %存放预测最优编号
            if i==1
            [~,code_temp1]=sort(errK_temp(:));   %此时最优的编号
            Pred_Sorting(:,H)=code_temp1;
            end
            H=H+1;
        end
    end
    clear err_test   %这个变量太大了，赶快去掉
    for i=1:16     %计算每个对应的最小的组合
        H=1; 
        for j=K+16:size(testreal,2)
            Better_Pred(i,H)=prediction(i,j,Pred_Code(i,H)); %每个最优的组合的结果都输入Best_Pred中
            H=H+1;      
        end
    end
   clear prediction   %这个变量太大了，赶快去掉

err_test=testreal(:,K+16:size(testreal,2))-Better_Pred;   %注意这里是新的err_test，进行一步计算
testNum   =numel(err_test);

testResult.test_RMSE =sqrt(sum(sum(err_test.^2))/testNum)/sum(capp(farmsitting));
testResult.test_MAE  =sum(sum(abs(err_test)))/testNum;
testResult.test_MAPE =sum(sum(abs(err_test./sum(capp(farmsitting)))))/testNum;
testResult.test_MSE  =sum(sum(err_test.^2))/testNum;
testResult.test_errMAX =max(abs(err_test));

Mfarm_Pred_Better.RMSE=testResult.test_RMSE; %记录每一种组合的预测值
Mfarm_Pred_Better.MAPE=testResult.test_MAPE; %记录每一种组合的预测值
Mfarm_Pred_Better.MSE=testResult.test_MSE; %记录每一种组合的预测值
Mfarm_Pred_Better.MAE=testResult.test_MAE; %记录每一种组合的预测值


for i=1:size(err_test,1)
    ChildtestNum   =size(err_test,2);
    
    Ch_test_Better.RMSE(i) =sqrt(sum(err_test(i,:).^2)/ChildtestNum)/sum(capp(farmsitting));
    Ch_test_Better.MAE(i)  =sum(abs(err_test(i,:)))/ChildtestNum;
    Ch_test_Better.MAPE(i) =sum(abs(err_test(i,:))./sum(capp(farmsitting)))/ChildtestNum;
    Ch_test_Better.MSE(i)  =sum(sum(err_test(i,:).^2))/ChildtestNum;  
end


end

%测试结果
