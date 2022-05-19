# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'test.ui'
#
# Created by: PyQt5 UI code generator 5.15.4
#
# WARNING: Any manual changes made to this file will be lost when pyuic5 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt5 import QtCore, QtGui, QtWidgets
import time


class Ui_Interface(object):
    def setupUi(self, Interface):
        Interface.setObjectName("Interface")
        Interface.resize(529, 329)
        Interface.setStyleSheet("background-color: rgb(255, 255, 255);")
        self.SR_title = QtWidgets.QLabel(Interface)
        self.SR_title.setGeometry(QtCore.QRect(20, 20, 151, 41))
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
        self.AD_title.setGeometry(QtCore.QRect(20, 150, 191, 41))
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

        self.retranslateUi(Interface)
        QtCore.QMetaObject.connectSlotsByName(Interface)

        self.reset()

        self.SR_sendButton.clicked.connect(self.SR_sendData)

    def retranslateUi(self, Interface):
        _translate = QtCore.QCoreApplication.translate
        Interface.setWindowTitle(_translate("Interface", "Dialog"))
        self.SR_title.setText(_translate("Interface", "Shift register"))
        self.AD_title.setText(_translate("Interface", "Adress decoder"))
        self.SR_sendButton.setText(_translate("Interface", "Send"))
        self.SR_errorData.setText(_translate("Interface", "Please enter a valid data"))
        self.SR_correctData.setText(_translate("Interface", "Data sent successfull"))

    def reset(self):
        self.SR_errorData.move(0, -100)
        self.SR_correctData.move(0, -100)

    def verify(self, data):
        print(len(data))
        if len(data) != 0:
            for i in range(len(data)):
                if data[i] != '0' and data[i] != '1':
                    return False
            return True
        return False

    def SR_sendData(self):
        self.reset()
        if self.verify(self.SR_enterLine.text()) == True:
            SR_data = self.SR_enterLine.text()
            self.SR_correctData.move(20, 90)
            print("Data found", SR_data)
        else:
            self.SR_errorData.move(20, 90)
            print("empty")


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    Interface = QtWidgets.QDialog()
    ui = Ui_Interface()
    ui.setupUi(Interface)
    Interface.show()
    sys.exit(app.exec_())
