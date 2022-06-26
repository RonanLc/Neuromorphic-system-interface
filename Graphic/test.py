
from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_Interface(object):
    def setupUi(self, Interface):
        Interface.setObjectName("Interface")
        Interface.resize(408, 520)
        Interface.setStyleSheet("background-color: rgb(255, 255, 255);")
        self.pushButton = QtWidgets.QPushButton(Interface)
        self.pushButton.setGeometry(QtCore.QRect(70, 190, 271, 111))
        self.pushButton.setObjectName("pushButton")

        self.retranslateUi(Interface)
        QtCore.QMetaObject.connectSlotsByName(Interface)

    def retranslateUi(self, Interface):
        _translate = QtCore.QCoreApplication.translate
        Interface.setWindowTitle(_translate("Interface", "Dialog"))
        self.pushButton.setText(_translate("Interface", "Press"))


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    Interface = QtWidgets.QDialog()
    ui = Ui_Interface()
    ui.setupUi(Interface)
    Interface.show()
    sys.exit(app.exec_())




