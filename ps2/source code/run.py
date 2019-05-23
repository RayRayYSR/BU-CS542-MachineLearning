import math
from sys import argv
import pandas as pd
#command run, parameters
script, KNN, Tr, Te = argv
#Use panda to read
TrD = pd.read_csv(Tr, header=None)
TeD = pd.read_csv(Te, header=None)
LAB = []
R1, C1 = TrD.shape
R2, C2 = TeD.shape
nei = []

#find real label to its testing data
def label(list1, TrD):                                    
    for i in range(len(list1)):  
        label = TrD.iloc[list1[i]][ C1-1 ]     
        LAB.append(label)
        #need the label with most times
    return max(set(LAB), key=LAB.count)                

#distance is calculated below
def dist(m,n):
    res = 0
    list = []
    for i in range(R1):
        for j in range(C1 - 1 ):
            if(isinstance(m.iloc[i][j], str ) == True): 
                if(m.iloc[i][j] != n[j]):
                    res = res + 1
                else:
                    res = res
            else:
                #DL2(m,n) = sqrt(res(m , n)^2))
                diff = math.pow((m.iloc[i][j] - n[j]), 2) 
                res = res + diff
        list.append(math.sqrt(res))
        res = 0
    return list 

TeD[C2] = TeD[C2-1]
a = 0
#run through the data
for index,row in TeD.iterrows():                 
    dis = dist(TrD,row)    
    ordered = sorted(range(len(dis)), key=lambda k: dis[k])
    for i in range(int(KNN)):          
        nei.append(ordered[i])
    res = label(nei, TrD)   
    TeD.loc[a, C2] = res
    a = a + 1

#use panda to output
TeD.to_csv(Te, header=False, index=False)     
