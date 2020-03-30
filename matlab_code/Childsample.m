function [Mfarm_Pred_Best,bestcode,Best_Pred,Ch_test_Best] = Childsample(farmsitting,testY_prediction,testreal,capp)
%���ֶ��ڲ�ͬ��ǰԤ���ʱ��߶ȣ�����ÿһ��Ԥ���е�������ϣ�child-��ͬʱ��߶�;sample-������Ϊ��λ��
%����Ӧ��Set Partition�㷨�������Ϸ�Ϊ�����ǿգ�����Ϊ�գ�����Ϊȫ���Ӽ�֮����ʽ������Bell��
%��лMATLAB FILE�� Bruno Luong��2009����е��㷨����

%   Input�� 
%   ��糡�ı�ţ�farmsitting
%   Ԥ������testY_prediction ���շ�糡�ı�ŵĶ����ƽ��л��֣�Ӧ����2^N-1��
%   ��ʵ���ʣ�testreal
%   ��缯Ⱥװ��������capp ���е�װ������
%   
%   Output�� 
%   ��缯Ⱥ���������Ԥ������Mfarm_Pred_Best
%   ��缯Ⱥ��ÿһ��������ÿһ��Ԥ��ʱ��߶��µ�������ϵĴ��룬bestcode
%   ��缯Ⱥÿһ����������µõ���ʵ��Ԥ����: Best_Pred
%   ��缯Ⱥ����Ԥ��ʱ��߶Ȼ��֣�ÿ��Ԥ��ʱ��߶��µõ�������Ԥ������Ch_test_Best 

%% ����Ԥ����
 N=length(farmsitting);   %�����缯Ⱥ��ά��
         if iscell(farmsitting) %����������һ��cell������
            H=[];
            for i=1:N
                H=[H,farmsitting{i}];
            end
            farmsitting=H;   %����Ϊ�˺���Ĺ��ʼ�����׼����
            clear H
        end
 Bel=Bell(N);          %��缯Ⱥ���ά��
% Mfarm_Partition=SetPartition(farmsitting);  %�������з�缯Ⱥ��ϣ��������ִ����糡�ı��
 Index=SetPartition(N:-1:1);     %����Ĭ��farmsitting�ı���ǴӺ���ǰΪ1,2,3,4,5 ���������ڱ��һ��
 Mfarm_Pred_Best=struct('RMSE',zeros(1,1),'MAPE',zeros(1,1),'MSE',zeros(1,1),'MAE',zeros(1,1)); %Mfarm_Pred_Best,��¼�������ŵ�Ԥ����
% err_test=zeros(16,size(testreal,2),Bel);     %err_test ��ʾ���е�������
 prediction=zeros(16,size(testreal,2),Bel);   %predcition ��ʾ���е���ϲ��Խ��
% bestcode=zeros(16,size(testreal,2));     %��¼ÿ����ǰ�����£�ÿ��������������ϱ��
 Best_Pred=zeros(16,size(testreal,2));     %��¼ÿһ��������ÿһ����ǰԤ��߶������ŵ�Ԥ����
 Ch_test_Best=struct('RMSE',zeros(16,1),'MAPE',zeros(16,1),'MSE',zeros(16,1),'MAE',zeros(16,1));  %Mfarm_prediction,��¼ÿ����ǰ�������������ŵ�Ԥ����
 %% �����������
   for i=1:Bel  %i��ʾ������缯Ⱥ�ĸ���      
       for j=1:size(Index{i},2)  %�ж�ÿһ����Ⱥ���ֲ����ж��ٸ�������
            prediction(:,:,i)=prediction(:,:,i)+testY_prediction{sum(2.^(Index{i}{j}-1))}; 
       end
   end
   batchsize=50;
   if size(testreal,2)<=batchsize  %�ж���������ݳ����Ƿ����
      err_test=repmat(testreal,1,1,Bel)-prediction;     %��ǰ��ȺԤ��ֵ��ʵ��ֵ�����
      [~,code]=sort(abs(err_test),3);    %������С��������bestcode��ʾ��Ӧ�ı��
       bestcode=code(:,:,1);   %��õ�һ���
%      [~,bestcode]=min(abs(err_test),[],3);    %������С��������bestcode��ʾ��Ӧ�ı��
   else   %���糤�ȹ���,��Ҫ��������
       tempcode=[]; %��������ʱ�ֱ�洢���ŵ�code
       for batch=1:floor(size(testreal,2)/batchsize)
           err_test=repmat(testreal(:,batchsize*(batch-1)+1:batchsize*batch),1,1,Bel)-prediction(:,batchsize*(batch-1)+1:batchsize*batch,:);     %��ǰ��ȺԤ��ֵ��ʵ��ֵ�����
           [~,code]=sort(abs(err_test),3);    %������С��������bestcode��ʾ��Ӧ�ı��
           tempcode=[tempcode,code(:,:,1)];   %��õ�һ���           
       end
       if mod(size(testreal,2),batchsize)~=0 %�������ļ��������ܱ�500����
           err_test=repmat(testreal(:,batchsize*floor(size(testreal,2)/batchsize)+1:size(testreal,2)),1,1,Bel)-prediction(:,batchsize*floor(size(testreal,2)/batchsize)+1:size(testreal,2),:);     %��ǰ��ȺԤ��ֵ��ʵ��ֵ�����
           [~,code]=sort(abs(err_test),3);    %������С��������bestcode��ʾ��Ӧ�ı��
           tempcode=[tempcode,code(:,:,1)];   %��õ�һ���
           bestcode=tempcode;
       else
           bestcode=tempcode;
       end      
   end

clear err_test   %�������̫���ˣ��Ͽ�ȥ��
   for i=1:16     %����ÿ����Ӧ����С�����
       for j=1:size(testreal,2)
      Best_Pred(i,j)=prediction(i,j,bestcode(i,j)); %ÿ�����ŵ���ϵĽ��������Best_Pred��
       end
   end
   clear prediction
   err_test=testreal-Best_Pred;   %ע���������µ�err_test������һ������
   testNum   =numel(err_test);
        
        testResult.test_RMSE =sqrt(sum(sum(err_test.^2))/testNum)/sum(capp(farmsitting));
        testResult.test_MAE  =sum(sum(abs(err_test)))/testNum;
        testResult.test_MAPE =sum(sum(abs(err_test./sum(capp(farmsitting)))))/testNum;
        testResult.test_MSE  =sum(sum(err_test.^2))/testNum;
        testResult.test_errMAX =max(abs(err_test));

        Mfarm_Pred_Best.RMSE=testResult.test_RMSE; %��¼ÿһ����ϵ�Ԥ��ֵ
        Mfarm_Pred_Best.MAPE=testResult.test_MAPE; %��¼ÿһ����ϵ�Ԥ��ֵ
        Mfarm_Pred_Best.MSE=testResult.test_MSE; %��¼ÿһ����ϵ�Ԥ��ֵ  
        Mfarm_Pred_Best.MAE=testResult.test_MAE; %��¼ÿһ����ϵ�Ԥ��ֵ 
        
        
         for i=1:size(err_test,1)
            ChildtestNum   =size(err_test,2);

            Ch_test_Best.RMSE(i) =sqrt(sum(err_test(i,:).^2)/ChildtestNum)/sum(capp(farmsitting));
            Ch_test_Best.MAE(i)  =sum(abs(err_test(i,:)))/ChildtestNum;
            Ch_test_Best.MAPE(i) =sum(abs(err_test(i,:))./sum(capp(farmsitting)))/ChildtestNum;
            Ch_test_Best.MSE(i)  =sum(sum(err_test(i,:).^2))/ChildtestNum;

        end
   
end

 %���Խ��
        