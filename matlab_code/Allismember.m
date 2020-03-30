function [idsam,ids] = Allismember(Tstar,Mfarm_Partition)
%用于判断当前排列组合下原来partition下的子集
%   输入：Tstar:组合排序的方式 N*1
%         Mfarm_Partition:原有的排列组合
%   输出: idsam:剩下包含Tstar排列方式的排序编号
N=length(Tstar); ids=zeros(size(Mfarm_Partition,1),1);  %
for i=1:size(Mfarm_Partition,1)
    H=0;  %判断是否全部包含于原有排序中
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

