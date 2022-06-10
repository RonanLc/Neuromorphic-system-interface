import pyserial
import time

a = 65

# packet = bytearray()
# packet.append(0x53) # S
# packet.append(0x50) # P
# packet.append(0x49) # I
# packet.append(0x78) # x
# packet.append(0x20) # space
# packet.append(0x30) # 0
# packet.append(0x20) # space
# packet.append(0x53) # S
# packet.append(0x54) # T
# packet.append(0x20) # space
# packet.append(0x31) # 1 -> nombre de bytes
# packet.append(0x20) # space
# packet.append(0x32) # 4 -> adresse
# packet.append(0x0D) # carriage return

Read_command = bytearray()
Read_command.append(0x53) # S
Read_command.append(0x50) # P
Read_command.append(0x49) # I
Read_command.append(0x78) # x
Read_command.append(0x20) # space
Read_command.append(0x30) # 0
Read_command.append(0x20) # space
Read_command.append(0x52) # R
Read_command.append(0x44) # D
Read_command.append(0x20) # space
Read_command.append(0x31) # 1
Read_command.append(0x31) # 1
Read_command.append(0x0D) # carriage return


with Serial(port="/dev/ttyUSB1", baudrate=115200, timeout=1, writeTimeout=1) as serial_port:
    if serial_port.isOpen():
        # serial_port.write(packet)
        serial_port.write(Read_command)
        while True:

            # serial_port.write(Read_command)
            # ligne = serial_port.read()
            # print(ligne)

            
            ligne = serial_port.read()
            print(ligne)

            

            # serial_port.write(chr(a).encode('ascii'))
            # if a<122:
            #     a+=1
            # else:
            #     a=97



###### Peut toujours être utile
# character = input("Enter a character: ")
# character = chr(a)
# binary = bin(ord(ligne))
# decimal = int(binary,2)
# print(decimal)

# ligne = serial_port.read()
# print(bin(ord(ligne)))

# if a<122:
#     a+=1
# else:
#     a=97

# time.sleep(0.01)
# character = input("Enter a character: 
# serial_port.write(character.encode('ascii'))

# character = input("Enter a character: ")
# if character == 'a':
# serial_port.write(packet)
# else:
# serial_port.write(character.encode('ascii'))
# # print(character)

# character = input("Enter a character: ")
# serial_port.write(chr(a).encode('ascii'))
# if(a < 122):
# a += 1
# else:
# a = 65

# packet.append(0x69) # i
# packet.append(0x57) # W
# packet.append(0x72) # r

# packet.append(0x52) # R
# packet.append(0x44) # D

# packet.append(0x57) # W
# packet.append(0x52) # R