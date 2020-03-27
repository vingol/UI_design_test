# # -*- coding: utf-8 -*-
#
# # Form implementation generated from reading ui file 'UI_1.ui'
# #
# # Created by: PyQt5 UI code generator 5.9.2
# #
# # WARNING! All changes made in this file will be lost!
# from PyQt5 import QtCore, QtGui, QtWidgets
# import pandas as pd
# import numpy as np
# from matplotlib.figure import Figure
# from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
# from PyQt5.QtWidgets import *
# from PyQt5.QtCore import *
#
# class PlotCanvas(FigureCanvas):
#
#     def __init__(self, parent=None, width=5, height=4, dpi=100):
#         fig = Figure(figsize=(width, height), dpi=dpi)
#         self.axes = fig.add_subplot(111)
#
#         FigureCanvas.__init__(self, fig)
#         self.setParent(parent)
#
#         FigureCanvas.setSizePolicy(self,
#                                    QSizePolicy.Expanding,
#                                    QSizePolicy.Expanding)
#         FigureCanvas.updateGeometry(self)
#         # self.init_plot()#打开App时可以初始化图片
#         # self.plot()
#
#     def plot(self):
#
#         timer = QTimer(self)
#         timer.timeout.connect(self.update_figure)
#         timer.start(100)
#
#     def init_plot(self, data, date=1):
#
#         data[date * 96: (date + 1) * 96].plot(ax=self.axes)
#         self.draw()
#
#     def update_figure(self, data, date=1):
#
#         self.axes.cla()
#         data[date * 96: (date + 1) * 96].plot(ax=self.axes)
#         self.draw()
#
# class Ui_MainWindow(object):
#     def setupUi(self, MainWindow):
#         MainWindow.setObjectName("MainWindow")
#         MainWindow.resize(800, 600)
#         self.centralwidget = QtWidgets.QWidget(MainWindow)
#         self.centralwidget.setObjectName("centralwidget")
#         self.line = QtWidgets.QFrame(self.centralwidget)
#         self.line.setGeometry(QtCore.QRect(0, 60, 879, 3))
#         self.line.setFrameShadow(QtWidgets.QFrame.Plain)
#         self.line.setLineWidth(5)
#         self.line.setFrameShape(QtWidgets.QFrame.HLine)
#         self.line.setObjectName("line")
#         self.label = QtWidgets.QLabel(self.centralwidget)
#         self.label.setGeometry(QtCore.QRect(20, 20, 371, 31))
#         self.label.setObjectName("label")
#         self.pushButton = QtWidgets.QPushButton(self.centralwidget)
#         self.pushButton.setGeometry(QtCore.QRect(110, 380, 113, 32))
#         self.pushButton.setObjectName("pushButton")
#         self.widget = QtWidgets.QWidget(self.centralwidget)
#         self.widget.setGeometry(QtCore.QRect(40, 110, 255, 31))
#         self.widget.setObjectName("widget")
#         self.horizontalLayout = QtWidgets.QHBoxLayout(self.widget)
#         self.horizontalLayout.setContentsMargins(0, 0, 0, 0)
#         self.horizontalLayout.setObjectName("horizontalLayout")
#         self.label_2 = QtWidgets.QLabel(self.widget)
#         self.label_2.setObjectName("label_2")
#         self.horizontalLayout.addWidget(self.label_2)
#         self.comboBox = QtWidgets.QComboBox(self.widget)
#         self.comboBox.setObjectName("comboBox")
#         self.comboBox.addItem("")
#         self.comboBox.setItemText(0, "")
#         self.comboBox.addItem("")
#         self.comboBox.addItem("")
#         self.horizontalLayout.addWidget(self.comboBox)
#         self.lineEdit = QtWidgets.QLineEdit(self.widget)
#         self.lineEdit.setObjectName("lineEdit")
#         self.horizontalLayout.addWidget(self.lineEdit)
#         self.widget1 = QtWidgets.QWidget(self.centralwidget)
#         self.widget1.setGeometry(QtCore.QRect(41, 258, 225, 27))
#         self.widget1.setObjectName("widget1")
#         self.horizontalLayout_2 = QtWidgets.QHBoxLayout(self.widget1)
#         self.horizontalLayout_2.setContentsMargins(0, 0, 0, 0)
#         self.horizontalLayout_2.setObjectName("horizontalLayout_2")
#         self.label_5 = QtWidgets.QLabel(self.widget1)
#         self.label_5.setObjectName("label_5")
#         self.horizontalLayout_2.addWidget(self.label_5)
#         self.lineEdit_3 = QtWidgets.QLineEdit(self.widget1)
#         self.lineEdit_3.setObjectName("lineEdit_3")
#         self.horizontalLayout_2.addWidget(self.lineEdit_3)
#         self.widget2 = QtWidgets.QWidget(self.centralwidget)
#         self.widget2.setGeometry(QtCore.QRect(41, 298, 225, 27))
#         self.widget2.setObjectName("widget2")
#         self.horizontalLayout_3 = QtWidgets.QHBoxLayout(self.widget2)
#         self.horizontalLayout_3.setContentsMargins(0, 0, 0, 0)
#         self.horizontalLayout_3.setObjectName("horizontalLayout_3")
#         self.label_6 = QtWidgets.QLabel(self.widget2)
#         self.label_6.setObjectName("label_6")
#         self.horizontalLayout_3.addWidget(self.label_6)
#         self.lineEdit_4 = QtWidgets.QLineEdit(self.widget2)
#         self.lineEdit_4.setObjectName("lineEdit_4")
#         self.horizontalLayout_3.addWidget(self.lineEdit_4)
#         self.widget3 = QtWidgets.QWidget(self.centralwidget)
#         self.widget3.setGeometry(QtCore.QRect(40, 170, 264, 31))
#         self.widget3.setObjectName("widget3")
#         self.horizontalLayout_4 = QtWidgets.QHBoxLayout(self.widget3)
#         self.horizontalLayout_4.setContentsMargins(0, 0, 0, 0)
#         self.horizontalLayout_4.setObjectName("horizontalLayout_4")
#         self.label_7 = QtWidgets.QLabel(self.widget3)
#         self.label_7.setObjectName("label_7")
#         self.horizontalLayout_4.addWidget(self.label_7)
#         self.comboBox_2 = QtWidgets.QComboBox(self.widget3)
#         self.comboBox_2.setObjectName("comboBox_2")
#         self.comboBox_2.addItem("")
#         self.comboBox_2.setItemText(0, "")
#         self.comboBox_2.addItem("")
#         self.comboBox_2.addItem("")
#         self.horizontalLayout_4.addWidget(self.comboBox_2)
#         MainWindow.setCentralWidget(self.centralwidget)
#         self.menubar = QtWidgets.QMenuBar(MainWindow)
#         self.menubar.setGeometry(QtCore.QRect(0, 0, 800, 22))
#         self.menubar.setObjectName("menubar")
#         MainWindow.setMenuBar(self.menubar)
#         self.statusbar = QtWidgets.QStatusBar(MainWindow)
#         self.statusbar.setObjectName("statusbar")
#         MainWindow.setStatusBar(self.statusbar)
#
#         self.m = PlotCanvas(self, width=5, height=3)  # 实例化一个画布对象
#         self.m.move(300, 200)
#
#         self.comboBox.currentIndexChanged[str].connect(self.get_station_name)  # 条目发生改变，发射信号，传递条目内容
#         self.comboBox_2.currentIndexChanged[str].connect(self.get_data_name)  # 条目发生改变，发射信号，传递条目内容
#
#         self.pushButton.clicked.connect(self.print_)
#         self.pushButton.clicked.connect(self.load_data)
#         self.pushButton.clicked.connect(self.plot_)
#
#         self.retranslateUi(MainWindow)
#         QtCore.QMetaObject.connectSlotsByName(MainWindow)
#
#     def retranslateUi(self, MainWindow):
#         _translate = QtCore.QCoreApplication.translate
#         MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
#         self.label.setText(_translate("MainWindow", "<html><head/><body><p><span style=\" font-size:24pt;\">风电/光伏发电功率超短期预测模块</span></p><p><br/></p></body></html>"))
#         self.pushButton.setText(_translate("MainWindow", "开始导入"))
#         self.label_2.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">电站</span></p></body></html>"))
#         self.comboBox.setItemText(1, _translate("MainWindow", "风电"))
#         self.comboBox.setItemText(2, _translate("MainWindow", "光伏"))
#         self.label_5.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">起始时间：</span></p></body></html>"))
#         self.label_6.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">截止时间：</span></p></body></html>"))
#         self.label_7.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">导入数据类型：</span></p></body></html>"))
#         self.comboBox_2.setItemText(1, _translate("MainWindow", "功率"))
#         self.comboBox_2.setItemText(2, _translate("MainWindow", "数值天气预报"))
#
#     def get_data_name(self,i):
#         # 获取数据类型
#         global data_
#         data_ = i
#
#     def get_station_name(self,i):
#         # 获取电站类型
#         global station_
#         station_ = i
#
#     def print_(self):
#         print(data_, station_)
#         s = self.lineEdit.text()
#         print(s)
#
#     def load_data(self):
#         global input_data
#
#         if data_ == "功率":
#         # 导入光伏数据
#             if station_ == "光伏":
#                 # To Do
#                 input_data = pd.read_csv('/Users/mayuan/Downloads/projects/data_jilin/data/Power/'+self.lineEdit.text()+'.csv', index_col=0, parse_dates=True)
#                 print(input_data[:10])
#
#
#     def plot_(self):
#
#             self.m.update_figure(input_data)

import sys
from UI_show_plot import *
from PyQt5.QtWidgets import QApplication, QMainWindow

class MyWindow(QMainWindow, Ui_MainWindow):
    def __init__(self, parent=None):
        super(MyWindow, self).__init__(parent)
        self.setupUi(self)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    myWin = MyWindow()
    myWin.show()

    sys.exit(app.exec_())

