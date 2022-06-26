# -*- coding: utf-8 -*-
"""
Created on Wed Jun 16 19:31:32 2021

@author: ACER
"""

import numpy as np
import csv
import matplotlib.pyplot as plt
from tqdm import tqdm
import pandas as pd
import time
from timeit import default_timer as timer

import serial
# serialPort = serial.Serial(port = "COM4", baudrate=1000000,
#                            bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)

if __name__ == '__main__':
    #os.chdir(r'/home/gautam/Documents/MLKVTh_20210601/Chip_Results/Point_Neuron_256')##Location of the csv file.

    file_name="ihg_matlab_1000_onefourth_225sec_rand_001.csv" #name of the csv file
    #file_name="pp_50sec_60Hz_"+name[n_run]+".csv"
    file_name_time="ihg_matlab_128_onefourth_225sec_time_rand_000.csv"
    #image_name="pp_50sec_60Hz_"+name[n_run]
    image_name="ihg_matlab_128_onefourth_225sec_time_rand_0"
    T=225                   #Total run duration seconds
    #T_pat=0.01
    #num_runs=int(T/T_pat)
    #epoch_time=5            #Duration of one epoch
    #dt=1e-5                  #Time step
    #nt=round(T/(dt))         
    #epoch_nt=round(epoch_time/(dt))
    #T_pat_nt=round(T_pat/(dt))
    #N=1                     #Number of Neurons
    n_in=256                #Number of Inputs
    #n_syn_group=4           #Number of synapses in a single node
    #n_cap=16                #Number of cap nodes in a branch (n_cap*n_syn_group synapses)
    #n_branch=4              #Number of branches
    #stdp_state=True
    #init_exc_W=np.expand_dims(np.array([(1e-3)*(15/15)*7]), axis=0)*np.ones((n_in, N)) #[128,1] 
    #init_inhib_W=-0*np.ones((N-1, N))
    #flag_close=1
    #NIST={} #Neurons Index spike time, a dictionary which will have Neuron index as the key and spike times as the content of the dictionary (after the program runs).
    ST=[]
    NI=[]
    #ST_bit_long=[]
    wait_step=.01
    #for i in range(n_in):
    #    NIST[i]=[0]
    with open(file_name, mode='r') as infile:#c,g,i, j
        reader = csv.reader(infile)
        next(reader) #Skip the first row
#        for row in reader:
#            if (int(float(row[1]))<n_in):
#                NIST[int(float(row[1]))].append(float(row[0]))
        
        for row in reader:
            if (int(float(row[1]))<n_in and float(row[0])<T):
                ST.append(float(row[0]))
                NI.append(int(float(row[1])))
                
    ST= [int(round(x*1e5)) for x in ST]
    ST_diff=np.diff(ST)
    #ST_diff_byte=[x.to_bytes(1,'big') for x in ST_diff]
    NI_byte=[x.to_bytes(1,'big') for x in NI]
    ####Write sorter state to pattern incoming############
    print("#############################")
    # serialPort.write(b'\x40')
    # for i in tqdm(range(len(NI))):
    #     serialPort.write(ST_byte[i])
    #     #time.sleep(wait_step)
    #     serialPort.write(NI_byte[i])
    #     #time.sleep(wait_step)
    # #ST_bit=[bin(x) for x in ST]
    #ST_byte=[bytes(x) for x in ST]
    #c="0"
#    for i,j in enumerate(ST_bit):
#        a=len(j)-2
#        b=31-a
#        for k in range(b):
#            c=c+"0"
#        ST_bit_long.append(j[0:2]+c+j[2:])
#        c="0"
#    print("#####################################")
#          
#    print(b'\x40')
#    for i in range(len(NI[0:6])):
#        print("0b"+ST_bit_long[i][-8:])
#        time.sleep(wait_step)
#        print("0b"+ST_bit_long[i][-16:-8])
#        time.sleep(wait_step)
#        print("0b"+ST_bit_long[i][-24:-16])
#        time.sleep(wait_step)
#        print("0b"+ST_bit_long[i][-32:-24])
#        time.sleep(wait_step)
#        print(bin(NI[i]))
#        #print(NI[i])
#        time.sleep(wait_step)
        
                
    #####################INPUT SPIKES GENERATED################################
#    for i in range(n_in):
#        NIST[i].pop(0)
    
    #ST_diff=np.diff(ST)
#    start=timer()
#    print(start)
#    for i,j in enumerate(ST_diff):
#        time.sleep(j)
#        #print(NI[i])
#    end=timer()
#    print(start, end, end-start)  
#    time.sleep(5)
    # a=[0x00,0x10,0x00,0x10,0x4B]
    # b=bytes(a)
    # serialPort.write(b)
    # a=[0x00,0x00,0x10,0x50,0x4B]
    # b=bytes(a)
    # serialPort.write(b)
    # a=[0x00,0x00,0x10,0x80,0x4B]
    # b=bytes(a)
    # serialPort.write(b)
    # a=[0x00,0x00,0x10,0xF0,0x4B]
    # b=bytes(a)
    # serialPort.write(b)
    