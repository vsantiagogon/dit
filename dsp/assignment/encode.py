import os
import numpy as np
import librosa
from random import shuffle

def encoding(size = 10, path = 'data/raw/'):
  
  features = []
  labels = []
  files = os.listdir(path)

  while True:
    
    print("Encoding %d files" % len(files))
    #shuffle(files)
    
    for file_name in files:
      if not file_name.endswith(".wav"): continue
      
      wave, sr = librosa.load(path + file_name, mono=True)

      # Create a label:
      #   0 -> [1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      #   1 -> [0, 1, 0, 0, 0, 0, 0, 0, 0, 0]
      #   2 -> [0, 0, 1, 0, 0, 0, 0, 0, 0, 0]
      # .....................................

      labels.append(np.eye(10)[int(file_name[0])])

      # Extract Mel-frequency cepstral coefficients
      mfcc = librosa.feature.mfcc(wave, sr)
      
      # Fill the previous array with zeros.
      mfcc = np.pad(
                  mfcc,
                  ((0,0),(0,80-len(mfcc[0]))), 
                  mode='constant', 
                  constant_values=0
              )
      
      features.append(np.array(mfcc))
      
      if len(features) >= size:
        yield features, labels  # basic_rnn_seq2seq inputs must be a sequence
        features = []
        labels = []
