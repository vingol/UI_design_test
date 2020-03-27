function [Better_Pred] = ClusterResult(farmsitting,testY_prediction,Matchb_code,Matchcoding,test_time)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
N=length(farmsitting);   %计算风电集群的维数
Bel=Bell(N);          %风电集群组合维数
Index=SetPartition(N:-1:1);     %这里默认farmsitting的编号是从后往前为1,2,3,4,5 这里与早期编号一致
Better_Pred=zeros(16,1);   %单个样本的计算结果

predict_code=Matchb_code(:,Matchcoding);  %匹配的编号值
if isempty(Matchcoding)==1
predict_code=ones(16,1);
end
prediction=zeros(16,size(predict_code,2));

for i=1:size(predict_code,2)
    Temp_code=predict_code(:,i);
    for j=1:16
        for h=1:size(Index{Temp_code(j)},2)  %判断有多少个内部联盟
        prediction(j,i)=prediction(j,i)+testY_prediction{sum(2.^(Index{Temp_code(j)}{h}-1))}(j,test_time);
        end
    end
end
Better_Pred=mean(prediction,2); %按行平均

end

