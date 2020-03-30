# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'UI_pattern.ui'
#
# Created by: PyQt5 UI code generator 5.9.2
#
# WARNING! All changes made in this file will be lost!

import sys
import base64
import matlab
import pickle
import TCDPF_train
import libTCDPF_test
import pandas as pd
import numpy as np
import scipy.io as scio
from datetime import timedelta
from images.cloud_corr_jpg import img as cloud_corr
from images.wind_corr_jpg import img as wind_corr
from images.map_png import img as map_img
from PyQt5.QtWidgets import QApplication, QMainWindow
from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
import matplotlib.pyplot as plt
from matplotlib.figure import Figure
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas

tmp = open('cloud_corr.jpg', 'wb')        #创建临时的文件
tmp.write(base64.b64decode(cloud_corr))    ##把这个one图片解码出来，写入文件中去。
tmp.close()

tmp = open('wind_corr.jpg', 'wb')        #创建临时的文件
tmp.write(base64.b64decode(wind_corr))    ##把这个one图片解码出来，写入文件中去。
tmp.close()

tmp = open('map_img.png', 'wb')        #创建临时的文件
tmp.write(base64.b64decode(map_img))    ##把这个one图片解码出来，写入文件中去。
tmp.close()

class PlotCanvas(FigureCanvas):

    def __init__(self, parent=None, width=5, height=4, dpi=100):
        self.fig = Figure(figsize=(width, height), dpi=dpi)
        # self.axes = self.fig.add_subplot(111)

        FigureCanvas.__init__(self, self.fig)
        self.setParent(parent)

        FigureCanvas.setSizePolicy(self,
                                   QSizePolicy.Expanding,
                                   QSizePolicy.Expanding)
        FigureCanvas.updateGeometry(self)
        # self.init_plot()#打开App时可以初始化图片
        # self.plot()

    def plot(self):

        timer = QTimer(self)
        timer.timeout.connect(self.update_figure)
        timer.start(100)

    def init_plot(self, data, date=1):

        data[date * 96: (date + 1) * 96].plot(ax=self.axes)
        self.draw()

    def update_figure(self, points, result, map_img):

        X = list(map(lambda x: x[0], points))
        Y = list(map(lambda x: x[1], points))

        rect = [0.1, 0.1, 0.8, 0.8]
        #     scatterMarkers = ['s', 'o', '^', '8','p', 'd', 'v', 'h', '<', ">"]
        axprops = dict(xticks=[], yticks=[])
        ax0 = self.fig.add_axes(rect, label='ax0', **axprops)
        ax0.imshow(map_img)

        ax1 = self.fig.add_axes(rect, label='ax1', frameon=False)
        #     markerStyle = scatterMarkers[random.randint(1,6)%len(scatterMarkers)]
        for i in range(len(result)):

            x = np.array(X)[result[i]]
            y = np.array(Y)[result[i]]

            ax1.scatter(x, y)

            for j in range(len(x)):
                ax1.annotate(result[i][j] + 1, xy=(x[j], y[j]), xytext=(x[j] + 0.01, y[j] + 0.01))
        self.draw()

class Ui_MainWindow_pattern_true(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(800, 600)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.label = QtWidgets.QLabel(self.centralwidget)
        self.label.setGeometry(QtCore.QRect(20, 0, 371, 31))
        self.label.setObjectName("label")
        self.line = QtWidgets.QFrame(self.centralwidget)
        self.line.setGeometry(QtCore.QRect(0, 40, 879, 3))
        self.line.setFrameShadow(QtWidgets.QFrame.Plain)
        self.line.setLineWidth(5)
        self.line.setFrameShape(QtWidgets.QFrame.HLine)
        self.line.setObjectName("line")
        self.layoutWidget = QtWidgets.QWidget(self.centralwidget)
        self.layoutWidget.setGeometry(QtCore.QRect(20, 60, 723, 29))
        self.layoutWidget.setObjectName("layoutWidget")
        self.horizontalLayout = QtWidgets.QHBoxLayout(self.layoutWidget)
        self.horizontalLayout.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.label_17 = QtWidgets.QLabel(self.layoutWidget)
        self.label_17.setObjectName("label_17")
        self.horizontalLayout.addWidget(self.label_17)
        spacerItem = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout.addItem(spacerItem)
        self.horizontalLayout_16 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_16.setObjectName("horizontalLayout_16")
        self.label_19 = QtWidgets.QLabel(self.layoutWidget)
        self.label_19.setObjectName("label_19")
        self.horizontalLayout_16.addWidget(self.label_19)
        self.dateTimeEdit_7 = QtWidgets.QDateTimeEdit(QtCore.QDateTime(QtCore.QDate(2017, 2, 1), QtCore.QTime(0, 0, 0)))
        self.dateTimeEdit_7.setObjectName("dateTimeEdit_7")
        self.dateTimeEdit_7.setDisplayFormat("yyyy/MM/dd HH-mm-ss")
        self.horizontalLayout_16.addWidget(self.dateTimeEdit_7)
        self.horizontalLayout.addLayout(self.horizontalLayout_16)
        spacerItem1 = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout.addItem(spacerItem1)
        self.horizontalLayout_17 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_17.setObjectName("horizontalLayout_17")
        self.label_20 = QtWidgets.QLabel(self.layoutWidget)
        self.label_20.setObjectName("label_20")
        self.horizontalLayout_17.addWidget(self.label_20)
        self.dateTimeEdit_8 = QtWidgets.QDateTimeEdit(QtCore.QDateTime(QtCore.QDate(2017, 2, 1), QtCore.QTime(0, 0, 0)))
        self.dateTimeEdit_8.setObjectName("dateTimeEdit_8")
        self.dateTimeEdit_8.setDisplayFormat("yyyy/MM/dd HH-mm-ss")
        self.horizontalLayout_17.addWidget(self.dateTimeEdit_8)
        self.horizontalLayout.addLayout(self.horizontalLayout_17)
        self.widget = QtWidgets.QWidget(self.centralwidget)
        self.widget.setGeometry(QtCore.QRect(50, 130, 676, 333))
        self.widget.setObjectName("widget")
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout(self.widget)
        self.horizontalLayout_2.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        # self.graphicsView = QtWidgets.QGraphicsView(self.widget)
        # self.graphicsView.setMinimumSize(QtCore.QSize(401, 331))
        # self.graphicsView.setMaximumSize(QtCore.QSize(401, 331))
        # self.graphicsView.setObjectName("graphicsView")
        self.m = PlotCanvas(self, width=5, height=4)  # 实例化一个画布对象
        self.m.move(300, 160)
        self.horizontalLayout_2.addWidget(self.m)
        # self.horizontalLayout_2.addWidget(self.graphicsView)
        self.verticalLayout_3 = QtWidgets.QVBoxLayout()
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.verticalLayout = QtWidgets.QVBoxLayout()
        self.verticalLayout.setObjectName("verticalLayout")
        self.horizontalLayout_14 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_14.setObjectName("horizontalLayout_14")
        self.label_18 = QtWidgets.QLabel(self.widget)
        self.label_18.setObjectName("label_18")
        self.horizontalLayout_14.addWidget(self.label_18)
        self.comboBox_4 = QtWidgets.QComboBox(self.widget)
        self.comboBox_4.setObjectName("comboBox_4")
        self.comboBox_4.addItem("")
        self.comboBox_4.setItemText(0, "")
        self.comboBox_4.addItem("")
        self.comboBox_4.addItem("")
        self.horizontalLayout_14.addWidget(self.comboBox_4)
        self.verticalLayout.addLayout(self.horizontalLayout_14)
        self.pushButton = QtWidgets.QPushButton(self.widget)
        self.pushButton.setObjectName("pushButton")
        self.verticalLayout.addWidget(self.pushButton)
        self.pushButton_2 = QtWidgets.QPushButton(self.widget)
        self.pushButton_2.setObjectName("pushButton_2")
        self.verticalLayout.addWidget(self.pushButton_2)
        self.verticalLayout_3.addLayout(self.verticalLayout)
        self.verticalLayout_2 = QtWidgets.QVBoxLayout()
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.horizontalLayout_18 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_18.setObjectName("horizontalLayout_18")
        self.label_21 = QtWidgets.QLabel(self.widget)
        self.label_21.setObjectName("label_21")
        self.horizontalLayout_18.addWidget(self.label_21)
        self.comboBox_5 = QtWidgets.QComboBox(self.widget)
        self.comboBox_5.setObjectName("comboBox_5")
        self.comboBox_5.addItem("")
        self.comboBox_5.setItemText(0, "")
        self.comboBox_5.addItem("")
        self.horizontalLayout_18.addWidget(self.comboBox_5)
        self.verticalLayout_2.addLayout(self.horizontalLayout_18)
        self.pushButton_4 = QtWidgets.QPushButton(self.widget)
        self.pushButton_4.setObjectName("pushButton_4")
        self.verticalLayout_2.addWidget(self.pushButton_4)
        self.pushButton_3 = QtWidgets.QPushButton(self.widget)
        self.pushButton_3.setObjectName("pushButton_3")
        self.verticalLayout_2.addWidget(self.pushButton_3)
        self.verticalLayout_3.addLayout(self.verticalLayout_2)
        self.horizontalLayout_19 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_19.setObjectName("horizontalLayout_19")
        self.label_22 = QtWidgets.QLabel(self.widget)
        self.label_22.setObjectName("label_22")
        self.horizontalLayout_19.addWidget(self.label_22)
        self.comboBox_6 = QtWidgets.QComboBox(self.widget)
        self.comboBox_6.setObjectName("comboBox_6")
        self.comboBox_6.addItem("")
        self.comboBox_6.setItemText(0, "")
        self.comboBox_6.addItem("")
        self.comboBox_6.addItem("")
        self.comboBox_6.addItem("")
        self.comboBox_6.addItem("")
        self.comboBox_6.addItem("")
        self.comboBox_6.addItem("")
        self.comboBox_6.addItem("")
        self.comboBox_6.addItem("")
        self.horizontalLayout_19.addWidget(self.comboBox_6)
        self.verticalLayout_3.addLayout(self.horizontalLayout_19)
        self.horizontalLayout_2.addLayout(self.verticalLayout_3)
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 800, 22))
        self.menubar.setObjectName("menubar")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.pushButton_2.clicked.connect(self.show_wind_pattern)
        self.pushButton_3.clicked.connect(self.slot_2)
        self.pushButton.clicked.connect(self.load_wind_data)


        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
        self.label.setText(_translate("MainWindow", "<html><head/><body><p><span style=\" font-family:\'等线\'; font-size:24pt; color:#000000;\">风/光电场关联模式识别</span></p><p><br/></p></body></html>"))
        self.label_17.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">关联模式信息</span></p></body></html>"))
        self.label_19.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">开始时间：</span></p></body></html>"))
        self.label_20.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">截止时间：</span></p></body></html>"))
        self.label_18.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">选择功率预测方法：</span></p></body></html>"))
        self.comboBox_4.setItemText(1, _translate("MainWindow", "SVR"))
        self.comboBox_4.setItemText(2, _translate("MainWindow", "ELM"))
        self.pushButton.setText(_translate("MainWindow", "导入数据"))
        self.pushButton_2.setText(_translate("MainWindow", "风电电站关联模式分析"))
        self.label_21.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">选择云图预测方法：</span></p></body></html>"))
        self.comboBox_5.setItemText(1, _translate("MainWindow", "频域"))
        self.pushButton_4.setText(_translate("MainWindow", "导入数据"))
        self.pushButton_3.setText(_translate("MainWindow", "光伏电站关联模式分析"))
        self.label_22.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">选择关联时间尺度：</span></p></body></html>"))
        self.comboBox_6.setItemText(1, _translate("MainWindow", "30min"))
        self.comboBox_6.setItemText(2, _translate("MainWindow", "1h"))
        self.comboBox_6.setItemText(3, _translate("MainWindow", "1.5h"))
        self.comboBox_6.setItemText(4, _translate("MainWindow", "2h"))
        self.comboBox_6.setItemText(5, _translate("MainWindow", "2.5h"))
        self.comboBox_6.setItemText(6, _translate("MainWindow", "3h"))
        self.comboBox_6.setItemText(7, _translate("MainWindow", "3.5h"))
        self.comboBox_6.setItemText(8, _translate("MainWindow", "4h"))

    def get_time_horizen(self,i):
        # 获取数据类型
        global time_horizen
        time_horizen = i

    def slot_1(self):
        self.graphicsView.setStyleSheet(
            "image: url(wind_corr.jpg);\n"
            "border-image: url(wind_corr.jpg);")

    def slot_2(self):
        self.graphicsView.setStyleSheet(
            "image: url(map.png);\n"
            "border-image: url(map.png);")

    def load_wind_data(self):
        global df_wind_power, cappseries

        Power = scio.loadmat("matlab_data/wind_power_jilin.mat")
        df_wind_power = pd.DataFrame(Power['Power'])
        df_wind_power.index = pd.date_range(start='2017-01-01', periods=len(df_wind_power[0]), freq='15min')

        print(df_wind_power.shape)

        capp = scio.loadmat("matlab_data/wind_power_cap.mat")
        cappseries = matlab.double(capp['capp'].tolist())

    def show_wind_pattern(self):

        start_time = self.dateTimeEdit_7.text()
        end_time = self.dateTimeEdit_8.text()

        # set train data and train
        train_start = pd.to_datetime(str(start_time))+timedelta(days=-10)
        train_end = pd.to_datetime(str(start_time))
        wind_power_train = df_wind_power.loc[train_start:train_end]
        wind_train_matlab = matlab.double(np.array(wind_power_train).tolist())

        # engine = matlab.engine.start_matlab()
        # engine.addpath(r'C:/Users/Camille/PycharmProjects/UI_design_test/matlab_code', nargout=0)
        # engine.addpath(r'C:/Users/Camille/PycharmProjects/UI_design_test/matlab_data', nargout=0)

        cluster, lag = 4, 5  # 分别设置聚类个数和延迟值
        a = TCDPF_train.initialize()
        trainResult, Ch_trainResult = a.TCDPF_train(
            wind_train_matlab, cappseries, cluster, lag, nargout=2)  # 第一个是训练功率数据，第二个是场站容量，第三个是选择的聚类个数，第四个是超前步数
        a.terminate()

        # test
        K = 10
        test_start = pd.to_datetime(str(start_time))+timedelta(minutes=-(K+lag+15+1)*15)
        test_end = pd.to_datetime(str(start_time))+timedelta(minutes=14*15)
        wind_power_test = df_wind_power.loc[test_start:test_end]
        wind_test_matlab = matlab.double(np.array(wind_power_test).tolist())

        print(wind_power_test.shape)

        b = libTCDPF_test.initialize()
        Better_Pred, Mfarm_Pred_Better, Ch_test_Better, Better_code, Mfarm_Partition = b.TCDPF_test(
            wind_test_matlab, cappseries, 10, nargout=5)  # 第一个是训练功率数据，第二个是场站容量，第三个是持续时间(K)
        b.terminate()

        # result
        result = (np.array(Better_code).reshape(-1) - 1).astype(int)
        time_horizen = 1

        f = open('points.txt', 'rb')
        points = pickle.load(f)
        f.close()

        map_img = plt.imread('map_img.png')

        print(map(lambda x: np.array(x).astype(int), [(1,2),(3,4,5)]))
        print(list(map(lambda x: np.array(x).astype(int), [(1, 2), (3, 4, 5)])))

        result_ = list(map(lambda x: np.array(x).astype(int), Mfarm_Partition[result[time_horizen]]))

        result_i = list(map(lambda x: (x - 1).tolist()[0], result_))

        # print(list(map(lambda x:np.array(x).astype(int), Mfarm_Partition[result[time_horizen]])))
        self.m.update_figure(points, result_i, map_img)
class MyWindow(QMainWindow, Ui_MainWindow_pattern_true):
    def __init__(self, parent=None):
        super(MyWindow, self).__init__(parent)
        self.setupUi(self)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    myWin = MyWindow()
    myWin.show()

    sys.exit(app.exec_())