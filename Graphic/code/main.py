
from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import QFileDialog
from static import sendData
from addressDecoder import AD


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
        self.Home_photo1.setPixmap(QtGui.QPixmap("../../Data/iisUTokyo.png"))
        self.Home_photo1.setScaledContents(True)
        self.Home_photo1.setObjectName("Home_photo1")

        # Photo 2
        self.Home_photo2 = QtWidgets.QLabel(self.Home_page)
        self.Home_photo2.setGeometry(QtCore.QRect(410, 215, 221, 81))
        self.Home_photo2.setPixmap(QtGui.QPixmap("../../Data/UBordeaux.png"))
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

        self.AD_titleLabel1 = QtWidgets.QLabel(self.AD_page)
        self.AD_titleLabel1.setGeometry(QtCore.QRect(20, 13, 201, 31))
        font.setPointSize(15)
        self.AD_titleLabel1.setFont(font)
        self.AD_titleLabel1.setObjectName("AD_titleLabel1")

        self.AD_titleLabel2 = QtWidgets.QLabel(self.AD_page)
        self.AD_titleLabel2.setGeometry(QtCore.QRect(20, 80, 241, 31))
        font.setPointSize(15)
        self.AD_titleLabel2.setFont(font)
        self.AD_titleLabel2.setObjectName("AD_titleLabel2")

        self.AD_titleLabel3 = QtWidgets.QLabel(self.AD_page)
        self.AD_titleLabel3.setGeometry(QtCore.QRect(380, 80, 191, 31))
        font.setPointSize(15)
        self.AD_titleLabel3.setFont(font)
        self.AD_titleLabel3.setObjectName("AD_titleLabel3")

        self.AD_titleLabel4 = QtWidgets.QLabel(self.AD_page)
        self.AD_titleLabel4.setGeometry(QtCore.QRect(20, 163, 211, 31))
        font.setPointSize(15)
        self.AD_titleLabel4.setFont(font)
        self.AD_titleLabel4.setObjectName("AD_titleLabel4")

        self.AD_titleLabel5 = QtWidgets.QLabel(self.AD_page)
        self.AD_titleLabel5.setGeometry(QtCore.QRect(380, 163, 281, 31))
        font.setPointSize(15)
        self.AD_titleLabel5.setFont(font)
        self.AD_titleLabel5.setObjectName("AD_titleLabel5")

        self.AD_descriptionLabel1 = QtWidgets.QLabel(self.AD_page)
        self.AD_descriptionLabel1.setGeometry(QtCore.QRect(20, 43, 611, 16))
        self.AD_descriptionLabel1.setObjectName("AD_descriptionLabel1")

        self.AD_descriptionLabel2 = QtWidgets.QLabel(self.AD_page)
        self.AD_descriptionLabel2.setGeometry(QtCore.QRect(20, 107, 321, 16))
        self.AD_descriptionLabel2.setObjectName("AD_descriptionLabel2")

        self.AD_descriptionLabel3 = QtWidgets.QLabel(self.AD_page)
        self.AD_descriptionLabel3.setGeometry(QtCore.QRect(20, 200, 16, 31))
        self.AD_descriptionLabel3.setObjectName("AD_descriptionLabel3")

        self.AD_descriptionLabel4 = QtWidgets.QLabel(self.AD_page)
        self.AD_descriptionLabel4.setGeometry(QtCore.QRect(20, 230, 16, 31))
        self.AD_descriptionLabel4.setObjectName("AD_descriptionLabel4")

        self.AD_descriptionLabel5 = QtWidgets.QLabel(self.AD_page)
        self.AD_descriptionLabel5.setGeometry(QtCore.QRect(20, 260, 16, 31))
        self.AD_descriptionLabel5.setObjectName("AD_descriptionLabel5")

        self.AD_descriptionLabel6 = QtWidgets.QLabel(self.AD_page)
        self.AD_descriptionLabel6.setGeometry(QtCore.QRect(20, 290, 241, 16))
        self.AD_descriptionLabel6.setObjectName("AD_descriptionLabel6")

        self.AD_descriptionLabel7 = QtWidgets.QLabel(self.AD_page)
        self.AD_descriptionLabel7.setGeometry(QtCore.QRect(535, 200, 111, 41))
        self.AD_descriptionLabel7.setAlignment(QtCore.Qt.AlignCenter)
        self.AD_descriptionLabel7.setWordWrap(True)
        self.AD_descriptionLabel7.setObjectName("AD_descriptionLabel7")

        self.AD_informationLabel1 = QtWidgets.QLabel(self.AD_page)
        self.AD_informationLabel1.setGeometry(QtCore.QRect(220, 130, 461, 16))
        self.AD_informationLabel1.setAlignment(QtCore.Qt.AlignRight | QtCore.Qt.AlignTrailing | QtCore.Qt.AlignVCenter)
        self.AD_informationLabel1.setObjectName("AD_informationLabel1")

        self.AD_informationLabel2 = QtWidgets.QLabel(self.AD_page)
        self.AD_informationLabel2.setGeometry(QtCore.QRect(260, 300, 421, 16))
        self.AD_informationLabel2.setAlignment(QtCore.Qt.AlignRight | QtCore.Qt.AlignTrailing | QtCore.Qt.AlignVCenter)
        self.AD_informationLabel2.setObjectName("AD_informationLabel2")

        self.AD_blackLine1 = QtWidgets.QFrame(self.AD_page)
        self.AD_blackLine1.setGeometry(QtCore.QRect(20, 155, 650, 2))
        self.AD_blackLine1.setFrameShape(QtWidgets.QFrame.HLine)
        self.AD_blackLine1.setFrameShadow(QtWidgets.QFrame.Sunken)
        self.AD_blackLine1.setObjectName("AD_blackLine1")

        self.AD_blackLine2 = QtWidgets.QFrame(self.AD_page)
        self.AD_blackLine2.setGeometry(QtCore.QRect(350, 200, 20, 91))
        self.AD_blackLine2.setFrameShape(QtWidgets.QFrame.VLine)
        self.AD_blackLine2.setFrameShadow(QtWidgets.QFrame.Sunken)
        self.AD_blackLine2.setObjectName("AD_blackLine2")

        self.AD_enterFileLine = QtWidgets.QLineEdit(self.AD_page)
        self.AD_enterFileLine.setGeometry(QtCore.QRect(230, 15, 400, 25))
        self.AD_enterFileLine.setObjectName("AD_enterFileLine")

        self.AD_stimTimeLine = QtWidgets.QLineEdit(self.AD_page)
        self.AD_stimTimeLine.setGeometry(QtCore.QRect(270, 82, 80, 25))
        self.AD_stimTimeLine.setValidator(QtGui.QRegExpValidator(QtCore.QRegExp('[0-9]*')))
        self.AD_stimTimeLine.setObjectName("AD_stimTimeLine")

        self.AD_fileButton = QtWidgets.QPushButton(self.AD_page)
        self.AD_fileButton.setGeometry(QtCore.QRect(640, 13, 31, 31))
        font.setPointSize(13)
        self.AD_fileButton.setFont(font)
        self.AD_fileButton.setObjectName("AD_fileButton")

        self.AD_sendButton = QtWidgets.QPushButton(self.AD_page)
        self.AD_sendButton.setGeometry(QtCore.QRect(580, 80, 91, 31))
        font.setPointSize(13)
        self.AD_sendButton.setFont(font)
        self.AD_sendButton.setObjectName("AD_sendButton")

        self.AD_stimLine1 = QtWidgets.QLineEdit(self.AD_page)
        self.AD_stimLine1.setGeometry(QtCore.QRect(40, 205, 181, 21))
        self.AD_stimLine1.setObjectName("AD_stimLine1")

        self.AD_stimLine2 = QtWidgets.QLineEdit(self.AD_page)
        self.AD_stimLine2.setGeometry(QtCore.QRect(40, 235, 181, 21))
        self.AD_stimLine2.setObjectName("AD_stimLine2")

        self.AD_stimLine3 = QtWidgets.QLineEdit(self.AD_page)
        self.AD_stimLine3.setGeometry(QtCore.QRect(40, 265, 181, 21))
        self.AD_stimLine3.setObjectName("AD_stimLine3")

        self.AD_stimButton1 = QtWidgets.QPushButton(self.AD_page)
        self.AD_stimButton1.setGeometry(QtCore.QRect(230, 205, 101, 21))
        self.AD_stimButton1.setObjectName("AD_stimButton1")

        self.AD_stimButton2 = QtWidgets.QPushButton(self.AD_page)
        self.AD_stimButton2.setGeometry(QtCore.QRect(230, 235, 101, 21))
        self.AD_stimButton2.setObjectName("AD_stimButton2")

        self.AD_stimButton3 = QtWidgets.QPushButton(self.AD_page)
        self.AD_stimButton3.setGeometry(QtCore.QRect(230, 265, 101, 21))
        self.AD_stimButton3.setObjectName("AD_stimButton3")

        self.AD_stimButton4 = QtWidgets.QPushButton(self.AD_page)
        self.AD_stimButton4.setGeometry(QtCore.QRect(510, 250, 161, 28))
        self.AD_stimButton4.setObjectName("AD_stimButton4")

        self.AD_checkBox1 = QtWidgets.QCheckBox(self.AD_page)
        self.AD_checkBox1.setGeometry(QtCore.QRect(390, 205, 91, 21))
        self.AD_checkBox1.setIconSize(QtCore.QSize(20, 20))
        self.AD_checkBox1.setObjectName("AD_checkBox1")

        self.AD_checkBox2 = QtWidgets.QCheckBox(self.AD_page)
        self.AD_checkBox2.setGeometry(QtCore.QRect(390, 235, 91, 21))
        self.AD_checkBox2.setIconSize(QtCore.QSize(20, 20))
        self.AD_checkBox2.setObjectName("AD_checkBox2")

        self.AD_checkBox3 = QtWidgets.QCheckBox(self.AD_page)
        self.AD_checkBox3.setGeometry(QtCore.QRect(390, 265, 91, 21))
        self.AD_checkBox3.setIconSize(QtCore.QSize(20, 20))
        self.AD_checkBox3.setObjectName("AD_checkBox3")

        self.tabWidget.addTab(self.AD_page, "")

        # Reaction a l'appuye des boutons
        self.AD_fileButton.clicked.connect(lambda:self.AD(self.AD_fileButton.text()))
        self.AD_sendButton.clicked.connect(lambda:self.AD(self.AD_sendButton.text()))
        self.AD_stimButton1.clicked.connect(lambda:self.AD(self.AD_stimButton1.text()))
        self.AD_stimButton2.clicked.connect(lambda:self.AD(self.AD_stimButton2.text()))
        self.AD_stimButton3.clicked.connect(lambda:self.AD(self.AD_stimButton3.text()))
        self.AD_stimButton4.clicked.connect(lambda:self.AD(self.AD_stimButton4.text()))


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

    ## PARAMETRAGE DU HOME

        self.Home_title.setText(_translate("Interface", "Pc - Neuromorphic ship Interface"))
        self.Home_subtitle1.setText(_translate("Interface", "Ronan Le Corronc\'s 2022 internship project"))
        self.Home_subtitle3.setText(_translate("Interface", "Supervised by Timothée Levi and Takashi Kohno"))
        self.Home_subtitle2.setText(_translate("Interface", "In cooperation with Ashish Gautam"))

    ## PARAMETRAGE DU STATIC

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

    ## PARAMETRAGE DE L'ADDRESS DECODER

        self.AD_titleLabel1.setText(_translate("Interface", ".CSV file location :"))
        self.AD_titleLabel2.setText(_translate("Interface", "Stimulation time (ms) :"))
        self.AD_titleLabel3.setText(_translate("Interface", "Start stimulation :"))
        self.AD_titleLabel4.setText(_translate("Interface", "Manual stimulation :"))
        self.AD_titleLabel5.setText(_translate("Interface", "Simultaneous stimulation :"))
        self.AD_descriptionLabel1.setText(_translate("Interface", "Please select the location of the .csv file containing the information to stimulate the synapses"))
        self.AD_descriptionLabel2.setText(_translate("Interface", "Please select the duration of synapse stimulation"))
        self.AD_descriptionLabel3.setText(_translate("Interface", "1"))
        self.AD_descriptionLabel4.setText(_translate("Interface", "2"))
        self.AD_descriptionLabel5.setText(_translate("Interface", "3"))
        self.AD_descriptionLabel6.setText(_translate("Interface", "Please select the synapse\'s number"))
        self.AD_descriptionLabel7.setText(_translate("Interface", "Stimulate the ticked synapses"))
        self.AD_informationLabel1.setText(_translate("Interface", "Waiting for data sending..."))
        self.AD_informationLabel2.setText(_translate("Interface", "Waiting for data sending..."))

        self.AD_fileButton.setText(_translate("Interface", "..."))
        self.AD_sendButton.setText(_translate("Interface", "Launch"))
        self.AD_stimButton1.setText(_translate("Interface", "Stimulate 1"))
        self.AD_stimButton2.setText(_translate("Interface", "Stimulate 2"))
        self.AD_stimButton3.setText(_translate("Interface", "Stimulate 3"))
        self.AD_stimButton4.setText(_translate("Interface", "Stimulate"))

        self.AD_checkBox1.setText(_translate("Interface", "synapse 1"))
        self.AD_checkBox2.setText(_translate("Interface", "synapse 2"))
        self.AD_checkBox3.setText(_translate("Interface", "synapse 3"))

        self.AD_enterFileLine.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.AD_stimTimeLine.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.AD_stimLine1.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.AD_stimLine2.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.AD_stimLine3.setStyleSheet('background-color:rgb(255, 255, 255)')

        self.AD_fileButton.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.AD_sendButton.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.AD_stimButton1.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.AD_stimButton2.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.AD_stimButton3.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.AD_stimButton4.setStyleSheet('background-color:rgb(255, 255, 255)')

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



### ACTIONS DU STATIC ###
    def static(self):

    ## Envoi des donnees
        if len(self.St_dataLine.text()) == 2:
            sendData(self.St_dataLine.text(), self.St_portSelect.currentText())
            self.St_informationLabel.setText("The data 0x"+self.St_dataLine.text()+" has been written correctly on the "+self.St_portSelect.currentText()+" !")
            self.St_informationLabel.setStyleSheet('color:rgb(0, 200, 0)')
        else:
            self.St_informationLabel.setText("Error : Only "+str(len(self.St_dataLine.text()))+" character has been typed as data to send, please type 2.")
            self.St_informationLabel.setStyleSheet('color:rgb(230, 0, 0)')



### ACTIONS DE L'ADDRESS DECODER ###
    def AD(self, button):
        if button == '...':
            fileLocation, _ = QFileDialog.getOpenFileName(None, 'Open File', 'D:\\etude\\Stage\\Work\\Neuromorphic-system-interface\\Data', 'CSV Files (*.csv);;All Files (*)')
            if fileLocation:
                self.AD_enterFileLine.clear()
                self.AD_enterFileLine.insert(fileLocation)

        elif button == 'Launch':
            if len(self.AD_stimTimeLine.text()) != 0 and len(self.AD_enterFileLine.text()) != 0:
                AD.autoLaunch(self.AD_enterFileLine.text(), self.AD_stimTimeLine.text())
            else:
                print("Error")

        elif button == 'Stimulate 1':
            print(button)

        elif button == 'Stimulate 2':
            print(button)

        elif button == 'Stimulate 3':
            print(button)

        elif button == 'Stimulate':
            print(button)


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    Interface = QtWidgets.QDialog()
    ui = Ui_Interface()
    ui.setupUi(Interface)
    Interface.show()
    sys.exit(app.exec_())




"""

Next :

- Faire un test avec Ashish sur le static pour valider le fonctionnement des que possible

- Programmer le lineInformation1 pour le launch auto

- Programmer l'activation de la stimulation manuelle

- Programmer l'envoie des donnees en mode manuel dans le addressDecoder

- Programmer l'ouverture et la lecture du csv

- Programmer le systeme pour utiliser le temps de stimulation (voir avec Ashish pour comprendre comment envoyer les donnees)

- Programmer l'envoie

"""
