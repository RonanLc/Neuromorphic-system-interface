
from com import serialSend_JTAG # Link to com.py for send the data

def send_FTAG(data):
    data = bin(int(data, 16))   # Convert the hexadecimal data into binary data
    serialSend_JTAG(data)       # Call the com.py function for send to the FPGA