function [Mfarm_Pred,Mfarm_Partition,Ch_Mfarm] = Farmdetection(farmsitting,testY_prediction,testreal,capp)
%��糡������ ������ȺԤ��
%����Ӧ��Set Partition�㷨�������Ϸ�Ϊ�����ǿգ�����Ϊ�գ�����Ϊȫ���Ӽ�֮����ʽ������Bell��
%��лMATLAB FILE�� Bruno Luong��2009����е��㷨����

%   Input�� 
%   ��糡�ı�ţ�farmsitting
%   Ԥ������testY_prediction ���շ�糡�ı�ŵĶ����ƽ��л��֣�Ӧ����2^N-1��
%   ��ʵ���ʣ�testreal
%   ��缯Ⱥװ��������capp ���е�װ������
%   
%   Output�� 
%   ��缯Ⱥ�����Ԥ�⣬Mfarm_Pred
%   ��缯Ⱥ�Ķ�Ӧ��ϣ�Mfarm_Partition
%   ��缯Ⱥ��Ԥ��Ч����Ch_Mfarm ÿһ�д���1����ϵ�16��Ԥ�⣬ÿ1�б�ʾԤ��ʱ��߶�
%% ����Ԥ����
 N=length(farmsitting);   %�����缯Ⱥ��ά��
 Bel=Bell(N);          %��缯Ⱥ���ά��
 Mfarm_Partition=SetPartition(farmsitting);  %�������з�缯Ⱥ��ϣ��������ִ����糡�ı��
 Index=SetPartition(N:-1:1);     %����Ĭ��farmsitting�ı���ǴӺ���ǰΪ1,2,3,4,5 ���������ڱ��һ��
 Mfarm_Pred=struct('RMSE',zeros(Bel,1),'MAPE',zeros(Bel,1),'MSE',zeros(Bel,1),'MAE',zeros(Bel,1)); %Mfarm_prediction,��¼ÿ�ε�Ԥ����
  Ch_Mfarm=struct('RMSE',zeros(Bel,16),'MAPE',zeros(Bel,16),'MSE',zeros(Bel,16),'MAE',zeros(Bel,16)); %Mfarm_prediction,��¼ÿ�ε�Ԥ����



%% �����������
   for i=1:Bel  %i��ʾ������缯Ⱥ�ĸ���
       prediction=zeros(16,size(testreal,2));   %size(testreal,2)�����еĲ�������
       for j=1:size(Index{i},2)  %�ж�ÿһ����Ⱥ���ֲ����ж��ٸ�������
            prediction=prediction+testY_prediction{sum(2.^(Index{i}{j}-1))}; 
       end
       err_test=testreal-prediction;     %��ǰ��ȺԤ��ֵ��ʵ��ֵ�����
       
        %���Խ��
        testNum   =numel(err_test);
        
        testResult.test_RMSE =sqrt(sum(sum(err_test.^2))/testNum)/sum(capp(farmsitting));
        testResult.test_MAE  =sum(sum(abs(err_test)))/testNum;
        testResult.test_MAPE =sum(sum(abs(err_test./sum(capp(farmsitting)))))/testNum;
        testResult.test_MSE  =sum(sum(err_test.^2))/testNum;
        testResult.test_errMAX =max(abs(err_test));

        Mfarm_Pred.RMSE(i)=testResult.test_RMSE; %��¼ÿһ����ϵ�Ԥ��ֵ
        Mfarm_Pred.MAPE(i)=testResult.test_MAPE; %��¼ÿһ����ϵ�Ԥ��ֵ
        Mfarm_Pred.MSE(i)=testResult.test_MSE; %��¼ÿһ����ϵ�Ԥ��ֵ  
        Mfarm_Pred.MAE(i)=testResult.test_MAE; %��¼ÿһ����ϵ�Ԥ��ֵ 
   
        for j=1:size(err_test,1)   %j��ÿһ��ʱ��߶�
            ChildtestNum   =size(err_test,2);
            
            Ch_testResult(j).RMSE =sqrt(sum(err_test(j,:).^2)/ChildtestNum)/sum(capp(farmsitting));
            Ch_testResult(j).MAE  =sum(abs(err_test(j,:)))/ChildtestNum;
            Ch_testResult(j).MAPE =sum(abs(err_test(j,:))./sum(capp(farmsitting)))/ChildtestNum;
            Ch_testResult(j).MSE  =sum(sum(err_test(j,:).^2))/ChildtestNum;
            Ch_testResult(j).MAX  =max(err_test(j,:));
            Ch_testResult(j).MIN  =-max(-err_test(j,:));
            
            Ch_Mfarm.RMSE(i,j)=Ch_testResult(j).RMSE; %��¼ÿһ����ϵ�Ԥ��ֵ
            Ch_Mfarm.MAPE(i,j)=Ch_testResult(j).MAPE; %��¼ÿһ����ϵ�Ԥ��ֵ
            Ch_Mfarm.MSE(i,j)=Ch_testResult(j).MSE; %��¼ÿһ����ϵ�Ԥ��ֵ  
            Ch_Mfarm.MAE(i,j)=Ch_testResult(j).MAE; %��¼ÿһ����ϵ�Ԥ��ֵ 
        end 
   end  
end

