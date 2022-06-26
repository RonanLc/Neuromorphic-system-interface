
import time
import pandas as pd
from com import serialSend_decoder # Link to com.py for send the data

class AD:

    def stimulate(self, address):     # Activate one synapse (the bottom left part of the address decoder page)
        address = bin(int(address))         # Convert the address into binary data
        serialSend_decoder(address)         # Link to the com.py for sending to the FPGA


    def syncro(self, address1, address2, address3, check1, check2, check3):
    # Send multiple values in sync (The bottom right part of the address decoder page)

        if check1: # For ligne 1
            address1 = bin(int(address1, 16))   # Convert the address into binary data
            serialSend_decoder(address1)        # Link to the com.py for sending to the FPGA

        if check2: # For ligne 1
            address2 = bin(int(address2, 16))
            serialSend_decoder(address2)

        if check3: # For ligne 1
            address3 = bin(int(address3, 16))
            serialSend_decoder(address3)



#################################### The part with the .csv file ####################################

    '''def initLaunch(self, file, Time):

        dataFile = pd.read_csv(file, header=None)
        dataSize = len(dataFile)
        state = [0]

        for i in range(1, dataSize):
            state.append(0)
            state.append(1)

            dfFile = pd.DataFrame({0: [dataFile[0][i] + (int(Time) / 1000)],
                                   1: [dataFile[1][i]]})

            dataFile = dataFile.append(dfFile, ignore_index=True)

        state = pd.DataFrame(state)
        state = state.sort_values(by=[0], na_position='first', ignore_index=True)

        dataFile[2] = state

        dataFile = dataFile.sort_values(by=[0], na_position='first', ignore_index=True)

        dataFile[1][1] = bin(dataFile[1][1])

        for i in range(1, len(dataFile)-1):
            dataFile[1][i+1] = bin(dataFile[1][i+1])
            dataFile[0][i+1] = dataFile[0][i+1] - dataFile[0][i]
            print(dataFile[0][i])

        return dataFile


    def autoLaunch(self, file, Time):

        dataFile = self.initLaunch(file, Time)

        for i in range(1, len(dataFile)):
            actualData = (dataFile[0][i], dataFile[1][i], dataFile[2][i])
            time.sleep(actualData[0])
            # Send state (dataFile[2]) a l'adresse (dataFile[1])
            print(actualData)'''

#####################################################################################################
