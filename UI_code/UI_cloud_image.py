# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'UI_cloud_image.ui'
#
# Created by: PyQt5 UI code generator 5.9.2
#
# WARNING! All changes made in this file will be lost!

import sys
import base64
from images.cloud_image_jpg import img as cloud_image
from PyQt5.QtWidgets import QApplication, QMainWindow
from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *

tmp = open('cloud_image.jpg', 'wb')        #创建临时的文件
tmp.write(base64.b64decode(cloud_image))    ##把这个one图片解码出来，写入文件中去。
tmp.close()

class Ui_MainWindow_cloud_image(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(800, 600)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.pushButton = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton.setGeometry(QtCore.QRect(90, 460, 113, 32))
        self.pushButton.setObjectName("pushButton")
        self.line = QtWidgets.QFrame(self.centralwidget)
        self.line.setGeometry(QtCore.QRect(0, 50, 879, 3))
        self.line.setFrameShadow(QtWidgets.QFrame.Plain)
        self.line.setLineWidth(5)
        self.line.setFrameShape(QtWidgets.QFrame.HLine)
        self.line.setObjectName("line")
        self.layoutWidget = QtWidgets.QWidget(self.centralwidget)
        self.layoutWidget.setGeometry(QtCore.QRect(20, 330, 263, 66))
        self.layoutWidget.setObjectName("layoutWidget")
        self.verticalLayout_3 = QtWidgets.QVBoxLayout(self.layoutWidget)
        self.verticalLayout_3.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.horizontalLayout_11 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_11.setObjectName("horizontalLayout_11")
        self.label_15 = QtWidgets.QLabel(self.layoutWidget)
        self.label_15.setObjectName("label_15")
        self.horizontalLayout_11.addWidget(self.label_15)
        self.dateTimeEdit_5 = QtWidgets.QDateTimeEdit(QtCore.QDateTime(QtCore.QDate(2017, 1, 1), QtCore.QTime(0, 0, 0)))
        self.dateTimeEdit_5.setObjectName("dateTimeEdit_5")
        self.dateTimeEdit_5.setDisplayFormat("yyyy/MM/dd HH-mm-ss")
        self.horizontalLayout_11.addWidget(self.dateTimeEdit_5)
        self.verticalLayout_3.addLayout(self.horizontalLayout_11)
        self.horizontalLayout_12 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_12.setObjectName("horizontalLayout_12")
        self.label_16 = QtWidgets.QLabel(self.layoutWidget)
        self.label_16.setObjectName("label_16")
        self.horizontalLayout_12.addWidget(self.label_16)
        self.dateTimeEdit_6 = QtWidgets.QDateTimeEdit(QtCore.QDateTime(QtCore.QDate(2017, 1, 1), QtCore.QTime(0, 0, 0)))
        self.dateTimeEdit_6.setObjectName("dateTimeEdit_6")
        self.dateTimeEdit_6.setDisplayFormat("yyyy/MM/dd HH-mm-ss")
        self.horizontalLayout_12.addWidget(self.dateTimeEdit_6)
        self.verticalLayout_3.addLayout(self.horizontalLayout_12)
        self.layoutWidget_2 = QtWidgets.QWidget(self.centralwidget)
        self.layoutWidget_2.setGeometry(QtCore.QRect(20, 70, 300, 37))
        self.layoutWidget_2.setObjectName("layoutWidget_2")
        self.horizontalLayout_13 = QtWidgets.QHBoxLayout(self.layoutWidget_2)
        self.horizontalLayout_13.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout_13.setObjectName("horizontalLayout_13")
        self.label_17 = QtWidgets.QLabel(self.layoutWidget_2)
        self.label_17.setObjectName("label_17")
        self.horizontalLayout_13.addWidget(self.label_17)
        self.pushButton_4 = QtWidgets.QPushButton(self.layoutWidget_2)
        self.pushButton_4.setObjectName("pushButton_4")
        self.horizontalLayout_13.addWidget(self.pushButton_4)
        self.layoutWidget_3 = QtWidgets.QWidget(self.centralwidget)
        self.layoutWidget_3.setGeometry(QtCore.QRect(20, 230, 264, 31))
        self.layoutWidget_3.setObjectName("layoutWidget_3")
        self.horizontalLayout_14 = QtWidgets.QHBoxLayout(self.layoutWidget_3)
        self.horizontalLayout_14.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout_14.setObjectName("horizontalLayout_14")
        self.label_18 = QtWidgets.QLabel(self.layoutWidget_3)
        self.label_18.setObjectName("label_18")
        self.horizontalLayout_14.addWidget(self.label_18)
        self.comboBox_4 = QtWidgets.QComboBox(self.layoutWidget_3)
        self.comboBox_4.setObjectName("comboBox_4")
        self.comboBox_4.addItem("")
        self.comboBox_4.setItemText(0, "")
        self.comboBox_4.addItem("")
        self.comboBox_4.addItem("")
        self.comboBox_4.addItem("")
        self.horizontalLayout_14.addWidget(self.comboBox_4)
        self.label = QtWidgets.QLabel(self.centralwidget)
        self.label.setGeometry(QtCore.QRect(20, 10, 371, 31))
        self.label.setObjectName("label")
        self.layoutWidget_4 = QtWidgets.QWidget(self.centralwidget)
        self.layoutWidget_4.setGeometry(QtCore.QRect(20, 150, 255, 31))
        self.layoutWidget_4.setObjectName("layoutWidget_4")
        self.horizontalLayout_15 = QtWidgets.QHBoxLayout(self.layoutWidget_4)
        self.horizontalLayout_15.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout_15.setObjectName("horizontalLayout_15")
        self.label_4 = QtWidgets.QLabel(self.layoutWidget_4)
        self.label_4.setObjectName("label_4")
        self.horizontalLayout_15.addWidget(self.label_4)
        self.comboBox_7 = QtWidgets.QComboBox(self.layoutWidget_4)
        self.comboBox_7.setObjectName("comboBox_7")
        self.comboBox_7.addItem("")
        self.comboBox_7.setItemText(0, "")
        self.comboBox_7.addItem("")
        self.comboBox_7.addItem("")
        self.horizontalLayout_15.addWidget(self.comboBox_7)
        self.lineEdit_3 = QtWidgets.QLineEdit(self.layoutWidget_4)
        self.lineEdit_3.setObjectName("lineEdit_3")
        self.horizontalLayout_15.addWidget(self.lineEdit_3)
        self.graphicsView = QtWidgets.QGraphicsView(self.centralwidget)
        self.graphicsView.setGeometry(QtCore.QRect(340, 150, 401, 331))
        self.graphicsView.setMinimumSize(QtCore.QSize(401, 331))
        self.graphicsView.setMaximumSize(QtCore.QSize(401, 331))
        self.graphicsView.setObjectName("graphicsView")
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 800, 22))
        self.menubar.setObjectName("menubar")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.pushButton.clicked.connect(self.slot)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
        self.pushButton.setText(_translate("MainWindow", "开始导入"))
        self.label_15.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">开始时间：</span></p></body></html>"))
        self.label_16.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">截止时间：</span></p></body></html>"))
        self.label_17.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">动态数据导入地址：</span></p></body></html>"))
        self.pushButton_4.setText(_translate("MainWindow", "打开文件夹"))
        self.label_18.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">导入数据类型：</span></p></body></html>"))
        self.comboBox_4.setItemText(1, _translate("MainWindow", "云图"))
        self.comboBox_4.setItemText(2, _translate("MainWindow", "功率"))
        self.comboBox_4.setItemText(3, _translate("MainWindow", "数值天气预报"))
        self.label.setText(_translate("MainWindow", "<html><head/><body><p><span style=\" font-size:24pt;\">风电/光伏发电功率超短期预测模块</span></p><p><br/></p></body></html>"))
        self.label_4.setText(_translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:18pt;\">电站</span></p></body></html>"))
        self.comboBox_7.setItemText(1, _translate("MainWindow", "风电"))
        self.comboBox_7.setItemText(2, _translate("MainWindow", "光伏"))

    def slot(self):
        self.graphicsView.setStyleSheet(
            "image: url(cloud_image.jpg);\n"
            "border-image: url(cloud_image.jpg);")

