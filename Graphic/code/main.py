
from PyQt5 import QtCore, QtGui, QtWidgets
import static


class Ui_Interface(object):


    ### DECLARATION DES DIFFERENTS ELEMENTS DU SYSTEME ###
    def setupUi(self, Interface):
        Interface.setObjectName("Interface")
        Interface.resize(700, 350)
        Interface.setStyleSheet("background-color:#FFFFFF;")


    ## BANDE DE COULEUR POUR LES PAGES

        self.pageColor = QtWidgets.QLabel(Interface)
        self.pageColor.setGeometry(QtCore.QRect(0, 0, 700, 25))
        self.pageColor.setStyleSheet("background-color:rgb(255, 255, 255)")
        self.pageColor.setObjectName("pageColor")


    ## SYSTEME DE PAGE

        # Declaration du systeme de page
        self.tabWidget = QtWidgets.QTabWidget(Interface)
        self.tabWidget.setGeometry(QtCore.QRect(0, 0, 700, 350))
        self.tabWidget.setObjectName("tabWidget")

        # Changement de couleur en fonction de la page actuelle
        self.tabWidget.currentChanged.connect(self.pageChange)

    ## PAGE STATIC

        # Creation de la page pour le Static
        self.St_page = QtWidgets.QWidget()
        self.St_page.setObjectName("St_page")

        # Ligne de texte pour recevoir les donnees a envoyer
        self.St_dataLine = QtWidgets.QLineEdit(self.St_page)
        self.St_dataLine.setGeometry(QtCore.QRect(20, 30, 401, 31))
        self.St_dataLine.setObjectName("St_dataLine")

        # Bouton pour declancher l'envoie des donnees
        self.St_sendButton = QtWidgets.QPushButton(self.St_page)
        self.St_sendButton.setGeometry(QtCore.QRect(500, 80, 151, 41))
        font = QtGui.QFont()
        font.setPointSize(13)
        self.St_sendButton.setFont(font)
        self.St_sendButton.setObjectName("St_sendButton")

        # Selecteur du Port, pour savoir a quelle adresse envoyer les donnees
        self.St_portSelect = QtWidgets.QComboBox(self.St_page)
        self.St_portSelect.setGeometry(QtCore.QRect(450, 30, 211, 31))
        self.St_portSelect.setObjectName("St_portSelect")
        for i in range(6):
            self.St_portSelect.addItem("")
        self.tabWidget.addTab(self.St_page, "")

        # Reaction a l'appuye du bouton d'envoie
        self.St_sendButton.clicked.connect(self.static)


    ## PAGE ADDRESS DECODER

        self.AD_page = QtWidgets.QWidget()
        self.AD_page.setObjectName("AD_page")
        self.tabWidget.addTab(self.AD_page, "")


    ## PAGE SHIFT REGISTER

        self.RD_page = QtWidgets.QWidget()
        self.RD_page.setObjectName("RD_page")
        self.tabWidget.addTab(self.RD_page, "")


    ## DERNIER PARAMETRAGE

        self.pageColor.raise_()
        self.tabWidget.raise_()

        self.retranslateUi(Interface)
        self.tabWidget.setCurrentIndex(0)
        QtCore.QMetaObject.connectSlotsByName(Interface)



### PARAMETRAGE DES DIFFERENTS ELEMENTS DU SYSTEME ###
    def retranslateUi(self, Interface):

    ## PARAMETRAGE DE LA FENETRE
        _translate = QtCore.QCoreApplication.translate
        Interface.setWindowTitle(_translate("Interface", "Interface PC - Neuromorphic ship"))


    ## PARAMETRAGE DES ELEMENTS DU STATIC

        # Ecriture du texte du bouton d'envoie
        self.St_sendButton.setText(_translate("Interface", "Send"))

        # Nommage des differentes adresses d'envoie des donnees
        ports = ['A', 'B', 'C', 'D', 'E', 'F']
        for i, port in enumerate(ports):
            self.St_portSelect.setItemText(i, _translate('Interface', f'Port {port}'))


    ## PARAMETRAGE DU NOM DES DIFFERENTES PAGES

        self.tabWidget.setTabText(self.tabWidget.indexOf(self.St_page), _translate("Interface", "Static"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.AD_page), _translate("Interface", "Address decoder"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.RD_page), _translate("Interface", "Shift register"))



### GESTION DES COULEURS EN FONCTION DE LA PAGE AFFICHEE ###
    def pageChange(self):
        color = {
            0: 'background-color:rgb(50, 200, 50)',
            1: 'background-color:rgb(50, 50, 200)',
            2: 'background-color:rgb(200, 50, 50)'
        }
        self.pageColor.setStyleSheet(color[self.tabWidget.currentIndex()])



### ACTIONS EFFECTUEES POUR L'ENVOI DES DONNEES DU STATIC ###
    def static(self):
        
    ## Envoi des donnees
        static.sendData(self.St_dataLine.text(), self.St_portSelect.currentText())




if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    Interface = QtWidgets.QDialog()
    ui = Ui_Interface()
    ui.setupUi(Interface)
    Interface.show()
    sys.exit(app.exec_())




"""

Finir la page du static, avec des titres, des explications, des couleurs, des securites et verifications de data

regler probleme code com.py et l'incrementer dans static.py pour finir cette partie

"""
