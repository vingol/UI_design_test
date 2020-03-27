# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'forecast_QT.ui'
#
# Created by: PyQt5 UI code generator 5.9.2
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets
import pandas as pd
import numpy as np
from matplotlib.figure import Figure
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
# from main_cs import main_cs

class PlotCanvas(FigureCanvas):

    def __init__(self, parent=None, width=5, height=4, dpi=100):
        fig = Figure(figsize=(width, height), dpi=dpi)
        self.axes = fig.add_subplot(111)

        FigureCanvas.__init__(self, fig)
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

    def update_figure(self, data, start_time, end_time):

        self.axes.cla()
        data.loc[start_time:end_time].plot(ax=self.axes)
        self.draw()

class Ui_MainWindow_forecast(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(800, 600)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.line = QtWidgets.QFrame(self.centralwidget)
        self.line.setGeometry(QtCore.QRect(0, 40, 879, 3))
        self.line.setFrameShadow(QtWidgets.QFrame.Plain)
        self.line.setLineWidth(5)
        self.line.setFrameShape(QtWidgets.QFrame.HLine)
        self.line.setObjectName("line")
        self.pushButton_2 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_2.setGeometry(QtCore.QRect(510, 200, 241, 32))
        self.pushButton_2.setObjectName("pushButton_2")
        self.label = QtWidgets.QLabel(self.centralwidget)
        self.label.setGeometry(QtCore.QRect(20, 0, 371, 31))
        self.label.setObjectName("label")

        # self.graphicsView = QtWidgets.QGraphicsView(self.centralwidget)
        # self.graphicsView.setGeometry(QtCore.QRect(50, 130, 401, 331))
        # self.graphicsView.setMinimumSize(QtCore.QSize(401, 331))
        # self.graphicsView.setMaximumSize(QtCore.QSize(401, 331))
        # self.graphicsView.setObjectName("graphicsView")
        self.m = PlotCanvas(self, width=4, height=3)  # 实例化一个画布对象
        self.m.move(50, 130)

        self.layoutWidget_3 = QtWidgets.QWidget(self.centralwidget)
        self.layoutWidget_3.setGeometry(QtCore.QRect(490, 160, 300, 31))
        self.layoutWidget_3.setObjectName("layoutWidget_3")
        self.horizontalLayout_15 = QtWidgets.QHBoxLayout(self.layoutWidget_3)
        self.horizontalLayout_15.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout_15.setObjectName("horizontalLayout_15")
        self.label_24 = QtWidgets.QLabel(self.layoutWidget_3)
        self.label_24.setObjectName("label_24")
        self.horizontalLayout_15.addWidget(self.label_24)
        self.comboBox_8 = QtWidgets.QComboBox(self.layoutWidget_3)
        self.comboBox_8.setObjectName("comboBox_8")
        self.comboBox_8.addItem("")
        self.comboBox_8.setItemText(0, "")
        self.comboBox_8.addItem("")
        self.comboBox_8.addItem("")
        self.comboBox_8.addItem("")
        self.comboBox_8.addItem("")
        self.comboBox_8.addItem("")
        self.comboBox_8.addItem("")
        self.comboBox_8.addItem("")
        self.comboBox_8.addItem("")
        self.comboBox_8.addItem("")
        self.comboBox_8.addItem("")
        self.horizontalLayout_15.addWidget(self.comboBox_8)
        self.layoutWidget = QtWidgets.QWidget(self.centralwidget)
        self.layoutWidget.setGeometry(QtCore.QRect(20, 60, 723, 29))
        self.layoutWidget.setObjectName("layoutWidget")
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout(self.layoutWidget)
        self.horizontalLayout_2.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        self.label_25 = QtWidgets.QLabel(self.layoutWidget)
        self.label_25.setObjectName("label_25")
        self.horizontalLayout_2.addWidget(self.label_25)
        spacerItem = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout_2.addItem(spacerItem)
        self.horizontalLayout_21 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_21.setObjectName("horizontalLayout_21")
        self.label_26 = QtWidgets.QLabel(self.layoutWidget)
        self.label_26.setObjectName("label_26")
        self.horizontalLayout_21.addWidget(self.label_26)
        self.dateTimeEdit_9 = QtWidgets.QDateTimeEdit(self.layoutWidget)
        self.dateTimeEdit_9.setDateTime(QtCore.QDateTime(QtCore.QDate(2017, 1, 1), QtCore.QTime(0, 0, 0)))
        self.dateTimeEdit_9.setObjectName("dateTimeEdit_9")
        self.dateTimeEdit_9.setDisplayFormat("yyyy/MM/dd HH-mm-ss")
        self.horizontalLayout_21.addWidget(self.dateTimeEdit_9)
        self.horizontalLayout_2.addLayout(self.horizontalLayout_21)
        spacerItem1 = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout_2.addItem(spacerItem1)
        self.horizontalLayout_22 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_22.setObjectName("horizontalLayout_22")
        self.label_27 = QtWidgets.QLabel(self.layoutWidget)
        self.label_27.setObjectName("label_27")
        self.horizontalLayout_22.addWidget(self.label_27)
        self.dateTimeEdit_10 = QtWidgets.QDateTimeEdit(self.layoutWidget)
        self.dateTimeEdit_10.setDateTime(QtCore.QDateTime(QtCore.QDate(2017, 1, 1), QtCore.QTime(0, 0, 0)))
        self.dateTimeEdit_10.setObjectName("dateTimeEdit_10")
        self.dateTimeEdit_10.setDisplayFormat("yyyy/MM/dd HH-mm-ss")
        self.horizontalLayout_22.addWidget(self.dateTimeEdit_10)
        self.horizontalLayout_2.addLayout(self.horizontalLayout_22)
        self.widget = QtWidgets.QWidget(self.centralwidget)
        self.widget.setGeometry(QtCore.QRect(530, 290, 229, 111))
        self.widget.setObjectName("widget")
        self.gridLayout = QtWidgets.QGridLayout(self.widget)
        self.gridLayout.setContentsMargins(0, 0, 0, 0)
        self.gridLayout.setObjectName("gridLayout")
        self.label_2 = QtWidgets.QLabel(self.widget)
        self.label_2.setObjectName("label_2")
        self.gridLayout.addWidget(self.label_2, 0, 0, 1, 1)
        self.label_3 = QtWidgets.QLabel(self.widget)
        self.label_3.setObjectName("label_3")
        self.gridLayout.addWidget(self.label_3, 0, 1, 1, 1)
        self.label_4 = QtWidgets.QLabel(self.widget)
        self.label_4.setObjectName("label_4")
        self.gridLayout.addWidget(self.label_4, 1, 0, 1, 1)
        self.lineEdit = QtWidgets.QLineEdit(self.widget)
        self.lineEdit.setObjectName("lineEdit")
        self.gridLayout.addWidget(self.lineEdit, 1, 1, 1, 1)
        self.label_5 = QtWidgets.QLabel(self.widget)
        self.label_5.setObjectName("label_5")
        self.gridLayout.addWidget(self.label_5, 2, 0, 1, 1)
        self.lineEdit_2 = QtWidgets.QLineEdit(self.widget)
        self.lineEdit_2.setObjectName("lineEdit_2")
        self.gridLayout.addWidget(self.lineEdit_2, 2, 1, 1, 1)
        self.label_6 = QtWidgets.QLabel(self.widget)
        self.label_6.setObjectName("label_6")
        self.gridLayout.addWidget(self.label_6, 3, 0, 1, 1)
        self.lineEdit_3 = QtWidgets.QLineEdit(self.widget)
        self.lineEdit_3.setObjectName("lineEdit_3")
        self.gridLayout.addWidget(self.lineEdit_3, 3, 1, 1, 1)
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 800, 22))
        self.menubar.setObjectName("menubar")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

        # self.pushButton_2.clicked.connect(hello)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
        self.pushButton_2.setText(_translate("MainWindow", "显示预测结果"))
        self.label.setText(_translate("MainWindow", "<html><head/><body><p><span style=\" font-family:\'等线\'; font-size:24pt; color:#000000;\">风/光电场关联模式识别</span></p><p><br/></p></body></html>"))
        self.label_24.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">选择预测时间尺度：</span></p></body></html>"))
        self.comboBox_8.setItemText(1, _translate("MainWindow", "15min"))
        self.comboBox_8.setItemText(2, _translate("MainWindow", "30min"))
        self.comboBox_8.setItemText(3, _translate("MainWindow", "45min"))
        self.comboBox_8.setItemText(4, _translate("MainWindow", "1h"))
        self.comboBox_8.setItemText(5, _translate("MainWindow", "1.5h"))
        self.comboBox_8.setItemText(6, _translate("MainWindow", "2h"))
        self.comboBox_8.setItemText(7, _translate("MainWindow", "2.5h"))
        self.comboBox_8.setItemText(8, _translate("MainWindow", "3h"))
        self.comboBox_8.setItemText(9, _translate("MainWindow", "3.5h"))
        self.comboBox_8.setItemText(10, _translate("MainWindow", "4h"))
        self.label_25.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">功率预测曲线</span></p></body></html>"))
        self.label_26.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">开始时间：</span></p></body></html>"))
        self.label_27.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">截止时间：</span></p></body></html>"))
        self.label_2.setText(_translate("MainWindow", "指标"))
        self.label_3.setText(_translate("MainWindow", "数值"))
        self.label_4.setText(_translate("MainWindow", "均方根误差/MW"))
        self.label_5.setText(_translate("MainWindow", "合格率%"))
        self.label_6.setText(_translate("MainWindow", "准确率%"))

    def plot_(self):
        import datetime
        start_time = self.dateTimeEdit_9.text()
        end_time = self.dateTimeEdit_10.text()
        # y_hat_all, y_true_all, RMSE_ = main_cs()
        # print(input_data[:10])
        # self.m.update_figure(y_hat_all['var1(t)'], self.str_datetime(start_time), self.str_datetime(end_time))

