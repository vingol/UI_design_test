function [trainResult,Ch_trainResult] = TCDPF_train(Power,capp,maxcluster,lookback)
%TCDPF_train: ��̬����Ԥ���ѵ����������Ҫ�����ⲿ���ݣ�powermatrix��,�������(maxcluster)
%��������ʱ��lookback
%����������������������2000������SVMС����������������+���׳��ֹ����
%   �˴���ʾ��ϸ˵��

tic
farmsitting=1:size(Power,2);
%farmsitting=[1,2,3,4,5,6,7,8,10];  %׼���Ƚ���ϵķ�糡��� %1,2,3,5,6,9,10����1,2,3,4,6,9,10

%% ѭ��ǰ��������
% time=time_train;                    %ʱ�����
% %lookback=4;           %ʱ��߶ȣ�Ԥ����ٸ����Ժ��ֵ,ʵ������һ���ж��ٸ�����
% trainNum1 = 1000;                    %576=24��*24Сʱ
% data_M=length(time);             %������

%maxcluster=5; %���»��ֺ��Ӽ�Ⱥ�ĸ���
Sample=Power(:,farmsitting);  %��һ��������������Ǹ�����糡�Ĺ���
Z=zeros(length(farmsitting)-maxcluster,3);  %��Ӧmatlab��Link����
for i=1:length(farmsitting)-1
    [Co_Matrix,P]=corrcoef(Sample);      %������Լ��㹫ʽ
    Co_Matrix=tril(Co_Matrix,-1);    %ֻ���������ǵ�����Ծ���
    Co_Matrix((Co_Matrix(:)==0))=1;   %��������ķ���ȫ����Ϊ1
    Co_Matrix(isnan(Co_Matrix(:))==1)=1;
    [idx,idy]=find(Co_Matrix==min(min(Co_Matrix)));  %��Ӧ����Ҫ���������������,�����idx��idy�Ǵ�С��������������
    Z(i,1)=min([idx,idy]);Z(i,2)=max([idx,idy]);Z(i,3)=1/max(max(Co_Matrix)); %��Ӧ�������ӹ�ϵ,ע�����������Խ�ǿ�ĵ糡���壬����Ҫ�Ѳ�ξ���ĵ糡ֵ��Ϊ1/�����
    Sample=[Sample,sum(Sample(:,[idx,idy]),2)];  %��չһά
    Sample(:,[idx,idy])=1; %���ԭ��������
end

dendrogram(Z);
T=cluster(Z,'maxclust',maxcluster);  %ֻ������maxcluster��
Tstar=cell(max(T),1); %�ж���Щ�������һ�����
PowerClass=[]; CappClass=[];
for i=1:max(T)
    Tstar{i}=farmsitting((T==i));  %���������һ�������
    PowerClass=[PowerClass,sum(Power(:,Tstar{i}),2)];
    CappClass=[CappClass;sum(capp(Tstar{i}))];  %�ֱ�����Ѿ����ֺ��Ӽ�Ⱥ�Ĺ��ʺ���������
end

farmCluster=1:max(T);  %�µ��Ӽ�Ⱥ�ı��

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
MaxPower=zeros(2^length(farmCluster)-1,1);       %��¼ÿһ�������е����ֵ
SVMModel=cell(16,2^length(farmCluster)-1);  %SVMModel�Ǽ�¼���Ԥ��ģ�Ͷ�Ӧ�Ľṹ

for group=1:2^length(farmCluster)-1
    farm=WPC {group};  %ѡ��ı��
    dataset=sum(PowerClass(:,farm),2);
%    MaxPower(group)=max(dataset);   %��¼���ֵ

    [scaler_data,ps_data]=mapminmax(dataset',0,1);   %��һ����[0,1],mapminmax(x)ֻ�ܽ����й�һ������x������ת��
    scaler_data=scaler_data'; 
    
    %������������������ֵ
    [scaler_trainX,scaler_trainY]=Divide(dataset,lookback+1:size(Power,1)-15,lookback,ps_data);
  %% ѡȡѵ���顢�����飨���������������Ϻ�֮��  �������棩
    trainY_scalerPre=zeros(16,size(scaler_trainX,2)); %��¼ÿ��ʱ��߶�ÿ�������µ�Ԥ����
    Model=cell(16,1);
    for steps=1:16
        Mdl = fitrsvm(scaler_trainX',scaler_trainY(steps,:)','Standardize',true,'KernelFunction','rbf');
        Model{steps}=Mdl;
        SVMModel{steps,group}=Mdl;
        trainY_scalerPre(steps,:)= predict(Mdl,scaler_trainX');  %�°汾��Ҫ�����һ����-b 0����ʾ���,�������Ҫ����������
    end
    %% ������������
    trainY_pre=mapminmax('reverse',trainY_scalerPre,ps_data);
    trainY_real=mapminmax('reverse',scaler_trainY,ps_data);
    errTrain=trainY_real-trainY_pre;
    trainScore=sqrt(sum(sum(errTrain.^2))/numel(errTrain));    %���������
   
    imf_train=trainY_pre;
    trainreal=trainY_real;
    
    trainY_prediction{group}= imf_train;
    err_train=trainreal-imf_train;

%%     �ܵĽ��  ѵ�����
        trainNum   =numel(err_train);
        
        trainResult.train_RMSE =sqrt(sum(sum(err_train.^2))/trainNum)/sum(CappClass(farm)) ;
        trainResult.train_MAE  =sum(sum(abs(err_train)))/trainNum;
        trainResult.train_MAPE =sum(sum(abs(err_train./sum(CappClass(farm)))))/trainNum;     
              
%%      ������
        for i=1:size(err_train,1)
            ChildtrainNum   =size(err_train,2);
            
            Ch_trainResult.RMSE(i) =sqrt(sum(err_train(i,:).^2)/ChildtrainNum)/sum(CappClass(farm));
            Ch_trainResult.MAE(i)  =sum(abs(err_train(i,:)))/ChildtrainNum;
            Ch_trainResult.MAPE(i) =sum(abs(err_train(i,:))./sum(CappClass(farm)))/ChildtrainNum;
            Ch_trainResult.MSE(i)  =sum(sum(err_train(i,:).^2))/ChildtrainNum; 
        end      
end
%% �Ƚϲ�ͬ��糡����µ������缯Ⱥ�����ֵ
    [scaler_trainX,trainreal]=Divide(sum(PowerClass,2),lookback+1:size(Power,1)-15,lookback);
    timematrix=toc;    
    fprintf('%d sub-regions are considered and use  %f s \n',2^(maxcluster)-1,timematrix);
    save('TCDPF_TrainedReuslt.mat','SVMModel','Tstar','ps_data','maxcluster','lookback')
    
end
