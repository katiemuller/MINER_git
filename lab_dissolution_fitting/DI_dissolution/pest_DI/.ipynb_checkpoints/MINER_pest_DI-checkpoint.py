# PFLOTRAN Fitting Routine with PEST
# MINER- Lab Dissolution Experiments with DI
# Katie Muller
# 06/06/24

# Import
import pandas as pd
from pathlib import Path
import numpy as np
import subprocess
import os
import matplotlib.pyplot as plt
import math as math

dir_code = '~/projects/MINER/src'
import sys
sys.path.append(dir_code)

##### Functions to read PFLOTRAN pft and tec files ######
def read_pflotran_output(fname):
    '''Function for reading the pflotran output'''
    header = pd.read_csv(fname, nrows=0)
    data   = pd.read_csv(fname, sep='\s+', skiprows=1, names=list(header))
    data.index = data.iloc[:,0]
    return data
######################
def tec_to_dataframe(file_path, no_skiprow, column_headers):
    '''function to convert a tec PFLTORAN outfile to a dataframe'''
    df = pd.read_csv(file_path, skiprows=no_skiprow, delim_whitespace=True, header=None, names=column_headers)
    return df
#####################

### 1.0 Import Experimental Data
dir_data = Path('./')
f_obs_diss = os.path.join(dir_data, 'Diss_DI_data.xlsx')

diss_obs = pd.read_excel(f_obs_diss)
time_obs = diss_obs['Time [hr]']

####### Path to folder locations
dir_model = Path('./')

### 2.0 Post-Process PFLOTRAN outputs to match experimental data format
# Simulation Results
f_out = './pflotran-obs-0.pft'
pf_out = read_pflotran_output(f_out)

# diss data obsevations:
observations = []
observations.append(diss_obs['Avg_Ni [M]'].tolist())
observations.append(diss_obs['Avg_Fe [M]'].tolist())
observations.append(diss_obs['Avg_Mn [M]'].tolist())
observations.append(diss_obs['Avg_Mg [M]'].tolist())
#observations.append(diss_obs['Avg_Ca [M]'].tolist())
observations = np.concatenate(observations)
# Log formulation
observations = np.log10(observations)

# List Aqueous Species for Comparision
#aq_species = ['Ni', 'Fe', 'Mn', 'Mg', 'Ca']
aq_species = ['Ni', 'Fe', 'Mn', 'Mg']

# List of Minerals in Simulation (needs to be all inculsive list for aqueous chemistry calculation to be correct) 
minerals = ['Forsterite', 'Fayalite', 'Ni2SiO4', 'Tephroite', 'Wollastonite','Enstatite', 'Chrysotile', 'Fe(OH)2','Fe(OH)3','FeO']             
             
sim_col_names = pf_out.keys()

## 4.1 Computing weights
weights = []
wt = np.ones(len(observations))
wt = wt * 100
weights.append(wt.tolist())
weights = np.concatenate(weights)

## PFLOTRAN Model Output
model_output = []

#model_output_headers = ["Total Ni++ [M] pt (1) (0.028 0.028 0.028)","Total Fe++ [M] pt (1) (0.028 0.028 0.028)","Total Mn++ [M] pt (1) (0.028 0.028 0.028)","Total Mg++ [M] pt (1) (0.028 0.028 0.028)","Total Ca++ [M] pt (1) (0.028 0.028 0.028)"]
model_output_headers = ["Total Ni++ [M] pt (1) (0.028 0.028 0.028)","Total Fe++ [M] pt (1) (0.028 0.028 0.028)","Total Mn++ [M] pt (1) (0.028 0.028 0.028)","Total Mg++ [M] pt (1) (0.028 0.028 0.028)"]

for name in model_output_headers:
    model_output.append(np.interp(diss_obs['Time [hr]'],pf_out[' "Time [hr]"'],pf_out['{}'.format(name)]).tolist())
model_output = np.concatenate(model_output)
# Log formulation
model_output = np.log10(model_output)

### 5.0 Write PEST Files ##############################
    ## 5.1 Processed Observation Data File (txt) #################
with open("processed_observations.txt","w") as txt_file:
    for concentration in observations:
        txt_file.write('%.20f' % concentration + '\n')
    
    ## 5.2 trial.ins (txt) #####################
i=0
with open("trial.ins","w") as txt_file:
    txt_file.write('pif @' + '\n')
    for concentration in observations:
        i += 1
        txt_file.write('l1 [obs'+str(i) + ']1:22' + '\n')
    
    
    ## 5.3 trial.pst (txt) ################
with open("trial.pst","w") as txt_file:
    block = """pcf
* control data
norestart  estimation
# Number of parameters, number of observations, number of parameter groups, number of prior information, number of observation groups
    7     """ + str(i) + """     1     0     1
# Number of pairs of input template files, number of model output reading instruction files, 
    1     1 single point   1   0   0
  5.0   2.0   0.3  0.03    10
  3.0   3.0 0.001  0
  0.1
   30  0.01     3     3  0.01     3
    1     1     1
* parameter groups
dgr         relative 0.01  0.0  switch  2.0 parabolic
* parameter data
forsterite_rate_constant         none  relative    5.41e-9      1e-10   2 dgr            1e-9       0.0000      1
fayalite_rate_constant           none  relative    1.58e-13     1e-14   2 dgr            1e-11       0.0000      1
Ni2SiO4_rate_constant            none  relative    1.9E-11      1e-12   2 dgr            1e-10       0.0000      1
tephroite_rate_constant          none  relative    1.5e-11       1e-14   2 dgr            1e-12       0.0000      1
wollastonite_rate_constant       none  relative    5.27e-11     1e-12    2 dgr           1e-10       0.0000      1        
enstatite_rate_constant          none  relative    9.55e-14     1e-15   2 dgr            1e-9       0.0000      1 
chrysotile_rate_constant         none  relative    1.5e-16      1e-17   2 dgr            1e-10       0.0000      1        
* observation groups
obsgroup
* observation data
# Obs Name  Observation        Weight    Group
"""
    i = 0
    txt_file.write(block)
    for concentration in observations:
        i += 1
        txt_file.write('obs'+str(i) + '   %.20f' % concentration + '    '+ str(weights[i-1]) +'    obsgroup' + '\n')
    block = """* model command line
./trial.sh
* model input/output
pflotran.tpl  pflotran.in
trial.ins output_processed.txt
* prior information"""
    txt_file.write(block)    
    ## 5.4 processed output (txt)

with open("output_processed.txt", "w") as txt_file:
    for model_sim in model_output:
        txt_file.write('   %.20f' % model_sim + '\n')