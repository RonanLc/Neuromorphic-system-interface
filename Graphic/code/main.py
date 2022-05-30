from PyQt5 import QtCore, QtGui, QtWidgets
import init, static

def loop():
    #Graphic.code.init.init.St_sendButton.clicked.connect(static.sendData())

if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    Interface = QtWidgets.QDialog()
    init.init.setupUi(init.init(),Interface)
    Interface.show()
    loop()
    sys.exit(app.exec_())



"""

Trouver une solution pour cliquer sur le bouton ligne 5

Apprendre a utiliser les differentes pages (tabWidget)
Faire en sorte de pouvoir changer la bande de couleur grace aux differentes pages

Apprendre a utiliser le QComboBox

programmer un code fonctionnel pour le static puis le placer dans le code static.py

"""
