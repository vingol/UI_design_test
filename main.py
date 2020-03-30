#!/usr/bin/python
# -*- coding:utf-8 -*-

import os
import sys
from UI_code.UI_main_win import *
from UI_code.UI_show_plot import *
from UI_code.UI_cloud_image import *
from UI_code.UI_pattern_true import *
from UI_code.UI_forecast import *
from PyQt5.QtWidgets import QApplication, QMainWindow
from PyQt5.QtGui import QFont

os.environ["CUDA_VISIBLE_DEVICES"] = "-1"
os.environ["DEBUSSY"] = "1"

class MyWindow(QMainWindow, Ui_MainWindow):
    def __init__(self, parent=None):
        super(MyWindow, self).__init__(parent)
        self.setupUi(self)

class MyWindow_show_plot(QMainWindow, Ui_MainWindow_show_plot):
    def __init__(self, parent=None):
        super(MyWindow_show_plot, self).__init__(parent)
        self.setupUi(self)

class MyWindow_cloud_image(QMainWindow, Ui_MainWindow_cloud_image):
    def __init__(self, parent=None):
        super(MyWindow_cloud_image, self).__init__(parent)
        self.setupUi(self)

class MyWindow_pattern_true(QMainWindow, Ui_MainWindow_pattern_true):
    def __init__(self, parent=None):
        super(MyWindow_pattern_true, self).__init__(parent)
        self.setupUi(self)

class MyWindow_forecast(QMainWindow, Ui_MainWindow_forecast):
    def __init__(self, parent=None):
        super(MyWindow_forecast, self).__init__(parent)
        self.setupUi(self)


if __name__ == '__main__':
    # 字体随分辨率自适应
    QtCore.QCoreApplication.setAttribute(QtCore.Qt.AA_EnableHighDpiScaling)

    app = QApplication(sys.argv)
    myWin = MyWindow()
    myWin.show()

    # 跳转页面2
    Window_show_plot = MyWindow_show_plot()

    btn_show_plot = myWin.pushButton_3
    btn_show_plot.clicked.connect(Window_show_plot.show)

    # 合并跳转云图，出来两个页面
    Window_cloud_image = MyWindow_cloud_image()

    btn_cloud_image = myWin.pushButton_3
    btn_cloud_image.clicked.connect(Window_cloud_image.show)

    # 跳转页面3
    Window_pattern_true = MyWindow_pattern_true()

    btn_pattern_true = myWin.pushButton_4
    btn_pattern_true.clicked.connect(Window_pattern_true.show)

    # 跳转页面4
    Window_forecast = MyWindow_forecast()

    btn_forecast = myWin.pushButton_5
    btn_forecast.clicked.connect(Window_forecast.show)

    # window_cloud_image = MyWindow_cloud_image()
    # btn = myWin.pushButton_3
    # btn.clicked.connect(MyWindow_cloud_image.show)

    # window_pattern_true = MyWindow_pattern_true()
    # btn_pattern_true = myWin.pushButton_4
    # btn_pattern_true.clicked.connect(MyWindow_pattern_true.show)

    sys.exit(app.exec_())