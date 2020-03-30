function [Mfarm_Pred_Better,Pred_Code,Better_Pred,Ch_test_Better,Pred_Sorting] = AutoPredict(farmsitting,testY_prediction,testreal,capp,K)
%�����������ݼ�������Ԥ�⻮��ˮƽ������������Ըı�
%����Ӧ��Set Partition�㷨�������Ϸ�Ϊ�����ǿգ�����Ϊ�գ�����Ϊȫ���Ӽ�֮����ʽ������Bell��
%��лMATLAB FILE�� Bruno Luong��2009����е��㷨����

%   Input��
%   ��糡�ı�ţ�farmsitting
%   Ԥ������testY_prediction ���շ�糡�ı�ŵĶ����ƽ��л��֣�Ӧ����2^N-1��
%   ��ʵ���ʣ�testreal
%   ��缯Ⱥװ��������capp ���е�װ������
%   �жϳ�ǰ������ K
%
%   Output��
%   ��缯Ⱥ��Ԥ��������Ԥ������Mfarm_Pred_Better
%   ��缯Ⱥ��ÿһ��������ÿһ��Ԥ��ʱ��߶��µ�Ԥ����ϵı��룬Pred_Code
%   ��缯Ⱥÿһ����������µõ�����ʵԤ����: Better_Pred
%   ��缯Ⱥ����Ԥ��ʱ��߶Ȼ��֣�ÿ��Ԥ��ʱ��߶��µõ��Ľ���Ԥ������Ch_test_Better
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
Mfarm_Pred_Better=struct('RMSE',zeros(1,1),'MAPE',zeros(1,1),'MSE',zeros(1,1),'MAE',zeros(1,1)); %Mfarm_Pred_Best,��¼�������ŵ�Ԥ����
% err_test=zeros(16,size(testreal,2),Bel);     %err_test ��ʾ���е�������
prediction=zeros(16,size(testreal,2),Bel);   %predcition ��ʾ���е���ϲ��Խ��
% bestcode=zeros(16,size(testreal,2));     %��¼ÿ����ǰ�����£�ÿ��������������ϱ��
Better_Pred=zeros(16,size(testreal,2)-(K+16-1));     %��¼ÿһ��������ÿһ����ǰԤ��߶������ŵ�Ԥ����
Ch_test_Better=struct('RMSE',zeros(16,1),'MAPE',zeros(16,1),'MSE',zeros(16,1),'MAE',zeros(16,1)); %Mfarm_prediction,��¼ÿ����ǰ�������������ŵ�Ԥ����
Pred_Code=zeros(16,size(testreal,2)-(K+16-1));   %��¼ÿһ�������������ֵ

%% �����������
    for i=1:Bel  %i��ʾ������缯Ⱥ�ĸ���
        for j=1:size(Index{i},2)  %�ж�ÿһ����Ⱥ���ֲ����ж��ٸ�������
            prediction(:,:,i)=prediction(:,:,i)+testY_prediction{sum(2.^(Index{i}{j}-1))};
        end
    end
    err_test=repmat(testreal,1,1,Bel)-prediction;     %��ǰ��ȺԤ��ֵ��ʵ��ֵ�����
 %   [~,bestcode]=min(abs(err_test),[],3);    %������С��������bestcode��ʾ��Ӧ�ı��

    steping=1;   %�۲쳬ǰԤ��߶�
    err_detect=zeros(Bel,size(testreal,2));  %���ĳһ��Ԥ�ⲽ���±Ƚϲ�ͬģ�͵����ˮƽ
    for j=1:size(testreal,2)
    err_detect(:,j)=err_test(steping,j,:);
    end
    
    for i=1:16     %����ÿ����Ӧ����С�����
        H=1;    %H��������
        for j=K+16:size(testreal,2)    %����ǰ��K+15�����ݣ�������Ϊ�жϵĽ������֤����
            errK_temp=sum(abs(err_test(i,j-K-(i-1):j-i,:)),2);   %������� �����Ÿ�����Ҫԭ���ǲ�ͬʱ��߶ȵĽṹ��ͬ
            %errK_temp=sum((err_test(i,j-K-(i-1):j-i,:).^2),2);
            [~,code_temp]=min(errK_temp,[],3);   %��ʱ���ŵı��
            Pred_Code(i,H)=code_temp;    %���Ԥ�����ű��
            if i==1
            [~,code_temp1]=sort(errK_temp(:));   %��ʱ���ŵı��
            Pred_Sorting(:,H)=code_temp1;
            end
            H=H+1;
        end
    end
    clear err_test   %�������̫���ˣ��Ͽ�ȥ��
    for i=1:16     %����ÿ����Ӧ����С�����
        H=1; 
        for j=K+16:size(testreal,2)
            Better_Pred(i,H)=prediction(i,j,Pred_Code(i,H)); %ÿ�����ŵ���ϵĽ��������Best_Pred��
            H=H+1;      
        end
    end
   clear prediction   %�������̫���ˣ��Ͽ�ȥ��

err_test=testreal(:,K+16:size(testreal,2))-Better_Pred;   %ע���������µ�err_test������һ������
testNum   =numel(err_test);

testResult.test_RMSE =sqrt(sum(sum(err_test.^2))/testNum)/sum(capp(farmsitting));
testResult.test_MAE  =sum(sum(abs(err_test)))/testNum;
testResult.test_MAPE =sum(sum(abs(err_test./sum(capp(farmsitting)))))/testNum;
testResult.test_MSE  =sum(sum(err_test.^2))/testNum;
testResult.test_errMAX =max(abs(err_test));

Mfarm_Pred_Better.RMSE=testResult.test_RMSE; %��¼ÿһ����ϵ�Ԥ��ֵ
Mfarm_Pred_Better.MAPE=testResult.test_MAPE; %��¼ÿһ����ϵ�Ԥ��ֵ
Mfarm_Pred_Better.MSE=testResult.test_MSE; %��¼ÿһ����ϵ�Ԥ��ֵ
Mfarm_Pred_Better.MAE=testResult.test_MAE; %��¼ÿһ����ϵ�Ԥ��ֵ


for i=1:size(err_test,1)
    ChildtestNum   =size(err_test,2);
    
    Ch_test_Better.RMSE(i) =sqrt(sum(err_test(i,:).^2)/ChildtestNum)/sum(capp(farmsitting));
    Ch_test_Better.MAE(i)  =sum(abs(err_test(i,:)))/ChildtestNum;
    Ch_test_Better.MAPE(i) =sum(abs(err_test(i,:))./sum(capp(farmsitting)))/ChildtestNum;
    Ch_test_Better.MSE(i)  =sum(sum(err_test(i,:).^2))/ChildtestNum;  
end


end

%���Խ��
