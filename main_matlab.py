import matlab
import matlab.engine
import numpy as np
import scipy.io as scio

Power = scio.loadmat("matlab_data/Power.mat")  # 读取风电数据（全年风电数据）
Powerseries = matlab.double(Power['Power'].tolist())

Powerseries = np.array(Power['Power'].tolist())
capp = scio.loadmat("matlab_data/farmsite.mat")  # 读取风电数据（各个风电场的装机容量）
cappseries = matlab.double(capp['capp'].tolist())

engine = matlab.engine.start_matlab()
engine.addpath(r'/Users/mayuan/Downloads/projects/simple_version/matlab_code',nargout=0)
engine.addpath(r'/Users/mayuan/Downloads/projects/simple_version/matlab_data',nargout=0)

# 假设需要训练数据是 3001:4000，则需要输入给模型的数据应为 3001-lag:4000+15
cluster, lag = 4, 5  # 分别设置聚类个数和延迟值
Powerseries_train = matlab.double(
    Powerseries[3001 - lag - 1:4000 + 16, :].tolist())
trainResult, Ch_trainResult = engine.TCDPF_train(
    Powerseries_train, cappseries, cluster, lag, nargout=2)  # 第一个是训练功率数据，第二个是场站容量，第三个是选择的聚类个数，第四个是超前步数

# 假设需要测试数据是 4001:4500，则需要输入给模型的数据应为 4001-lag-K-15:4500+15 其中K是第三个输入
K = 10  # 设置平均值
Powerseries_test = matlab.double(
    Powerseries[4001 - lag - K - 15 - 1:4001 + 15, :].tolist())
Better_Pred, Mfarm_Pred_Better, Ch_test_Better, Better_code, Mfarm_Partition = engine.TCDPF_test(
    Powerseries_test, cappseries, 10, nargout=5)  # 第一个是训练功率数据，第二个是场站容量，第三个是持续时间(K)
Code = int(Better_code[0][1]) - 1  # 假设code为最优划分的编号,这里编号需要转码

result = (np.array(Better_code).reshape(-1)-1).astype(int)

names = locals()
for i in range(16):
    names['result_%s'%(i+1)] = list(map(lambda x:np.array(x), Mfarm_Partition[result[i]]))
