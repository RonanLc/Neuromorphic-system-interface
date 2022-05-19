
from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import QFileDialog

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
        self.SR_labelData = QtWidgets.QLabel(Interface)
        self.SR_labelData.setGeometry(QtCore.QRect(20, 90, 161, 16))
        self.SR_labelData.setStyleSheet("color:rgb(0, 200, 0)")
        self.SR_labelData.setObjectName("SR_labelData")
        self.AD_enterFileLine = QtWidgets.QLineEdit(Interface)
        self.AD_enterFileLine.setGeometry(QtCore.QRect(50, 190, 321, 21))
        self.AD_enterFileLine.setObjectName("AD_enterFileLine")
        self.AD_enterTimeLine = QtWidgets.QLineEdit(Interface)
        self.AD_enterTimeLine.setGeometry(QtCore.QRect(20, 220, 113, 21))
        self.AD_enterTimeLine.setObjectName("AD_enterTimeLine")
        self.AD_fileButton = QtWidgets.QPushButton(Interface)
        self.AD_fileButton.setGeometry(QtCore.QRect(20, 190, 21, 21))
        self.AD_fileButton.setObjectName("pushButton")

        self.retranslateUi(Interface)
        QtCore.QMetaObject.connectSlotsByName(Interface)

        self.SR_sendButton.clicked.connect(self.SR_sendData)
        self.AD_fileButton.clicked.connect(self.AD_openFile)

    def retranslateUi(self, Interface):
        _translate = QtCore.QCoreApplication.translate
        Interface.setWindowTitle(_translate("Interface", "Dialog"))
        self.SR_title.setText(_translate("Interface", "Shift register"))
        self.AD_title.setText(_translate("Interface", "Adress decoder"))
        self.SR_sendButton.setText(_translate("Interface", "Send"))
        self.SR_labelData.setText(_translate("Interface", ""))
        self.AD_fileButton.setText(_translate("Interface", "..."))

    def SR_verifyData(self, data):
        print(len(data))
        if len(data) != 0:
            for i in range(len(data)):
                if data[i] != '0' and data[i] != '1':
                    return False
            return True
        return False

    def SR_sendData(self):
        self.SR_labelData.setText("")
        if self.SR_verifyData(self.SR_enterLine.text()) == True:
            SR_data = self.SR_enterLine.text()
            self.SR_labelData.setText("Data sent successfull")
            self.SR_labelData.setStyleSheet('color:rgb(0,200,0)')
            print("Data found", SR_data)
        else:
            self.SR_labelData.setText("Please enter a valid data")
            self.SR_labelData.setStyleSheet('color:rgb(255,0,0)')
            print("empty")

    def AD_openFile(self):
        fileLocation, _ = QFileDialog.getOpenFileName(None, 'Open File', 'D:\\etude\\Stage\\Work\\Neuromorphic-system-interface\\Data', 'CSV Files (*.csv);;All Files (*)')
        if fileLocation:
            self.AD_enterFileLine.clear()
            self.AD_enterFileLine.insert(fileLocation)

    def AD_sendData(self):
        self.SR_labelData.setText("")

if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    Interface = QtWidgets.QDialog()
    ui = Ui_Interface()
    ui.setupUi(Interface)
    Interface.show()
    sys.exit(app.exec_())
