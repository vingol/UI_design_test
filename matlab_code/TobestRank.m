function [RankMatrix] = TobestRank(farmsitting,testY_prediction,testreal,K,Pred_Code)
%根据最新数据计算最优预测划分水平，最近步数可以改变
%这里应用Set Partition算法，将集合分为几个非空，交集为空，并集为全的子集之和形式，共有Bell个
%感谢MATLAB FILE中 Bruno Luong于2009年进行的算法贡献

%   Input：
%   风电场的编号，farmsitting
%   预测结果，testY_prediction 按照风电场的编号的二进制进行划分，应该有2^N-1个
%   真实功率，testreal
%   判断超前步数： K  K为零时代表序列长度不变
%   风电集群的每一个样本和每一个预测时间尺度下的预测组合的编码，Pred_Code
%
%
%   Output：
%   相比于最优值，在每一个超前尺度和样本下现阶段预测联盟在总联盟中的排序
%

%% 数据预处理
N=length(farmsitting);   %计算风电集群的维数
Bel=Bell(N);          %风电集群组合维数
% Mfarm_Partition=SetPartition(farmsitting);  %给出所有风电集群组合，其中数字代表风电场的编号
Index=SetPartition(N:-1:1);     %这里默认farmsitting的编号是从后往前为1,2,3,4,5 这里与早期编号一致
% err_test=zeros(16,size(testreal,2),Bel);     %err_test 表示所有的组合误差
prediction=zeros(16,size(testreal,2),Bel);   %predcition 表示所有的组合测试结果
    if K
        RankMatrix=zeros(16,size(testreal,2)-(K+16-1));   %记录每一组计算结果的最优值  两种情况，K为零和不为零
    else
        RankMatrix=zeros(16,size(testreal,2));   %记录每一组计算结果的最优值
    end


%% 数据整理测试
    for i=1:Bel  %i表示遍历风电集群的个数
        for j=1:size(Index{i},2)  %判断每一个场群划分策略有多少个子联盟
            prediction(:,:,i)=prediction(:,:,i)+testY_prediction{sum(2.^(Index{i}{j}-1))};
        end
    end
    err_test=abs(repmat(testreal,1,1,Bel)-prediction);     %当前集群预测值和实际值的误差
    [Allien,Indexing]=sort(err_test,3);  %Indexing就是err_test里面每一行每一列按照祖旭排列的结果
     H2=reshape(Allien(1,K+16:size(testreal,2),:),size(testreal,2)-(K+16-1),Bel);
     H1=reshape(Indexing(1,K+16:size(testreal,2),:),size(testreal,2)-(K+16-1),Bel);
    if K
        for i=1:16     %计算每个对应的最小的组合
            H=1;    %H用来计数
            for j=K+16:size(testreal,2)    %放弃前面K+15组数据，单纯作为判断的结果（验证集）
                RankMatrix(i,H)=Indexing(i,j,Pred_Code(i,H));  %计算对应选择的编号在整体最优计算中的排序
                H=H+1;
            end
        end
    else
        for i=1:16     %计算每个对应的最小的组合
            for j=1:size(testreal,2)    %放弃前面K+15组数据，单纯作为判断的结果（验证集）
                RankMatrix(i,j)=Indexing(i,j,Pred_Code(i,j));  %计算对应选择的编号在整体最优计算中的排序
            end
        end


    end




end

