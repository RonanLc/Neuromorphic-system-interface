
from PyQt5 import QtCore, QtGui, QtWidgets
import static


class Ui_Interface(object):


    ### DECLARATION DES DIFFERENTS ELEMENTS DU SYSTEME ###
    def setupUi(self, Interface):
        Interface.setObjectName("Interface")
        Interface.setFixedSize(700, 350)
        font = QtGui.QFont()

    ## BANDE DE COULEUR POUR LES PAGES

        self.pageColor = QtWidgets.QLabel(Interface)
        self.pageColor.setGeometry(QtCore.QRect(0, 0, 700, 20))
        self.pageColor.setStyleSheet('color:rgb(255, 255, 255)')
        self.pageColor.setAlignment(QtCore.Qt.AlignRight | QtCore.Qt.AlignTrailing | QtCore.Qt.AlignVCenter)
        self.pageColor.setObjectName("pageColor")


    ## SYSTEME DE PAGE

        # Declaration du systeme de page
        self.tabWidget = QtWidgets.QTabWidget(Interface)
        self.tabWidget.setGeometry(QtCore.QRect(0, 0, 700, 350))
        self.tabWidget.setObjectName("tabWidget")

        # Changement de couleur en fonction de la page actuelle
        self.tabWidget.currentChanged.connect(self.pageChange)


    ## PAGE HOME

        # Creation de la page pour le Home
        self.Home_page = QtWidgets.QWidget()
        self.Home_page.setObjectName("Home_page")

        # Titre du projet
        self.Home_title = QtWidgets.QLabel(self.Home_page)
        self.Home_title.setGeometry(QtCore.QRect(110, 30, 470, 41))
        font.setPointSize(20)
        self.Home_title.setFont(font)
        self.Home_title.setObjectName("Home_title")

        # Sous titre "Realise par"
        self.Home_subtitle1 = QtWidgets.QLabel(self.Home_page)
        self.Home_subtitle1.setGeometry(QtCore.QRect(180, 80, 331, 20))
        font.setPointSize(11)
        self.Home_subtitle1.setFont(font)
        self.Home_subtitle1.setObjectName("Home_subtitle1")

        # Sous titre "Cooperation"
        self.Home_subtitle2 = QtWidgets.QLabel(self.Home_page)
        self.Home_subtitle2.setGeometry(QtCore.QRect(190, 100, 301, 20))
        font.setPointSize(12)
        self.Home_subtitle2.setFont(font)
        self.Home_subtitle2.setObjectName("Home_subtitle2")

        # Sous titre "supervise par"
        self.Home_subtitle3 = QtWidgets.QLabel(self.Home_page)
        self.Home_subtitle3.setGeometry(QtCore.QRect(140, 160, 411, 20))
        font.setPointSize(12)
        self.Home_subtitle3.setFont(font)
        self.Home_subtitle3.setObjectName("Home_subtitle3")

        # Photo 1
        self.Home_photo1 = QtWidgets.QLabel(self.Home_page)
        self.Home_photo1.setGeometry(QtCore.QRect(60, 210, 221, 101))
        self.Home_photo1.setPixmap(QtGui.QPixmap("../data/iisUTokyo.png"))
        self.Home_photo1.setScaledContents(True)
        self.Home_photo1.setObjectName("Home_photo1")

        # Photo 2
        self.Home_photo2 = QtWidgets.QLabel(self.Home_page)
        self.Home_photo2.setGeometry(QtCore.QRect(410, 215, 221, 81))
        self.Home_photo2.setPixmap(QtGui.QPixmap("../data/UBordeaux.png"))
        self.Home_photo2.setScaledContents(True)
        self.Home_photo2.setObjectName("Home_photo2")

        # Valider la page
        self.tabWidget.addTab(self.Home_page, "")


    ## PAGE STATIC

        # Creation de la page pour le Static
        self.St_page = QtWidgets.QWidget()
        self.St_page.setObjectName("St_page")

        # Label pour recevoir les donnees a envoyer
        self.St_dataLine = QtWidgets.QLineEdit(self.St_page)
        self.St_dataLine.setGeometry(QtCore.QRect(350, 30, 60, 31))
        self.St_dataLine.setStyleSheet('background-color:rgb(255, 255, 255)')
        font.setPointSize(15)
        self.St_dataLine.setFont(font)
        self.St_dataLine.setObjectName("St_dataLine")
        self.St_dataLine.setMaxLength(2)
        self.St_dataLine.setValidator(QtGui.QRegExpValidator(QtCore.QRegExp('[A-Fa-f0-9]*')))

        # Bouton pour declancher l'envoie des donnees
        self.St_sendButton = QtWidgets.QPushButton(self.St_page)
        self.St_sendButton.setGeometry(QtCore.QRect(200, 240, 110, 31))
        self.St_sendButton.setStyleSheet('background-color:rgb(255, 255, 255)')
        font.setPointSize(13)
        self.St_sendButton.setFont(font)
        self.St_sendButton.setObjectName("St_sendButton")

        # Selecteur du Port, pour savoir a quelle adresse envoyer les donnees
        self.St_portSelect = QtWidgets.QComboBox(self.St_page)
        self.St_portSelect.setGeometry(QtCore.QRect(330, 140, 140, 31))
        self.St_portSelect.setStyleSheet('background-color:rgb(255, 255, 255)')
        font.setPointSize(13)
        self.St_portSelect.setFont(font)
        self.St_portSelect.setObjectName("St_portSelect")
        for i in range(6):
            self.St_portSelect.addItem("")

        # Label Titre 1
        self.St_titleLabel1 = QtWidgets.QLabel(self.St_page)
        self.St_titleLabel1.setGeometry(QtCore.QRect(30, 30, 310, 31))
        font.setPointSize(15)
        self.St_titleLabel1.setFont(font)
        self.St_titleLabel1.setObjectName("St_titleLabel1")

        # Label Titre 2
        self.St_titleLabel2 = QtWidgets.QLabel(self.St_page)
        self.St_titleLabel2.setGeometry(QtCore.QRect(30, 130, 280, 31))
        font.setPointSize(15)
        self.St_titleLabel2.setFont(font)
        self.St_titleLabel2.setObjectName("St_titleLabel2")

        # Label Titre 3
        self.St_titleLabel3 = QtWidgets.QLabel(self.St_page)
        self.St_titleLabel3.setGeometry(QtCore.QRect(30, 240, 160, 31))
        font.setPointSize(15)
        self.St_titleLabel3.setFont(font)
        self.St_titleLabel3.setObjectName("St_titleLabel3")

        # Label de description 1
        self.St_descriptionLabel1 = QtWidgets.QLabel(self.St_page)
        self.St_descriptionLabel1.setGeometry(QtCore.QRect(30, 60, 310, 16))
        self.St_descriptionLabel1.setObjectName("St_descriptionLabel1")

        # Label de description 2
        self.St_descriptionLabel2 = QtWidgets.QLabel(self.St_page)
        self.St_descriptionLabel2.setGeometry(QtCore.QRect(30, 160, 250, 16))
        self.St_descriptionLabel2.setObjectName("St_descriptionLabel2")

        # Label d'information
        self.St_informationLabel = QtWidgets.QLabel(self.St_page)
        self.St_informationLabel.setGeometry(QtCore.QRect(220, 290, 460, 16))
        self.St_informationLabel.setAlignment(QtCore.Qt.AlignRight|QtCore.Qt.AlignTrailing|QtCore.Qt.AlignVCenter)
        self.St_informationLabel.setObjectName("St_informationLabel")

        # Valider la page
        self.tabWidget.addTab(self.St_page, "")

        # Reaction a l'appuye du bouton d'envoi
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
        self.pageChange()
        QtCore.QMetaObject.connectSlotsByName(Interface)



### PARAMETRAGE DES DIFFERENTS ELEMENTS DU SYSTEME ###
    def retranslateUi(self, Interface):

    ## PARAMETRAGE DE LA FENETRE
        _translate = QtCore.QCoreApplication.translate
        Interface.setWindowTitle(_translate("Interface", "PC - Neuromorphic ship Interface"))
        self.pageColor.setText(_translate("Interface", "Developed by Ronan Le Corronc  "))

    ## PARAMETRAGE DES ELEMENTS DU STATIC

        self.Home_title.setText(_translate("Interface", "Pc - Neuromorphic ship Interface"))
        self.Home_subtitle1.setText(_translate("Interface", "Ronan Le Corronc\'s 2022 internship project"))
        self.Home_subtitle3.setText(_translate("Interface", "Supervised by Timothée Levi and Takashi Kohno"))
        self.Home_subtitle2.setText(_translate("Interface", "In cooperation with Ashish Gautam"))

    ## PARAMETRAGE DES ELEMENTS DU STATIC

        # Ecriture du texte du bouton d'envoie
        self.St_sendButton.setText(_translate("Interface", "Send"))

        # Nommage des differentes adresses d'envoie des donnees
        ports = ['A', 'B', 'C', 'D', 'E', 'F']
        for i, port in enumerate(ports):
            self.St_portSelect.setItemText(i, _translate('Interface', f'Port {port}'))

        # Ecriture des St titres
        self.St_titleLabel1.setText(_translate("Interface", "Static data to be submitted :"))
        self.St_titleLabel2.setText(_translate("Interface", "Location of data sending :"))
        self.St_titleLabel3.setText(_translate("Interface", "Sending data :"))

        # Ecriture des St description

        self.St_descriptionLabel1.setText(_translate("Interface", "Please select a 2-character hexadecimal value"))
        self.St_descriptionLabel2.setText(_translate("Interface", "Please select the data destination port"))
        self.St_informationLabel.setText(_translate("Interface", "Waiting for data sending..."))

    ## PARAMETRAGE DES DIFFERENTES PAGES

        self.tabWidget.setTabText(self.tabWidget.indexOf(self.Home_page), _translate("Interface", "Home"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.St_page), _translate("Interface", "Static"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.AD_page), _translate("Interface", "Address decoder"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.RD_page), _translate("Interface", "Shift register"))


### GESTION DES COULEURS EN FONCTION DE LA PAGE AFFICHEE ###
    def pageChange(self):
        color = {
            0: 'background-color:rgb(255, 255, 255)',
            1: 'background-color:rgb(100, 200, 100)',
            2: 'background-color:rgb(100, 100, 200)',
            3: 'background-color:rgb(200, 100, 100)',
            4: 'background-color:rgb(255, 255, 255)',
            5: 'background-color:rgb(245, 255, 245)',
            6: 'background-color:rgb(245, 245, 255)',
            7: 'background-color:rgb(255, 245, 245)'
        }
        Interface.setStyleSheet(color[self.tabWidget.currentIndex()])
        self.tabWidget.setStyleSheet(color[self.tabWidget.currentIndex()+4])



### ACTIONS EFFECTUEES POUR L'ENVOI DES DONNEES DU STATIC ###
    def static(self):

    ## Envoi des donnees
        if len(self.St_dataLine.text()) == 2:
            static.sendData(self.St_dataLine.text(), self.St_portSelect.currentText())
            self.St_informationLabel.setText("The data 0x"+self.St_dataLine.text()+" has been written correctly on the "+self.St_portSelect.currentText()+" !")
            self.St_informationLabel.setStyleSheet('color:rgb(0, 200, 0)')
        else:
            self.St_informationLabel.setText("Error : Only "+str(len(self.St_dataLine.text()))+" character has been typed as data to send, please type 2.")
            self.St_informationLabel.setStyleSheet('color:rgb(230, 0, 0)')



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
