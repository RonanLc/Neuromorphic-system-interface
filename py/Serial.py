from serial import *

with Serial(port="/dev/ttyUSB1", baudrate=115200, timeout=1, writeTimeout=1) as serial_port:
    if serial_port.isOpen():
        character = input("Enter a character: ")
        serial_port.write(character.encode('ascii'))
        while True:
            ligne = serial_port.read()
            print(ligne)
 