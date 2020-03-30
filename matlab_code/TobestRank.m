function [RankMatrix] = TobestRank(farmsitting,testY_prediction,testreal,K,Pred_Code)
%�����������ݼ�������Ԥ�⻮��ˮƽ������������Ըı�
%����Ӧ��Set Partition�㷨�������Ϸ�Ϊ�����ǿգ�����Ϊ�գ�����Ϊȫ���Ӽ�֮����ʽ������Bell��
%��лMATLAB FILE�� Bruno Luong��2009����е��㷨����

%   Input��
%   ��糡�ı�ţ�farmsitting
%   Ԥ������testY_prediction ���շ�糡�ı�ŵĶ����ƽ��л��֣�Ӧ����2^N-1��
%   ��ʵ���ʣ�testreal
%   �жϳ�ǰ������ K  KΪ��ʱ�������г��Ȳ���
%   ��缯Ⱥ��ÿһ��������ÿһ��Ԥ��ʱ��߶��µ�Ԥ����ϵı��룬Pred_Code
%
%
%   Output��
%   ���������ֵ����ÿһ����ǰ�߶Ⱥ��������ֽ׶�Ԥ���������������е�����
%

%% ����Ԥ����
N=length(farmsitting);   %�����缯Ⱥ��ά��
Bel=Bell(N);          %��缯Ⱥ���ά��
% Mfarm_Partition=SetPartition(farmsitting);  %�������з�缯Ⱥ��ϣ��������ִ����糡�ı��
Index=SetPartition(N:-1:1);     %����Ĭ��farmsitting�ı���ǴӺ���ǰΪ1,2,3,4,5 ���������ڱ��һ��
% err_test=zeros(16,size(testreal,2),Bel);     %err_test ��ʾ���е�������
prediction=zeros(16,size(testreal,2),Bel);   %predcition ��ʾ���е���ϲ��Խ��
    if K
        RankMatrix=zeros(16,size(testreal,2)-(K+16-1));   %��¼ÿһ�������������ֵ  ���������KΪ��Ͳ�Ϊ��
    else
        RankMatrix=zeros(16,size(testreal,2));   %��¼ÿһ�������������ֵ
    end


%% �����������
    for i=1:Bel  %i��ʾ������缯Ⱥ�ĸ���
        for j=1:size(Index{i},2)  %�ж�ÿһ����Ⱥ���ֲ����ж��ٸ�������
            prediction(:,:,i)=prediction(:,:,i)+testY_prediction{sum(2.^(Index{i}{j}-1))};
        end
    end
    err_test=abs(repmat(testreal,1,1,Bel)-prediction);     %��ǰ��ȺԤ��ֵ��ʵ��ֵ�����
    [Allien,Indexing]=sort(err_test,3);  %Indexing����err_test����ÿһ��ÿһ�а����������еĽ��
     H2=reshape(Allien(1,K+16:size(testreal,2),:),size(testreal,2)-(K+16-1),Bel);
     H1=reshape(Indexing(1,K+16:size(testreal,2),:),size(testreal,2)-(K+16-1),Bel);
    if K
        for i=1:16     %����ÿ����Ӧ����С�����
            H=1;    %H��������
            for j=K+16:size(testreal,2)    %����ǰ��K+15�����ݣ�������Ϊ�жϵĽ������֤����
                RankMatrix(i,H)=Indexing(i,j,Pred_Code(i,H));  %�����Ӧѡ��ı�����������ż����е�����
                H=H+1;
            end
        end
    else
        for i=1:16     %����ÿ����Ӧ����С�����
            for j=1:size(testreal,2)    %����ǰ��K+15�����ݣ�������Ϊ�жϵĽ������֤����
                RankMatrix(i,j)=Indexing(i,j,Pred_Code(i,j));  %�����Ӧѡ��ı�����������ż����е�����
            end
        end


    end




end

