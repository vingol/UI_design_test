function [dataX,dataY] = Divide(powerseries,time,lookback,ps_data)
%Divide �¾�divideData,�����Ǹ��µ�ѵ�����Ͳ��Լ����ַ�ʽ������һ�ν����ݻ���ֱ�ӵ�λ
%   input:powerseries: ����Ĺ���ֵ
%         time: ��Ӧ��������ʱ�䣬ex 1:1000����ͷ����1:1000
%         lookback: ��ʷ����ģ�͵���ǰ����
%         ps_data: mapminmax��һ����Ӧ�����ݣ�����ʹ��applyͳһ��һ��
%   output:dataX:�������lookback*time
%          dataY:�������16*time
dimY=16;datatemp=powerseries(time(1)-lookback:time(end)+dimY-1);
datatemp=datatemp(:); %������ת��Ϊ������
if nargin==4    %�������ps_data ����Ҫ��һ������ʱ
data=mapminmax('apply',datatemp',ps_data);  %Ӧ��ת��ı���
else
    data=datatemp';
end

data=data(:);  %������ת��Ϊ������
dataX=[];
dataY=[];
[Row,Column]=size(data);   %�б�ʾ���ݳ��ȣ��б�ʾ����ά��
for i=1:(length(data)-lookback-dimY+1)  %һ�����ǰ���ٸ��㣨�����Լ�������ʷ���ݣ�����ٸ�����Ԥ��Ŀ��
    a=data(i:(i+(lookback-1)),1:Column);
    dataX(:,:,i)=a ;                     %   imresize
    b=data((i+lookback):(i+lookback+dimY-1),1:Column);
    dataY(:,:,i)=b;
end

dataX=reshape(dataX,lookback*Column,length(data)-lookback-dimY+1);  %ÿһ�ж���һ�������������������������� ����������������ܳ��������N-m+1����һ��1
dataY=reshape(dataY,dimY*Column,length(data)-lookback-dimY+1);

end

