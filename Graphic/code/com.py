
with Serial(port="/dev/ttyUSB1", baudrate=800000, timeout=1, writeTimeout=1) as serial_port:
    if serial_port.isOpen():
        def dataSend(data):
            serialPort.write(data)

