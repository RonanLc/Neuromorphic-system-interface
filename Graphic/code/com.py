
from serial import *

#with Serial(port="/dev/ttyUSB1", baudrate=115200, timeout=1, writeTimeout=1) as serial_port:

def serialSend(data):
    print(data)

"""with Serial(port='COM6', baudrate=115200, timeout=1, writeTimeout=1) as serial_port:
        if serial_port.isOpen():
            serial_port.write(data)

            while True:
                ligne = serial_port.read()
                print(ligne)"""
