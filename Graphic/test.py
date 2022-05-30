# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'test.ui'
#
# Created by: PyQt5 UI code generator 5.15.4
#
# WARNING: Any manual changes made to this file will be lost when pyuic5 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt5 import QtCore, QtGui, QtWidgets

class Ui_Interface(object):
    def setupUi(self, Interface):
        Interface.setObjectName("Interface")
        Interface.resize(700, 350)
        Interface.setStyleSheet("background-color:#FFFFFF;")
        self.tabWidget = QtWidgets.QTabWidget(Interface)
        self.tabWidget.setGeometry(QtCore.QRect(0, 0, 700, 350))
        self.tabWidget.setObjectName("tabWidget")
        self.St_page = QtWidgets.QWidget()
        self.St_page.setObjectName("St_page")
        self.St_dataLine = QtWidgets.QLineEdit(self.St_page)
        self.St_dataLine.setGeometry(QtCore.QRect(30, 30, 401, 31))
        self.St_dataLine.setObjectName("St_dataLine")
        self.St_sendButton = QtWidgets.QPushButton(self.St_page)
        self.St_sendButton.setGeometry(QtCore.QRect(500, 80, 151, 41))
        font = QtGui.QFont()
        font.setPointSize(13)
        self.St_sendButton.setFont(font)
        self.St_sendButton.setObjectName("St_sendButton")
        self.St_portSelect = QtWidgets.QComboBox(self.St_page)
        self.St_portSelect.setGeometry(QtCore.QRect(450, 30, 211, 31))
        self.St_portSelect.setObjectName("St_portSelect")
        self.St_portSelect.addItem("")
        self.St_portSelect.addItem("")
        self.St_portSelect.addItem("")
        self.St_portSelect.addItem("")
        self.tabWidget.addTab(self.St_page, "")
        self.AD_page = QtWidgets.QWidget()
        self.AD_page.setObjectName("AD_page")
        self.tabWidget.addTab(self.AD_page, "")
        self.RD_page = QtWidgets.QWidget()
        self.RD_page.setObjectName("RD_page")
        self.tabWidget.addTab(self.RD_page, "")
        self.label = QtWidgets.QLabel(Interface)
        self.label.setGeometry(QtCore.QRect(0, 0, 701, 21))
        self.label.setText("")
        self.label.setObjectName("label")
        self.label.raise_()
        self.tabWidget.raise_()

        self.retranslateUi(Interface)
        self.tabWidget.setCurrentIndex(0)
        QtCore.QMetaObject.connectSlotsByName(Interface)

    def retranslateUi(self, Interface):
        _translate = QtCore.QCoreApplication.translate
        Interface.setWindowTitle(_translate("Interface", "Dialog"))
        self.St_dataLine.setText(_translate("Interface", "Set the data..."))
        self.St_sendButton.setText(_translate("Interface", "Send"))
        self.St_portSelect.setItemText(0, _translate("Interface", "Port A"))
        self.St_portSelect.setItemText(1, _translate("Interface", "Port B"))
        self.St_portSelect.setItemText(2, _translate("Interface", "Port C"))
        self.St_portSelect.setItemText(3, _translate("Interface", "Port D"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.St_page), _translate("Interface", "Static"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.AD_page), _translate("Interface", "Address decoder"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.RD_page), _translate("Interface", "Shift register"))
