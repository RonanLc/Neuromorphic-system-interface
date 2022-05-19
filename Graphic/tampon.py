# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'main.ui'
#
# Created by: PyQt5 UI code generator 5.15.4
#
# WARNING: Any manual changes made to this file will be lost when pyuic5 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_Interface(object):
    def setupUi(self, Interface):
        Interface.setObjectName("Interface")
        Interface.resize(392, 262)
        Interface.setStyleSheet("background-color: rgb(255, 255, 255);")
        self.SR_title = QtWidgets.QLabel(Interface)
        self.SR_title.setGeometry(QtCore.QRect(20, 10, 191, 51))
        font = QtGui.QFont()
        font.setFamily("Yu Gothic UI")
        font.setPointSize(20)
        font.setBold(False)
        font.setItalic(False)
        font.setWeight(50)
        font.setKerning(True)
        self.SR_title.setFont(font)
        self.SR_title.setObjectName("SR_title")
        self.AD_title = QtWidgets.QLabel(Interface)
        self.AD_title.setGeometry(QtCore.QRect(20, 130, 231, 41))
        font = QtGui.QFont()
        font.setFamily("Yu Gothic UI")
        font.setPointSize(20)
        font.setBold(False)
        font.setItalic(False)
        font.setWeight(50)
        font.setKerning(True)
        self.AD_title.setFont(font)
        self.AD_title.setObjectName("AD_title")
        self.SR_enterLine = QtWidgets.QLineEdit(Interface)
        self.SR_enterLine.setGeometry(QtCore.QRect(20, 70, 291, 20))
        self.SR_enterLine.setObjectName("SR_enterLine")
        self.SR_sendButton = QtWidgets.QPushButton(Interface)
        self.SR_sendButton.setGeometry(QtCore.QRect(320, 70, 51, 20))
        self.SR_sendButton.setObjectName("SR_sendButton")
        self.SR_errorData = QtWidgets.QLabel(Interface)
        self.SR_errorData.setGeometry(QtCore.QRect(20, 90, 121, 16))
        self.SR_errorData.setStyleSheet("color: rgb(255, 0, 0);")
        self.SR_errorData.setObjectName("SR_errorData")
        self.SR_correctData = QtWidgets.QLabel(Interface)
        self.SR_correctData.setGeometry(QtCore.QRect(20, 90, 121, 16))
        self.SR_correctData.setStyleSheet("color:rgb(0, 200, 0)")
        self.SR_correctData.setObjectName("SR_correctData")
        self.AD_enterFileLine = QtWidgets.QLineEdit(Interface)
        self.AD_enterFileLine.setGeometry(QtCore.QRect(50, 190, 321, 21))
        self.AD_enterFileLine.setObjectName("AD_enterFileLine")
        self.AD_enterTimeLine = QtWidgets.QLineEdit(Interface)
        self.AD_enterTimeLine.setGeometry(QtCore.QRect(20, 220, 113, 21))
        self.AD_enterTimeLine.setObjectName("AD_enterTimeLine")
        self.pushButton = QtWidgets.QPushButton(Interface)
        self.pushButton.setGeometry(QtCore.QRect(20, 190, 21, 21))
        self.pushButton.setObjectName("pushButton")

        self.retranslateUi(Interface)
        QtCore.QMetaObject.connectSlotsByName(Interface)

    def retranslateUi(self, Interface):
        _translate = QtCore.QCoreApplication.translate
        Interface.setWindowTitle(_translate("Interface", "Dialog"))
        self.SR_title.setText(_translate("Interface", "Shift register"))
        self.AD_title.setText(_translate("Interface", "Adress decoder"))
        self.SR_sendButton.setText(_translate("Interface", "Send"))
        self.SR_errorData.setText(_translate("Interface", "Please enter a valid data"))
        self.SR_correctData.setText(_translate("Interface", "Data sent successfull"))
        self.pushButton.setText(_translate("Interface", "..."))


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    Interface = QtWidgets.QDialog()
    ui = Ui_Interface()
    ui.setupUi(Interface)
    Interface.show()
    sys.exit(app.exec_())