
def sendData(data, address):

    port = {
        'Port A': '00',
        'Port B': '01',
        'Port C': '02',
        'Port D': '03',
        'Port E': '04',
        'Port F': '05',
    }

    address = port[address]

    address = bin(int(address, 16))
    data = bin(int(data, 16))

    dataSend(address)
    time.sleep(.01)
    dataSend(data)
    time.sleep(.01)