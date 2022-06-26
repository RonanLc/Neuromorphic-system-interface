
import serial
import time

serialPort = serial.Serial(port = "/dev/ttyUSB1", baudrate=800000,
                           bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)

serialString = ""                           # Used to hold data coming over UART

def serialSend_Static(port, data):
    ###################INPUT FROM GUI for static data##############################
    # Address of PORT A is b'\x00'
    # Address of PORT B is b'\x01'
    # Address of PORT C is b'\x02'
    # Address of PORT D is b'\x03'
    # Address of PORT E is b'\x04'
    # Address of PORT F is b'\x05'
    serialPort.write(port)  # Static Port
    time.sleep(.01)
    serialPort.write(data)  # Data to Port
    time.sleep(.01)
    ################################################################################


def serialSend_decoder(address):
    ##############################Activating Spike Address Decoder##################
    serialPort.write(b'\x20') #Choosing Address decoder
    time.sleep(.01)
    serialPort.write(address) #Address of the synapse
    time.sleep(.01)
    ################################################################################


def serialSend_JTAG(data):
    ##############################Send data for JTAG Chain##########################
    serialPort.write(b'\x13')  # JTAG Port B
    time.sleep(.1)
    serialPort.write(data)  # Maximum weightEE
    time.sleep(.1)
    ################################################################################