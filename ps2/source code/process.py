#Use Panda to process data
from sys import argv
import pandas as pd
import numpy as np
#command run
script, a, b = argv
#function below
def process(data):
	data = data.replace('?', np.NaN)
	r = [0,3,4,5,6]
   #missing features
	column = [1,2,7,10,13,14]
	for i in r:
       #replace by mode
		data[i] = data[i].fillna(data[i].mode()[0])			
	r = [1,13]	
   #plus, minus label				
	lab = ['+', '-']
	for m in r:
		data[m] = data[m].apply(float)		
		for n in lab:
          #get real-value missing ones
			data.loc[ (data[m].isnull()) & ( data[15]==n ), m ] = data[m][data[15] == n].mean()  
	for c in column:
		data[c] = (data[c] - data[c].mean())/data[c].std()
	return data

#Use panda to process TrD which stands for training Data and TeD which stands for testing data
TrD = pd.read_csv(a, header=None)	
#process the data	
TrD = process(TrD)
TrD.to_csv('crx.training.processed', header=False, index=False) 
#Same Usage as above
TeD= pd.read_csv(b, header=None)	
TeD = process(TeD)							
TeD.to_csv('crx.testing.processed', header=False, index=False)		
