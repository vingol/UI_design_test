function [Better_Pred] = ClusterResult(farmsitting,testY_prediction,Matchb_code,Matchcoding,test_time)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
N=length(farmsitting);   %�����缯Ⱥ��ά��
Bel=Bell(N);          %��缯Ⱥ���ά��
Index=SetPartition(N:-1:1);     %����Ĭ��farmsitting�ı���ǴӺ���ǰΪ1,2,3,4,5 ���������ڱ��һ��
Better_Pred=zeros(16,1);   %���������ļ�����

predict_code=Matchb_code(:,Matchcoding);  %ƥ��ı��ֵ
if isempty(Matchcoding)==1
predict_code=ones(16,1);
end
prediction=zeros(16,size(predict_code,2));

for i=1:size(predict_code,2)
    Temp_code=predict_code(:,i);
    for j=1:16
        for h=1:size(Index{Temp_code(j)},2)  %�ж��ж��ٸ��ڲ�����
        prediction(j,i)=prediction(j,i)+testY_prediction{sum(2.^(Index{Temp_code(j)}{h}-1))}(j,test_time);
        end
    end
end
Better_Pred=mean(prediction,2); %����ƽ��

end

