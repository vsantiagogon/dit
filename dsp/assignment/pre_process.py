import os
import sys
import numpy as np
import pandas as pd
import librosa
from random import shuffle

RAW_FILES = 'data/raw/'

def progresshook(completed, total):
      sys.stdout.write("\r%d%% encoded so far" % (completed * 100 / total))
      sys.stdout.flush()

def main(): 
  files = os.listdir(RAW_FILES)

  rows = []

  print('-----------------')
  print(' START ENCODING')
  print('-----------------')

  for i in range(0, len(files)):

    if not files[i].endswith('.wav'): continue;

    wave, sr = librosa.load(RAW_FILES + files[i], mono=True)

    # Create a label:
    #   0 -> [1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    #   1 -> [0, 1, 0, 0, 0, 0, 0, 0, 0, 0]
    #   2 -> [0, 0, 1, 0, 0, 0, 0, 0, 0, 0]
    # .....................................

    label = np.eye(10)[int(files[i][0])]

    mfcc = librosa.feature.mfcc(wave, sr) # Mel's frequency cepstral coefficients

    # Fill the previous array with zeros.
    mfcc = np.pad(
                mfcc,
                ((0,0),(0,80-len(mfcc[0]))), 
                mode='constant', 
                constant_values=0
            )
    rows.append({'features': np.array(mfcc), 'target': label})

    progresshook(i + 1, len(files));
  
  print('\n-----------------')
  print('ALL FILES ENCODED')
  print('-----------------')

  output = pd.DataFrame(rows)

  output.to_pickle('data/data.pkl')

if __name__ == "__main__":
  main();