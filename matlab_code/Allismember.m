function [idsam,ids] = Allismember(Tstar,Mfarm_Partition)
%�����жϵ�ǰ���������ԭ��partition�µ��Ӽ�
%   ���룺Tstar:�������ķ�ʽ N*1
%         Mfarm_Partition:ԭ�е��������
%   ���: idsam:ʣ�°���Tstar���з�ʽ��������
N=length(Tstar); ids=zeros(size(Mfarm_Partition,1),1);  %
for i=1:size(Mfarm_Partition,1)
    H=0;  %�ж��Ƿ�ȫ��������ԭ��������
    for j=1:size(Mfarm_Partition{i},2)
    for k=1:N
    H=H+all(ismember(Tstar{k},Mfarm_Partition{i}{j}));
    end  
    end
    if H==N
    ids(i)=1;
    end
end
   idsam=find(ids==1);
end

