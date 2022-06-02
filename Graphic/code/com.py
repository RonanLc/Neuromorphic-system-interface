import serial

#serialPort = serial.Serial(port = "/dev/ttyUSB1", baudrate=800000, bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)

def dataSend(data):
    #serialPort.write(data)
    print(data)
