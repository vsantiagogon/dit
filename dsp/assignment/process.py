import os
import sys
import numpy as np
import pandas as pd
import librosa as lsa
from clint.textui import progress

RAW_FILES = 'data/raw/'

def batch (source = RAW_FILES, out = 'data/data.pkl'):

  files = os.listdir(source)

  rows = []

  for i in progress.bar(range(0, len(files))):

    if not files[i].endswith('.wav'): continue;

    wave, sr    = lsa.load(source + files[i], mono=True)
    wave, index = lsa.effects.trim(wave)

    # Create a label:
    #   0 -> [1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    #   1 -> [0, 1, 0, 0, 0, 0, 0, 0, 0, 0]
    #   2 -> [0, 0, 1, 0, 0, 0, 0, 0, 0, 0]
    # .....................................

    label = np.eye(10)[int(files[i][0])]

    mfcc = lsa.feature.mfcc(wave, sr) # Mel's frequency cepstral coefficients

    # Fill the previous array with zeros.
    mfcc = np.pad(
                mfcc,
                ((0,0),(0,80-len(mfcc[0]))), 
                mode='constant', 
                constant_values=0
            )
    rows.append({'features': np.array(mfcc), 'target': label})

  output = pd.DataFrame(rows)
  output.to_pickle(out)


if __name__ == "__main__":
   batch('data/recordings/', 'data/pruebas.pkl');