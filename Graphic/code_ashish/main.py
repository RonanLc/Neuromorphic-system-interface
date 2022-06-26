
from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import QFileDialog
from static import send_static
from addressDecoder import AD
from JTAGChain import send_FTAG
from math import floor
import random

ad = AD()

############################################# SUMMARY #############################################

    ##### DECLARATION OF THE ELEMENTS #####.....................................................................Line 62
        ### Window declaration..................................................................................Line 66
        ### Page color declaration..............................................................................Line 72
        ### Page system declaration.............................................................................Line 81
        ### Home page declaration...............................................................................Line 92
        ### Static page declaration.............................................................................Line 136
        ### Address decoder page declaration....................................................................Line 200
        ### JTAG Chain page declaration.........................................................................Line 357
        ### Buttons actions link................................................................................Line 479
        ### Last declaration....................................................................................Line 501

    ##### SETTINGS OF THE ELEMENTS #####........................................................................Line 513
        ### Window settings.....................................................................................Line 517
        ### Home page settings..................................................................................Line 522
        ### Static page settings................................................................................Line 529
        ### Address decoder page settings.......................................................................Line 545
        ### JTAG Chain page settings............................................................................Line 586
        ### Global settings.....................................................................................Line 623

    ##### ADDITIONAL FUNCTIONS #####............................................................................Line 632
        ### Page color function.................................................................................Line 634

        ### Page static actions.................................................................................Line 651

        ### Page address decoder actions........................................................................Line 665
            ## Check that the data to be sent is correct........................................................Line 667
            ## Button to select the .csv file...................................................................Line 679
            ## Button to send data from .csv file (Desactivate).................................................Line 686
            ## Buttons to manually stimulate the synapses.......................................................Line 703
            ## Button to stimulate synapses simultaneously......................................................Line 714

        ### Page JTAG Chain actions.............................................................................Line 736
            ## Function to know the checked check boxes.........................................................Line 738
            ## Function verifying all the information indicated on the software for the random generation.......Line 749
            ## Function verifying all the information indicated on the software for send the selected lines.....Line 785
            ## Button for random generation.....................................................................Line 804
            ## Button for add a line............................................................................Line 815
            ## Button for select all the lines..................................................................Line 827
            ## Button for unselect all the lines................................................................Line 832
            ## Button for send the selected lines...............................................................Line 837
            ## Button for send only one line....................................................................Line 843

    ##### MAIN CODE #####.......................................................................................Line 854



class Ui_Interface(object):

##### DECLARATION OF THE ELEMENTS #####

    def setupUi(self, Interface):

    ### Window declaration ###

        Interface.setObjectName("Interface")
        Interface.setFixedSize(700, 350)
        font = QtGui.QFont()

    ### Page color declaration ###

        self.pageColor = QtWidgets.QLabel(Interface)
        self.pageColor.setGeometry(QtCore.QRect(0, 0, 700, 20))
        self.pageColor.setStyleSheet('color:rgb(255, 255, 255)')
        self.pageColor.setAlignment(QtCore.Qt.AlignRight | QtCore.Qt.AlignTrailing | QtCore.Qt.AlignVCenter)
        self.pageColor.setObjectName("pageColor")


    ### Page system declaration ###

        # Declaration du systeme de page
        self.tabWidget = QtWidgets.QTabWidget(Interface)
        self.tabWidget.setGeometry(QtCore.QRect(0, 0, 700, 350))
        self.tabWidget.setObjectName("tabWidget")

        # Changement de couleur en fonction de la page actuelle
        self.tabWidget.currentChanged.connect(self.pageChange)


    ### Home page declaration ###

        self.Home_page = QtWidgets.QWidget()
        self.Home_page.setObjectName("Home_page")

        self.Home_title = QtWidgets.QLabel(self.Home_page)
        self.Home_title.setGeometry(QtCore.QRect(110, 30, 470, 41))
        font.setPointSize(20)
        self.Home_title.setFont(font)
        self.Home_title.setObjectName("Home_title")

        self.Home_subtitle1 = QtWidgets.QLabel(self.Home_page)
        self.Home_subtitle1.setGeometry(QtCore.QRect(180, 80, 331, 20))
        font.setPointSize(11)
        self.Home_subtitle1.setFont(font)
        self.Home_subtitle1.setObjectName("Home_subtitle1")

        self.Home_subtitle2 = QtWidgets.QLabel(self.Home_page)
        self.Home_subtitle2.setGeometry(QtCore.QRect(190, 100, 301, 20))
        font.setPointSize(12)
        self.Home_subtitle2.setFont(font)
        self.Home_subtitle2.setObjectName("Home_subtitle2")

        self.Home_subtitle3 = QtWidgets.QLabel(self.Home_page)
        self.Home_subtitle3.setGeometry(QtCore.QRect(140, 160, 411, 20))
        font.setPointSize(12)
        self.Home_subtitle3.setFont(font)
        self.Home_subtitle3.setObjectName("Home_subtitle3")

        self.Home_photo1 = QtWidgets.QLabel(self.Home_page)
        self.Home_photo1.setGeometry(QtCore.QRect(60, 210, 221, 101))
        self.Home_photo1.setPixmap(QtGui.QPixmap("../../Data/iisUTokyo.png"))
        self.Home_photo1.setScaledContents(True)
        self.Home_photo1.setObjectName("Home_photo1")

        self.Home_photo2 = QtWidgets.QLabel(self.Home_page)
        self.Home_photo2.setGeometry(QtCore.QRect(410, 215, 221, 81))
        self.Home_photo2.setPixmap(QtGui.QPixmap("../../Data/UBordeaux.png"))
        self.Home_photo2.setScaledContents(True)
        self.Home_photo2.setObjectName("Home_photo2")

        self.tabWidget.addTab(self.Home_page, "")


    ### Static page declaration ###

        self.St_page = QtWidgets.QWidget()
        self.St_page.setObjectName("St_page")

        self.St_dataLine = QtWidgets.QLineEdit(self.St_page)
        self.St_dataLine.setGeometry(QtCore.QRect(350, 30, 60, 31))
        self.St_dataLine.setStyleSheet('background-color:rgb(255, 255, 255)')
        font.setPointSize(15)
        self.St_dataLine.setFont(font)
        self.St_dataLine.setObjectName("St_dataLine")
        self.St_dataLine.setMaxLength(2)
        self.St_dataLine.setValidator(QtGui.QRegExpValidator(QtCore.QRegExp('[A-Fa-f0-9]*')))

        self.St_sendButton = QtWidgets.QPushButton(self.St_page)
        self.St_sendButton.setGeometry(QtCore.QRect(200, 240, 110, 31))
        self.St_sendButton.setStyleSheet('background-color:rgb(255, 255, 255)')
        font.setPointSize(13)
        self.St_sendButton.setFont(font)
        self.St_sendButton.setObjectName("St_sendButton")

        self.St_portSelect = QtWidgets.QComboBox(self.St_page)
        self.St_portSelect.setGeometry(QtCore.QRect(330, 140, 140, 31))
        self.St_portSelect.setStyleSheet('background-color:rgb(255, 255, 255)')
        font.setPointSize(13)
        self.St_portSelect.setFont(font)
        self.St_portSelect.setObjectName("St_portSelect")
        for i in range(6):
            self.St_portSelect.addItem("")

        self.St_titleLabel1 = QtWidgets.QLabel(self.St_page)
        self.St_titleLabel1.setGeometry(QtCore.QRect(30, 30, 310, 31))
        font.setPointSize(15)
        self.St_titleLabel1.setFont(font)
        self.St_titleLabel1.setObjectName("St_titleLabel1")

        self.St_titleLabel2 = QtWidgets.QLabel(self.St_page)
        self.St_titleLabel2.setGeometry(QtCore.QRect(30, 130, 280, 31))
        font.setPointSize(15)
        self.St_titleLabel2.setFont(font)
        self.St_titleLabel2.setObjectName("St_titleLabel2")

        self.St_titleLabel3 = QtWidgets.QLabel(self.St_page)
        self.St_titleLabel3.setGeometry(QtCore.QRect(30, 240, 160, 31))
        font.setPointSize(15)
        self.St_titleLabel3.setFont(font)
        self.St_titleLabel3.setObjectName("St_titleLabel3")

        self.St_descriptionLabel1 = QtWidgets.QLabel(self.St_page)
        self.St_descriptionLabel1.setGeometry(QtCore.QRect(30, 60, 310, 16))
        self.St_descriptionLabel1.setObjectName("St_descriptionLabel1")

        self.St_descriptionLabel2 = QtWidgets.QLabel(self.St_page)
        self.St_descriptionLabel2.setGeometry(QtCore.QRect(30, 160, 250, 16))
        self.St_descriptionLabel2.setObjectName("St_descriptionLabel2")

        self.St_informationLabel = QtWidgets.QLabel(self.St_page)
        self.St_informationLabel.setGeometry(QtCore.QRect(220, 290, 460, 16))
        self.St_informationLabel.setAlignment(QtCore.Qt.AlignRight|QtCore.Qt.AlignTrailing|QtCore.Qt.AlignVCenter)
        self.St_informationLabel.setObjectName("St_informationLabel")

        self.tabWidget.addTab(self.St_page, "")


    ### Address decoder page declaration ###

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
        self.AD_stimLine1.setValidator(QtGui.QRegExpValidator(QtCore.QRegExp('[0-9]*')))
        self.AD_stimLine1.setObjectName("AD_stimLine1")

        self.AD_stimLine2 = QtWidgets.QLineEdit(self.AD_page)
        self.AD_stimLine2.setGeometry(QtCore.QRect(40, 235, 181, 21))
        self.AD_stimLine2.setValidator(QtGui.QRegExpValidator(QtCore.QRegExp('[0-9]*')))
        self.AD_stimLine2.setObjectName("AD_stimLine2")

        self.AD_stimLine3 = QtWidgets.QLineEdit(self.AD_page)
        self.AD_stimLine3.setGeometry(QtCore.QRect(40, 265, 181, 21))
        self.AD_stimLine3.setValidator(QtGui.QRegExpValidator(QtCore.QRegExp('[0-9]*')))
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


    ### JTAG Chain page declaration ###

        self.RD_page = QtWidgets.QWidget()
        self.RD_page.setObjectName("RD_page")

        self.scrollArea = QtWidgets.QScrollArea(self.RD_page)
        self.scrollArea.setGeometry(QtCore.QRect(10, 110, 551, 181))
        self.scrollArea.setWidgetResizable(True)
        self.scrollArea.setObjectName("scrollArea")

        self.scrollAreaGrid = QtWidgets.QWidget()
        self.scrollAreaGrid.setGeometry(QtCore.QRect(0, 0, 549, 179))
        self.scrollAreaGrid.setObjectName("scrollAreaGrid")

        self.grid = QtWidgets.QGridLayout(self.scrollAreaGrid)
        self.grid.setObjectName("grid")

        self.check_boxes = []
        self.line_edits = []
        self.push_buttons = []

        for i in range(3):
            self.check_boxes.append(QtWidgets.QCheckBox(self.scrollAreaGrid))
            self.check_boxes[-1].setObjectName("RD_checkBox")
            self.check_boxes[-1].setCheckState(2)
            self.grid.addWidget(self.check_boxes[-1], len(self.check_boxes)-1, 0, 1, 1)
            self.line_edits.append(QtWidgets.QLineEdit(self.scrollAreaGrid))
            self.line_edits[-1].setValidator(QtGui.QRegExpValidator(QtCore.QRegExp('[A-Fa-f0-9]*')))
            self.line_edits[-1].setObjectName("lineEdit")
            self.grid.addWidget(self.line_edits[-1], len(self.line_edits)-1, 1, 1, 1)

        self.scrollArea.setWidget(self.scrollAreaGrid)

        self.RD_titleLabel1 = QtWidgets.QLabel(self.RD_page)
        self.RD_titleLabel1.setGeometry(QtCore.QRect(20, 10, 181, 31))
        font.setPointSize(15)
        self.RD_titleLabel1.setFont(font)
        self.RD_titleLabel1.setObjectName("RD_titleLabel1")

        self.RD_titleLabel2 = QtWidgets.QLabel(self.RD_page)
        self.RD_titleLabel2.setGeometry(QtCore.QRect(290, 71, 291, 31))
        font.setPointSize(15)
        self.RD_titleLabel2.setFont(font)
        self.RD_titleLabel2.setObjectName("RD_titleLabel2")

        self.RD_titleLabel3 = QtWidgets.QLabel(self.RD_page)
        self.RD_titleLabel3.setGeometry(QtCore.QRect(580, 140, 101, 61))
        self.RD_titleLabel3.setWordWrap(True)
        self.RD_titleLabel3.setAlignment(QtCore.Qt.AlignCenter)
        font.setPointSize(14)
        self.RD_titleLabel3.setFont(font)
        self.RD_titleLabel3.setObjectName("RD_titleLabel3")

        self.RD_descriptionLabel1 = QtWidgets.QLabel(self.RD_page)
        self.RD_descriptionLabel1.setGeometry(QtCore.QRect(20, 40, 391, 16))
        self.RD_descriptionLabel1.setObjectName("RD_descriptionLabel1")
        self.RD_descriptionLabel2 = QtWidgets.QLabel(self.RD_page)
        self.RD_descriptionLabel2.setGeometry(QtCore.QRect(430, 40, 151, 16))
        self.RD_descriptionLabel2.setObjectName("RD_descriptionLabel2")

        self.RD_informationLabel = QtWidgets.QLabel(self.RD_page)
        self.RD_informationLabel.setGeometry(QtCore.QRect(260, 300, 421, 16))
        self.RD_informationLabel.setAlignment(QtCore.Qt.AlignRight | QtCore.Qt.AlignTrailing | QtCore.Qt.AlignVCenter)
        self.RD_informationLabel.setObjectName("RD_informationLabel")

        self.RD_minLine = QtWidgets.QLineEdit(self.RD_page)
        self.RD_minLine.setGeometry(QtCore.QRect(210, 10, 81, 31))
        self.RD_minLine.setValidator(QtGui.QRegExpValidator(QtCore.QRegExp('[A-Fa-f0-9]*')))
        self.RD_minLine.setMaxLength(1)
        font.setPointSize(13)
        self.RD_minLine.setFont(font)
        self.RD_minLine.setAlignment(QtCore.Qt.AlignCenter)
        self.RD_minLine.setObjectName("RD_minLine")

        self.RD_maxLine = QtWidgets.QLineEdit(self.RD_page)
        self.RD_maxLine.setGeometry(QtCore.QRect(300, 10, 81, 31))
        self.RD_maxLine.setValidator(QtGui.QRegExpValidator(QtCore.QRegExp('[A-Fa-f0-9]*')))
        self.RD_maxLine.setMaxLength(1)
        font.setPointSize(13)
        self.RD_maxLine.setFont(font)
        self.RD_maxLine.setAlignment(QtCore.Qt.AlignCenter)
        self.RD_maxLine.setObjectName("RD_maxLine")

        self.RD_sizeLine = QtWidgets.QLineEdit(self.RD_page)
        self.RD_sizeLine.setGeometry(QtCore.QRect(430, 10, 91, 31))
        self.RD_sizeLine.setValidator(QtGui.QRegExpValidator(QtCore.QRegExp('[0-9]*')))
        self.RD_sizeLine.setAlignment(QtCore.Qt.AlignCenter)
        self.RD_sizeLine.setObjectName("RD_sizeLine")

        self.RD_randomButton = QtWidgets.QPushButton(self.RD_page)
        self.RD_randomButton.setGeometry(QtCore.QRect(540, 10, 141, 31))
        self.RD_randomButton.setObjectName("RD_randomButton")

        self.RD_addButton = QtWidgets.QPushButton(self.RD_page)
        self.RD_addButton.setGeometry(QtCore.QRect(10, 71, 81, 28))
        self.RD_addButton.setObjectName("RD_addButton")

        self.RD_selectButton = QtWidgets.QPushButton(self.RD_page)
        self.RD_selectButton.setGeometry(QtCore.QRect(100, 71, 81, 28))
        self.RD_selectButton.setObjectName("RD_selectButton")

        self.RD_unselectButton = QtWidgets.QPushButton(self.RD_page)
        self.RD_unselectButton.setGeometry(QtCore.QRect(182, 71, 91, 28))
        self.RD_unselectButton.setObjectName("RD_unselectButton")

        self.RD_sendAllButton = QtWidgets.QPushButton(self.RD_page)
        self.RD_sendAllButton.setGeometry(QtCore.QRect(580, 70, 101, 31))
        self.RD_sendAllButton.setObjectName("RD_sendAllButton")

        self.RD_sendButton = QtWidgets.QPushButton(self.RD_page)
        self.RD_sendButton.setGeometry(QtCore.QRect(580, 250, 101, 31))
        self.RD_sendButton.setObjectName("RD_sendButton")

        self.RD_selectBox = QtWidgets.QComboBox(self.RD_page)
        self.RD_selectBox.setGeometry(QtCore.QRect(580, 210, 101, 31))
        self.RD_selectBox.setObjectName("RD_selectBox")
        for i in range(3):
            self.RD_selectBox.addItem("")

        self.tabWidget.addTab(self.RD_page, "")


    ### Buttons actions link ###

        # Static buttons
        self.St_sendButton.clicked.connect(self.static)

        # Address decoder buttons
        self.AD_fileButton.clicked.connect(lambda:self.AD(self.AD_fileButton.text()))
        self.AD_sendButton.clicked.connect(lambda:self.AD(self.AD_sendButton.text()))
        self.AD_stimButton1.clicked.connect(lambda:self.AD(self.AD_stimButton1.text()))
        self.AD_stimButton2.clicked.connect(lambda:self.AD(self.AD_stimButton2.text()))
        self.AD_stimButton3.clicked.connect(lambda:self.AD(self.AD_stimButton3.text()))
        self.AD_stimButton4.clicked.connect(lambda:self.AD(self.AD_stimButton4.text()))

        # JTAG Chain buttons
        self.RD_randomButton.clicked.connect(lambda: self.RD(self.RD_randomButton.text()))
        self.RD_addButton.clicked.connect(lambda: self.RD(self.RD_addButton.text()))
        self.RD_selectButton.clicked.connect(lambda: self.RD(self.RD_selectButton.text()))
        self.RD_unselectButton.clicked.connect(lambda: self.RD(self.RD_unselectButton.text()))
        self.RD_sendAllButton.clicked.connect(lambda: self.RD(self.RD_sendAllButton.text()))
        self.RD_sendButton.clicked.connect(lambda: self.RD(self.RD_sendButton.text()))


    ### Last declaration

        self.pageColor.raise_()
        self.tabWidget.raise_()

        self.retranslateUi(Interface)
        self.tabWidget.setCurrentIndex(0)
        self.pageChange()
        QtCore.QMetaObject.connectSlotsByName(Interface)



##### SETTINGS OF THE ELEMENTS #####

    def retranslateUi(self, Interface):

    ### Window settings
        _translate = QtCore.QCoreApplication.translate
        Interface.setWindowTitle(_translate("Interface", "PC - Neuromorphic ship Interface"))
        self.pageColor.setText(_translate("Interface", "")) #Developed by Ronan Le Corronc

    ### Home page settings

        self.Home_title.setText(_translate("Interface", "Pc - Neuromorphic ship Interface"))
        self.Home_subtitle1.setText(_translate("Interface", "Ronan Le Corronc\'s 2022 internship project"))
        self.Home_subtitle3.setText(_translate("Interface", "Supervised by Takashi Kohno and Timothée Levi"))
        self.Home_subtitle2.setText(_translate("Interface", "In cooperation with Ashish Gautam"))

    ### Static page settings

        self.St_sendButton.setText(_translate("Interface", "Send"))

        ports = ['A', 'B', 'C', 'D', 'E', 'F']
        for i, port in enumerate(ports):
            self.St_portSelect.setItemText(i, _translate('Interface', f'Port {port}'))

        self.St_titleLabel1.setText(_translate("Interface", "Static data to be submitted :"))
        self.St_titleLabel2.setText(_translate("Interface", "Location of data sending :"))
        self.St_titleLabel3.setText(_translate("Interface", "Sending data :"))

        self.St_descriptionLabel1.setText(_translate("Interface", "Please select a 2-character hexadecimal value"))
        self.St_descriptionLabel2.setText(_translate("Interface", "Please select the data destination port"))
        self.St_informationLabel.setText(_translate("Interface", "Waiting for data sending..."))

    ### Address decoder page settings

        self.AD_titleLabel1.setText(_translate("Interface", ".CSV file location :"))
        self.AD_titleLabel2.setText(_translate("Interface", "Pulsation rate (ms) :"))
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

    ### JTAG Chain page settings

        for i in range(len(self.check_boxes)):
            self.check_boxes[i].setText(_translate("Interface", f"{i + 1}"))

        self.RD_titleLabel1.setText(_translate("Interface", "Set parameters :"))
        self.RD_titleLabel2.setText(_translate("Interface", "Send values to flips-flops :"))
        self.RD_titleLabel3.setText(_translate("Interface", "Send only one data"))
        self.RD_descriptionLabel1.setText(_translate("Interface", "Please select min en max hex values for random generation"))
        self.RD_descriptionLabel2.setText(_translate("Interface", "Register size (in Bits)"))
        self.RD_informationLabel.setText(_translate("Interface", "Waiting for data sending..."))

        self.RD_minLine.setText(_translate("Interface", "0"))
        self.RD_maxLine.setText(_translate("Interface", "F"))
        self.RD_sizeLine.setText(_translate("Interface", "8"))
        self.RD_randomButton.setText(_translate("Interface", "Set random values"))
        self.RD_addButton.setText(_translate("Interface", "Add a line"))
        self.RD_selectButton.setText(_translate("Interface", "Select all"))
        self.RD_unselectButton.setText(_translate("Interface", "Unselect all"))
        self.RD_sendAllButton.setText(_translate("Interface", "Send select"))
        self.RD_sendButton.setText(_translate("Interface", "Send one"))

        for i in range(len(self.check_boxes)):
            self.RD_selectBox.setItemText(i, _translate("Interface", f"Line {i+1}"))

        self.RD_minLine.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.RD_maxLine.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.RD_sizeLine.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.RD_randomButton.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.RD_addButton.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.RD_selectButton.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.RD_unselectButton.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.RD_sendAllButton.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.RD_sendButton.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.RD_selectBox.setStyleSheet('background-color:rgb(255, 255, 255)')
        self.scrollArea.setStyleSheet('background-color:rgb(255, 255, 255)')

    ### Global settings

        self.tabWidget.setTabText(self.tabWidget.indexOf(self.Home_page), _translate("Interface", "Home"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.St_page), _translate("Interface", "Static"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.AD_page), _translate("Interface", "Address decoder"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.RD_page), _translate("Interface", "JTAG Chain"))



##### ADDITIONAL FUNCTIONS #####

### Page color function
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



### Page static actions

    def static(self):

        if len(self.St_dataLine.text()) == 2:
            send_static(self.St_dataLine.text(), self.St_portSelect.currentText()) # Link to the static.py code
            self.St_informationLabel.setText("The data 0x"+self.St_dataLine.text()+" has been written correctly on the "+self.St_portSelect.currentText()+" !")
            self.St_informationLabel.setStyleSheet('color:rgb(0, 200, 0)')
        else:
            self.St_informationLabel.setText("Error : Only "+str(len(self.St_dataLine.text()))+" character has been typed as data to send, please type 2.")
            self.St_informationLabel.setStyleSheet('color:rgb(230, 0, 0)')



### Page address decoder actions

    ## Check that the data to be sent is correct
    def AD_verify(self, data):
        if data != 0:
            self.AD_informationLabel2.setStyleSheet('color:rgb(0, 200, 0)')
            self.AD_informationLabel2.setText("Launching the stimulation correctly !")
            return True
        elif data == 0:
            self.AD_informationLabel2.setStyleSheet('color:rgb(230, 0, 0)')
            self.AD_informationLabel2.setText("Please select the synapse\'s number.")

    def AD(self, button):

        ## Button to select the .csv file
        if button == '...':
            fileLocation, _ = QFileDialog.getOpenFileName(None, 'Open File', 'D:\\etude\\Stage\\Work\\Neuromorphic-system-interface\\Data', 'CSV Files (*.csv);;All Files (*)')
            if fileLocation:
                self.AD_enterFileLine.clear()
                self.AD_enterFileLine.insert(fileLocation)

        ## Button to send data from .csv file (Desactivate)
    #    elif button == 'Launch':
    #        if len(self.AD_stimTimeLine.text()) != 0 and len(self.AD_enterFileLine.text()) != 0:
    #            ad.autoLaunch(self.AD_enterFileLine.text(), self.AD_stimTimeLine.text())
    #            self.AD_informationLabel1.setStyleSheet('color:rgb(0, 200, 0)')
    #            self.AD_informationLabel1.setText("Stimulation success !")
    #        elif len(self.AD_stimTimeLine.text()) != 0 and len(self.AD_enterFileLine.text()) == 0:
    #            self.AD_informationLabel1.setStyleSheet('color:rgb(230, 0, 0)')
    #            self.AD_informationLabel1.setText("Please select a .csv file.")
    #        elif len(self.AD_stimTimeLine.text()) == 0 and len(self.AD_enterFileLine.text()) != 0:
    #            self.AD_informationLabel1.setStyleSheet('color:rgb(230, 0, 0)')
    #            self.AD_informationLabel1.setText("Please select a stimulation time.")
    #        elif len(self.AD_stimTimeLine.text()) == 0 and len(self.AD_enterFileLine.text()) == 0:
    #            self.AD_informationLabel1.setStyleSheet('color:rgb(230, 0, 0)')
    #            self.AD_informationLabel1.setText("Please select a .csv file and a stimulation time.")


        ## Buttons to manually stimulate the synapses
        elif button == 'Stimulate 1':
            if self.AD_verify(len(self.AD_stimLine1.text())):
                ad.stimulate(self.AD_stimLine1.text())
        elif button == 'Stimulate 2':
            if self.AD_verify(len(self.AD_stimLine2.text())):
                ad.stimulate(self.AD_stimLine2.text())
        elif button == 'Stimulate 3':
            if self.AD_verify(len(self.AD_stimLine3.text())):
                ad.stimulate(self.AD_stimLine3.text())

        ## Button to stimulate synapses simultaneously
        elif button == 'Stimulate':
            state = 0
            if not self.AD_checkBox1.checkState() and not self.AD_checkBox2.checkState() and not self.AD_checkBox2.checkState():
                state = 1
                self.AD_informationLabel2.setStyleSheet('color:rgb(230, 0, 0)')
                self.AD_informationLabel2.setText("Please check at least one box.")
            if self.AD_checkBox1.checkState() and state == 0:
                if not self.AD_verify(len(self.AD_stimLine1.text())):
                    state = 1
            if self.AD_checkBox2.checkState() and state == 0:
                if not self.AD_verify(len(self.AD_stimLine2.text())):
                    state = 1
            if self.AD_checkBox3.checkState() and state == 0:
                if not self.AD_verify(len(self.AD_stimLine3.text())):
                    state = 1
            if state == 0:
                ad.syncro(self.AD_stimLine1.text(), self.AD_stimLine2.text(), self.AD_stimLine3.text(),
                          self.AD_checkBox1.checkState(), self.AD_checkBox2.checkState(), self.AD_checkBox3.checkState())



### Page JTAG Chain actions

    ## Function to know the checked check boxes
    def RD_checkBox(self):
        self.select_lines = []
        for i in range(len(self.check_boxes)):
            if self.check_boxes[i].checkState() == 2:
                self.select_lines.append(self.line_edits[i])
        return len(self.select_lines)


    def RD_verify(self, call):

        ## Function verifying all the information indicated on the software for the random generation
        if call == 'random':
            if self.RD_checkBox() != 0:
                if len(self.RD_sizeLine.text()) != 0:
                    if (int(self.RD_sizeLine.text())/4)%1 == 0:
                        if len(self.RD_minLine.text()) != 0:
                            if len(self.RD_maxLine.text()) != 0:
                                if not int(self.RD_minLine.text(), 16) > int(self.RD_maxLine.text(), 16):
                                    self.RD_informationLabel.setText('Generation of random values')
                                    self.RD_informationLabel.setStyleSheet('color:rgb(0, 200, 0)')
                                    return True
                                else:
                                    self.RD_informationLabel.setText('The min value cannot be higher than the max.')
                                    self.RD_informationLabel.setStyleSheet('color:rgb(230, 0, 0)')
                                    return False
                            else:
                                self.RD_informationLabel.setText('Please set a max value')
                                self.RD_informationLabel.setStyleSheet('color:rgb(230, 0, 0)')
                                return False
                        else:
                            self.RD_informationLabel.setText('Please set a min value')
                            self.RD_informationLabel.setStyleSheet('color:rgb(230, 0, 0)')
                            return False
                    else:
                        self.RD_informationLabel.setText('Please set in size a multiple of 4')
                        self.RD_informationLabel.setStyleSheet('color:rgb(230, 0, 0)')
                        return False
                else:
                    self.RD_informationLabel.setText('Please set a size value')
                    self.RD_informationLabel.setStyleSheet('color:rgb(230, 0, 0)')
                    return False
            else:
                self.RD_informationLabel.setText('Please select a line')
                self.RD_informationLabel.setStyleSheet('color:rgb(230, 0, 0)')
                return False

        ## Function verifying all the information indicated on the software for send the selected lines
        if call == 'sendSelect':
            if self.RD_checkBox() != 0:
                for i in range(len(self.select_lines)):
                    if len(self.select_lines[i].text()) == 0:
                        self.RD_informationLabel.setText('Please enter data on all selected lines')
                        self.RD_informationLabel.setStyleSheet('color:rgb(230, 0, 0)')
                        return False
                self.RD_informationLabel.setText('Successful sending of data')
                self.RD_informationLabel.setStyleSheet('color:rgb(0, 200, 0)')
                return True
            else:
                self.RD_informationLabel.setText('Please select a line')
                self.RD_informationLabel.setStyleSheet('color:rgb(230, 0, 0)')
                return False


    def RD(self, button):

        ## Button for random generation
        if button == 'Set random values':
            if self.RD_verify('random'):
                for y in range(len(self.select_lines)):
                    self.select_lines[y].clear()
                    for i in range(floor(int(self.RD_sizeLine.text()) / 4)):
                        min = int(self.RD_minLine.text(), 16)
                        max = int(self.RD_maxLine.text(), 16)
                        r = str(hex(random.randint(min, max)))
                        self.select_lines[y].insert(r[2])

        ## Button for add a line
        elif button == 'Add a line':
            self.check_boxes.append(QtWidgets.QCheckBox(self.scrollAreaGrid))
            self.check_boxes[-1].setObjectName("RD_checkBox")
            self.check_boxes[-1].setCheckState(2)
            self.grid.addWidget(self.check_boxes[-1], len(self.check_boxes)-1, 0, 1, 1)
            self.line_edits.append(QtWidgets.QLineEdit(self.scrollAreaGrid))
            self.line_edits[-1].setObjectName("lineEdit")
            self.grid.addWidget(self.line_edits[-1], len(self.line_edits)-1, 1, 1, 1)
            self.RD_selectBox.addItem("")
            self.retranslateUi(Interface)

        ## Button for select all the lines
        elif button == 'Select all':
            for i in range(len(self.check_boxes)):
                self.check_boxes[i].setCheckState(2)

        ## Button for unselect all the lines
        elif button == 'Unselect all':
            for i in range(len(self.check_boxes)):
                self.check_boxes[i].setCheckState(0)

        ## Button for send the selected lines
        elif button == 'Send select':
            if self.RD_verify('sendSelect'):
                for i in range(len(self.select_lines)):
                    send_FTAG(self.select_lines[i].text())

        ## Button for send only one line
        elif button == 'Send one':
            index = self.RD_selectBox.currentIndex()
            if len(self.line_edits[index].text()) != 0:
                send_FTAG(self.line_edits[index].text())
                self.RD_informationLabel.setText('Successful sending of data')
                self.RD_informationLabel.setStyleSheet('color:rgb(0, 200, 0)')
            else:
                self.RD_informationLabel.setText('Please enter data on the line')
                self.RD_informationLabel.setStyleSheet('color:rgb(230, 0, 0)')

##### MAIN CODE #####
if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    Interface = QtWidgets.QDialog()
    ui = Ui_Interface()
    ui.setupUi(Interface)
    Interface.show()
    sys.exit(app.exec_())