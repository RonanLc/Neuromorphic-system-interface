
from com import serialSend_Static # Link to com.py for send the data

def send_static(data, port):

#### Dictionary for various ports ####
    address = {
        'Port A': '00',
        'Port B': '01',
        'Port C': '02',
        'Port D': '03',
        'Port E': '04',
        'Port F': '05',
    }

    port = address[port] # Change the Port's letter for the Port's address with the dictionary

    port = bin(int(port, 16)) # Convert the hexadecimal data of the port into binary data
    data = bin(int(data, 16)) # Convert the hexadecimal data to send into binary data

    serialSend_Static(port, data) # Call the com.py function for send to the FPGA



