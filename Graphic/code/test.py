
import pandas as pd

pd.options.display.max_rows = 9999

Time = 1

dataFile = pd.read_csv(r'D:\etude\Stage\Work\Neuromorphic-system-interface\Data\test_input.csv', header=None)
dataSize = len(dataFile)
state = [0]

for i in range(1, dataSize):

    state.append(0)
    state.append(1)

    dfFile = pd.DataFrame({0: [dataFile[0][i]+(int(Time)/1000)],
                           1: [dataFile[1][i]]})

    dataFile = dataFile.append(dfFile, ignore_index = True)

state = pd.DataFrame(state)
state = state.sort_values(by=[0], na_position='first', ignore_index = True)

dataFile[2] = state

dataFile = dataFile.sort_values(by=[0], na_position='first', ignore_index = True)

print(dataFile)

#for i in range(len(dataFile)):
#        yield dataFile[0][i], dataFile[1][i], dataFile[2][i]



