function [dataX,dataY] = Divide(powerseries,time,lookback,ps_data)
%Divide 致敬divideData,这里是更新的训练集和测试集划分方式，力求一次将数据划分直接到位
%   input:powerseries: 输入的功率值
%         time: 对应序列输入时间，ex 1:1000，从头都是1:1000
%         lookback: 历史输入模型的提前个数
%         ps_data: mapminmax归一化对应的数据，这里使用apply统一归一化
%   output:dataX:输入矩阵，lookback*time
%          dataY:输出矩阵，16*time
dimY=16;datatemp=powerseries(time(1)-lookback:time(end)+dimY-1);
datatemp=datatemp(:); %将数据转变为列向量
if nargin==4    %如果输入ps_data 即需要归一化处理时
data=mapminmax('apply',datatemp',ps_data);  %应用转变的变量
else
    data=datatemp';
end

data=data(:);  %将数据转变为列向量
dataX=[];
dataY=[];
[Row,Column]=size(data);   %行表示数据长度，列表示输入维数
for i=1:(length(data)-lookback-dimY+1)  %一个点的前多少个点（包括自己）是历史依据，后多少个点是预测目标
    a=data(i:(i+(lookback-1)),1:Column);
    dataX(:,:,i)=a ;                     %   imresize
    b=data((i+lookback):(i+lookback+dimY-1),1:Column);
    dataY(:,:,i)=b;
end

dataX=reshape(dataX,lookback*Column,length(data)-lookback-dimY+1);  %每一列都是一个样本，总列数代表样本总数 但是这里的样本比能抽出的样本N-m+1少了一个1
dataY=reshape(dataY,dimY*Column,length(data)-lookback-dimY+1);

end

