function [Better_Pred,Mfarm_Pred_Better,Ch_test_Better,Better_code,Mfarm_Partition_all] = TCDPF_test(Power,capp,K)
%TCDPF_test: ��̬����Ԥ��Ĳ��Ժ�������Ҫ�����ⲿ���ݣ�powermatrix��,�������(maxcluster)
%��̬ƽ��ʱ��߶�K,��������ʱ��lookback
%�������������ѵ����������
%   �˴���ʾ��ϸ˵��
load ('TCDPF_TrainedReuslt.mat')

tic
farmsitting=1:size(Power,2);  %׼���Ƚ���ϵķ�糡��� %1,2,3,5,6,9,10����1,2,3,4,6,9,10

%% ѭ��ǰ��������
% time=[30001:31000,13001:13500];                    %ʱ�����
% %lookback=4;           %ʱ��߶ȣ�Ԥ����ٸ����Ժ��ֵ,ʵ������һ���ж��ٸ�����
% trainNum1 = 1000;                    %576=24��*24Сʱ
% data_M=length(time);             %������
% testNum1 = data_M-trainNum1;         %168=7��*24Сʱ�����Լ�������������ȥѵ����


PowerClass=[]; CappClass=[];
for i=1:length(Tstar)
    PowerClass=[PowerClass,sum(Power(:,Tstar{i}),2)];
    CappClass=[CappClass;sum(capp(Tstar{i}))];  %�ֱ�����Ѿ����ֺ��Ӽ�Ⱥ�Ĺ��ʺ���������
end

farmCluster=1:length(Tstar);  %�µ��Ӽ�Ⱥ�ı��

B=ff2n(length(farmCluster));
[m n]=find(B'==1);    %find ���ھ����ǰ��н��м���ģ�m��n�ֱ��ʾ��Ӧ������
WPC=cell(2^length(farmCluster)-1,1); % �����ռ������������ȫ��������� 2^n
for i=2:2^length(farmCluster)
    D=find(n==i);  %��i���Ӽ��еķ���Ԫ��
    WPC{i-1}=(farmCluster(m(D)));  %���ж�Ӧ�ķ�糡��������缯Ⱥ�����WPC
end

farmCluster1=length(farmCluster):-1:1;
WPCS=cell(2^length(farmCluster)-1,1); % �����ռ������������ȫ��������� ,���շ�糡��ǰ��������
for i=2:2^length(farmCluster1)
    D=find(n==i);  %��i���Ӽ��еķ���Ԫ��
    WPCS{i-1}=(farmCluster1(m(D)));  %���ж�Ӧ�ķ�糡��������缯Ⱥ�����WPC
end



%% ���������
testY_prediction=cell(2^length(farmCluster)-1,1); %��cell��¼ÿ��Ԥ��Ľ��

for group=1:2^length(farmCluster)-1
    farm=WPC {group};  %ѡ��ı��
    dataset=sum(PowerClass(:,farm),2);
%    MaxPower(group)=max(dataset);   %��¼���ֵ
    
    %������������������ֵ
    [scaler_testX,scaler_testY]=Divide(dataset,lookback+1:size(Power,1)-15,lookback,ps_data);
  %% ѡȡѵ���顢�����飨���������������Ϻ�֮��  �������棩
    testY_scalerPre=zeros(16,size(scaler_testX,2)); %��¼ÿ��ʱ��߶�ÿ�������µ�Ԥ����
    Model=cell(16,1);
    for steps=1:16
        Mdl=SVMModel{steps,group};
        testY_scalerPre(steps,:)= predict(Mdl,scaler_testX');  %�°汾��Ҫ�����һ����-b 0����ʾ���,�������Ҫ����������
    end
    %% ������������
    testY_pre=mapminmax('reverse',testY_scalerPre,ps_data);
    testY_real=mapminmax('reverse',scaler_testY,ps_data);
    errTest=testY_real-testY_pre;
    testScore=sqrt(sum(sum(errTest.^2))/numel(errTest));              %RMSE���
    imf_test=testY_pre;
    testreal=testY_real;
    testY_prediction{group}= imf_test;   %��¼ÿ�μ���Ľ��
    err_test=testreal-imf_test;

%%     �ܵĽ��  ѵ�����
        testNum   =numel(err_test);
        
        testResult.test_RMSE =sqrt(sum(sum(err_test.^2))/testNum)/sum(CappClass(farm));
        testResult.test_MAE  =sum(sum(abs(err_test)))/testNum;
        testResult.test_MAPE =sum(sum(abs(err_test./sum(CappClass(farm)))))/testNum;
        testResult.test_MSE  =sum(sum(err_test.^2))/testNum;  
              
%%      ������
        for i=1:size(err_test,1)
            ChildtestNum   =size(err_test,2);
            Ch_testResult(i).RMSE =sqrt(sum(err_test(i,:).^2)/ChildtestNum)/sum(CappClass(farm));
            Ch_testResult(i).MAE  =sum(abs(err_test(i,:)))/ChildtestNum;
            Ch_testResult(i).MAPE =sum(abs(err_test(i,:))./sum(CappClass(farm)))/ChildtestNum;
            Ch_testResult(i).MSE  =sum(sum(err_test(i,:).^2))/ChildtestNum;          
        end      
end
%% �Ƚϲ�ͬ��糡����µ������缯Ⱥ�����ֵ
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
