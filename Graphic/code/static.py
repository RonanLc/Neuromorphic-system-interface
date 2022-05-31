
#import com
import time

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

    #com.dataSend(address)
    print(address)
    time.sleep(.01)
    #com.dataSend(data)
    print(data)
    time.sleep(.01)