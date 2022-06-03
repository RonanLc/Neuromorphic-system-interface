
import time
import pandas as pd

class AD:

    def stimulate(self, address, Time):
        Time = int(Time) / 1000
        address = bin(int(address))
        for state in range(2):
            time.sleep(Time)
            print(Time)
            print(address, state)
            # send to neuro ship

    def syncro(self, address1, address2, address3, check1, check2, check3, Time):
        Time = int(Time)/1000
        address1 = bin(int(address1))
        address2 = bin(int(address2))
        address3 = bin(int(address3))
        for state in range(2):
            print(Time)
            time.sleep(Time)
            if check1:
                print(address1, state)
                #send to neuro ship
            if check2:
                print(address2, state)
                #send to neuro ship
            if check3:
                print(address3, state)
                #send to neuro ship



    def initLaunch(self, file, Time):

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
            print(actualData)

