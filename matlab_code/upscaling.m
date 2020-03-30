function [Mfarm_Pred_Upscaling,Upscaling_Pred,Ch_test_Upscaling] = upscaling(timetrain,timeval,timetest,farmsitting,lookback,Power,capp,M)
%upscaling,根据统计升尺度算法计算集群预测出力的算法
%   Input：
%   timetrain:训练集时间
%   timeval:验证集时间
%   timetest：测试集时间
%   风电场的编号，farmsitting
%   风电场的历史输入向量：lookback
%   所有风电场功率，Power
%   风电集群装机容量，capp 所有的装机容量
%   （选填）参考风电场个数，M，即规定好选择最相关的前M个风电场作为参考风电场   
%
%   Output：
%   风电集群的升尺度整体预测结果，Mfarm_Pred_Upscaling
%   风电集群每一个最优组合下得到的真实预测结果: Upscaling_Pred
%   风电集群按照预测时间尺度划分，每个预测时间尺度下得到的升尺度预测结果：Ch_test_Upscaling


%% 计算各个场站的实际预测值
Region_val=sum(Power(timeval,farmsitting),2); %集群验证集下整体出力 验证集
Region_test=sum(Power(timetest,farmsitting),2); %集群测试集下整体出力 测试集
RGF=zeros(1,length(farmsitting));  %RGF:各场站出力与集群整体出力的相关性--验证集
RF=zeros(16,length(farmsitting)); %RF:各个时间尺度下集群预测值与实际值的相关性--验证集
for group=1:length(farmsitting)
    farm=farmsitting(group);  %选入的编号
    dataset=Power(:,farm); %选择合适的功率曲线
%    MaxPower(group)=max(dataset);   %记录最大值
%-----数据归一化与格式化，注意这里是timetrain----------------------------------
    [scaler_data,ps_data]=mapminmax(dataset(timetrain)',0,1);   %归一化到[0,1],mapminmax(x)只能进行行归一，所以x进行了转制
    scaler_data=scaler_data';
    
    %划分输入组和输出期望值
    [scaler_trainX,scaler_trainY]=Divide(dataset,timetrain,lookback,ps_data);
    [scaler_testX,scaler_testY]=Divide(dataset,timetest,lookback,ps_data);
    [scaler_valX,scaler_valY]=Divide(dataset,timeval,lookback,ps_data);
  %% 选取训练组、测试组（可随机，待数据组合好之后  ，见下面）
    trainY_scalerPre=zeros(16,size(scaler_trainX,2)); %记录每个时间尺度每个样本下的预测结果
    testY_scalerPre=zeros(16,size(scaler_testX,2));
    valY_scalerPre=zeros(16,size(scaler_valX,2));
    Model=cell(16,1);
    for steps=1:16
        Mdl = fitrsvm(scaler_trainX',scaler_trainY(steps,:)','Standardize',true,'KernelFunction','rbf');
        % Mdl = fitrsvm(scaler_trainX',scaler_trainY(steps,:)','Standardize',true);
        Model{steps}=Mdl;
        SVMModel{steps,group}=Mdl;
        % model = svmtrain(tsy,time,'-c 1000 -g 0.02 -s 3 -p 0.4 -n 0.1');
        trainY_scalerPre(steps,:)= predict(Mdl,scaler_trainX');  %新版本需要后面加一个‘-b 0’表示输出,而且输出要加三个参数
        testY_scalerPre(steps,:) = predict(Mdl,scaler_testX');  %新版本需要后面加一个‘-b 0’表示输出,而且输出要加三个参数
        valY_scalerPre(steps,:) = predict(Mdl,scaler_valX');  
    end
    
    toc
    %% 数据整理测试
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
    testY_prediction{group}= imf_test;   %记录每次计算的结果
    valY_prediction{group}= imf_val;
    
    err_train=trainreal-imf_train;  %计算各个时刻的误差，这个现在没有用，留给以后有需要的时候
    err_test=testreal-imf_test;
    err_val=valreal-imf_val;
    
%--------计算各个相关系数------------
RGF(group)=min(min(corrcoef(Region_val,Power(timeval,farmsitting(group)))));%RGF的值是计算的验证集中的
for j=1:16
RF(j,group)=min(min(corrcoef(imf_val(j,:),valreal(j,:))));  %RF的值是计算的验证集中的
end

end

if nargin==8   %假设输入了限制前M最相关的风电场为参考风电场
    if M>length(farmsitting)
       error('输入参考风电场个数过多');
    end
    [~,FarmIndex]=sort(RGF,'descend');  %将出力相关系数进行降序排序
    farm=farmsitting(FarmIndex(1:M));%前最大的相关系数的编号,前M个相关系数作为当前的farm
else 
    farm=farmsitting;  %将所有风电场视为farm
end


%% 计算各个场站的相似性和相关程度，使用验证集验证
    [scaler_valX,scaler_valY]=Divide(sum(Power(:,farmsitting),2),timeval,lookback);  %按照时间尺度对总体实际功率进行划分
    [scaler_testX,scaler_testY]=Divide(sum(Power(:,farmsitting),2),timetest,lookback);
Region_valFP=zeros(16,length(timeval));
Region_testFP=zeros(16,length(timetest)); %得到的是经过第一次加权b*PF后的初步区域功率值
RFfinal=RGF.*RGF.*RF;%RFfinal:最终计算各个风电场的权重b
for j=1:16
    b(j,:)=RFfinal(j,:)./sum(RFfinal(j,:));   %这里的b横坐标为时间尺度，纵坐标为各个场站的系数，16*N
    for k=farm  %认为group就是对应风电场的编号值
        group=find(k==farmsitting);
        Region_valFP(j,:)=Region_valFP(j,:)+b(j,group)*valY_prediction{group}(j,:);
        Region_testFP(j,:)=Region_testFP(j,:)+b(j,group)*testY_prediction{group}(j,:);
    end
    P_tempj=polyfit(Region_valFP(j,:),scaler_valY(j,:),1);  %计算多项式回归下对应的实际区域功率和预测加权功率
    P(j,:)=P_tempj; 
    Region_testfinal(j,:)=polyval(P_tempj,Region_testFP(j,:));  %经过多项式回归后测试结果
end

%% 最终结果测试
        Upscaling_Pred=Region_testfinal;  %最终的集群预测结果
        err_test=scaler_testY-Region_testfinal;    
        %测试结果
        testNum   =numel(err_test);
        
        Mfarm_Pred_Upscaling.RMSE =sqrt(sum(sum(err_test.^2))/testNum)/sum(capp(farmsitting));
        Mfarm_Pred_Upscaling.MAE  =sum(sum(abs(err_test)))/testNum;
        Mfarm_Pred_Upscaling.MAPE =sum(sum(abs(err_test./sum(capp(farmsitting)))))/testNum;
        Mfarm_Pred_Upscaling.MSE  =sum(sum(err_test.^2))/testNum;
        Mfarm_Pred_Upscaling.errMAX =max(abs(err_test));
          
        
        %分项结果
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

