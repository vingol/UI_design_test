function [Mfarm_Pred_Upscaling,Upscaling_Pred,Ch_test_Upscaling] = upscaling(timetrain,timeval,timetest,farmsitting,lookback,Power,capp,M)
%upscaling,����ͳ�����߶��㷨���㼯ȺԤ��������㷨
%   Input��
%   timetrain:ѵ����ʱ��
%   timeval:��֤��ʱ��
%   timetest�����Լ�ʱ��
%   ��糡�ı�ţ�farmsitting
%   ��糡����ʷ����������lookback
%   ���з�糡���ʣ�Power
%   ��缯Ⱥװ��������capp ���е�װ������
%   ��ѡ��ο���糡������M�����涨��ѡ������ص�ǰM����糡��Ϊ�ο���糡   
%
%   Output��
%   ��缯Ⱥ�����߶�����Ԥ������Mfarm_Pred_Upscaling
%   ��缯Ⱥÿһ����������µõ�����ʵԤ����: Upscaling_Pred
%   ��缯Ⱥ����Ԥ��ʱ��߶Ȼ��֣�ÿ��Ԥ��ʱ��߶��µõ������߶�Ԥ������Ch_test_Upscaling


%% ���������վ��ʵ��Ԥ��ֵ
Region_val=sum(Power(timeval,farmsitting),2); %��Ⱥ��֤����������� ��֤��
Region_test=sum(Power(timetest,farmsitting),2); %��Ⱥ���Լ���������� ���Լ�
RGF=zeros(1,length(farmsitting));  %RGF:����վ�����뼯Ⱥ��������������--��֤��
RF=zeros(16,length(farmsitting)); %RF:����ʱ��߶��¼�ȺԤ��ֵ��ʵ��ֵ�������--��֤��
for group=1:length(farmsitting)
    farm=farmsitting(group);  %ѡ��ı��
    dataset=Power(:,farm); %ѡ����ʵĹ�������
%    MaxPower(group)=max(dataset);   %��¼���ֵ
%-----���ݹ�һ�����ʽ����ע��������timetrain----------------------------------
    [scaler_data,ps_data]=mapminmax(dataset(timetrain)',0,1);   %��һ����[0,1],mapminmax(x)ֻ�ܽ����й�һ������x������ת��
    scaler_data=scaler_data';
    
    %������������������ֵ
    [scaler_trainX,scaler_trainY]=Divide(dataset,timetrain,lookback,ps_data);
    [scaler_testX,scaler_testY]=Divide(dataset,timetest,lookback,ps_data);
    [scaler_valX,scaler_valY]=Divide(dataset,timeval,lookback,ps_data);
  %% ѡȡѵ���顢�����飨���������������Ϻ�֮��  �������棩
    trainY_scalerPre=zeros(16,size(scaler_trainX,2)); %��¼ÿ��ʱ��߶�ÿ�������µ�Ԥ����
    testY_scalerPre=zeros(16,size(scaler_testX,2));
    valY_scalerPre=zeros(16,size(scaler_valX,2));
    Model=cell(16,1);
    for steps=1:16
        Mdl = fitrsvm(scaler_trainX',scaler_trainY(steps,:)','Standardize',true,'KernelFunction','rbf');
        % Mdl = fitrsvm(scaler_trainX',scaler_trainY(steps,:)','Standardize',true);
        Model{steps}=Mdl;
        SVMModel{steps,group}=Mdl;
        % model = svmtrain(tsy,time,'-c 1000 -g 0.02 -s 3 -p 0.4 -n 0.1');
        trainY_scalerPre(steps,:)= predict(Mdl,scaler_trainX');  %�°汾��Ҫ�����һ����-b 0����ʾ���,�������Ҫ����������
        testY_scalerPre(steps,:) = predict(Mdl,scaler_testX');  %�°汾��Ҫ�����һ����-b 0����ʾ���,�������Ҫ����������
        valY_scalerPre(steps,:) = predict(Mdl,scaler_valX');  
    end
    
    toc
    %% �����������
    trainY_pre=mapminmax('reverse',trainY_scalerPre,ps_data);
    trainY_real=mapminmax('reverse',scaler_trainY,ps_data);
    
    testY_pre=mapminmax('reverse',testY_scalerPre,ps_data);
    testY_real=mapminmax('reverse',scaler_testY,ps_data);
    
    valY_pre=mapminmax('reverse',valY_scalerPre,ps_data);
    valY_real=mapminmax('reverse',scaler_valY,ps_data);
    
    imf_train=trainY_pre;
    trainreal=trainY_real;
    imf_test=testY_pre;
    testreal=testY_real;
    imf_val=valY_pre;
    valreal=valY_real;
    
    trainY_prediction{group}= imf_train; 
    testY_prediction{group}= imf_test;   %��¼ÿ�μ���Ľ��
    valY_prediction{group}= imf_val;
    
    err_train=trainreal-imf_train;  %�������ʱ�̵����������û���ã������Ժ�����Ҫ��ʱ��
    err_test=testreal-imf_test;
    err_val=valreal-imf_val;
    
%--------����������ϵ��------------
RGF(group)=min(min(corrcoef(Region_val,Power(timeval,farmsitting(group)))));%RGF��ֵ�Ǽ������֤���е�
for j=1:16
RF(j,group)=min(min(corrcoef(imf_val(j,:),valreal(j,:))));  %RF��ֵ�Ǽ������֤���е�
end

end

if nargin==8   %��������������ǰM����صķ�糡Ϊ�ο���糡
    if M>length(farmsitting)
       error('����ο���糡��������');
    end
    [~,FarmIndex]=sort(RGF,'descend');  %���������ϵ�����н�������
    farm=farmsitting(FarmIndex(1:M));%ǰ�������ϵ���ı��,ǰM�����ϵ����Ϊ��ǰ��farm
else 
    farm=farmsitting;  %�����з�糡��Ϊfarm
end


%% ���������վ�������Ժ���س̶ȣ�ʹ����֤����֤
    [scaler_valX,scaler_valY]=Divide(sum(Power(:,farmsitting),2),timeval,lookback);  %����ʱ��߶ȶ�����ʵ�ʹ��ʽ��л���
    [scaler_testX,scaler_testY]=Divide(sum(Power(:,farmsitting),2),timetest,lookback);
Region_valFP=zeros(16,length(timeval));
Region_testFP=zeros(16,length(timetest)); %�õ����Ǿ�����һ�μ�Ȩb*PF��ĳ���������ֵ
RFfinal=RGF.*RGF.*RF;%RFfinal:���ռ��������糡��Ȩ��b
for j=1:16
    b(j,:)=RFfinal(j,:)./sum(RFfinal(j,:));   %�����b������Ϊʱ��߶ȣ�������Ϊ������վ��ϵ����16*N
    for k=farm  %��Ϊgroup���Ƕ�Ӧ��糡�ı��ֵ
        group=find(k==farmsitting);
        Region_valFP(j,:)=Region_valFP(j,:)+b(j,group)*valY_prediction{group}(j,:);
        Region_testFP(j,:)=Region_testFP(j,:)+b(j,group)*testY_prediction{group}(j,:);
    end
    P_tempj=polyfit(Region_valFP(j,:),scaler_valY(j,:),1);  %�������ʽ�ع��¶�Ӧ��ʵ�������ʺ�Ԥ���Ȩ����
    P(j,:)=P_tempj; 
    Region_testfinal(j,:)=polyval(P_tempj,Region_testFP(j,:));  %��������ʽ�ع����Խ��
end

%% ���ս������
        Upscaling_Pred=Region_testfinal;  %���յļ�ȺԤ����
        err_test=scaler_testY-Region_testfinal;    
        %���Խ��
        testNum   =numel(err_test);
        
        Mfarm_Pred_Upscaling.RMSE =sqrt(sum(sum(err_test.^2))/testNum)/sum(capp(farmsitting));
        Mfarm_Pred_Upscaling.MAE  =sum(sum(abs(err_test)))/testNum;
        Mfarm_Pred_Upscaling.MAPE =sum(sum(abs(err_test./sum(capp(farmsitting)))))/testNum;
        Mfarm_Pred_Upscaling.MSE  =sum(sum(err_test.^2))/testNum;
        Mfarm_Pred_Upscaling.errMAX =max(abs(err_test));
          
        
        %������
      for i=1:size(err_test,1)
            ChildtestNum   =size(err_test,2);
            
            Ch_test_Upscaling.RMSE(i) =sqrt(sum(err_test(i,:).^2)/ChildtestNum)/sum(capp(farmsitting));
            Ch_test_Upscaling.MAE(i)  =sum(abs(err_test(i,:)))/ChildtestNum;
            Ch_test_Upscaling.MAPE(i) =sum(abs(err_test(i,:))./sum(capp(farmsitting)))/ChildtestNum;
            Ch_test_Upscaling.MSE(i)  =sum(sum(err_test(i,:).^2))/ChildtestNum;
            Ch_test_Upscaling.MAX(i)  =max(err_test(i,:));
            Ch_test_Upscaling.MIN(i)  =-max(-err_test(i,:));
      end

end

