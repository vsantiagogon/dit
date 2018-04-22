import tensorflow as tf 
import tflearn
import numpy as np 
import pandas as pd
import math
import model as sp

width         = 20 # Mel's features
height        = 80
classes       = 10 # digits

data = pd.read_pickle('data/data.pkl');
data = data.sample(frac = 1)

test = data[(math.floor(0.8*len(data)) + 1 ): len(data)];

speech = sp.Speech();

speech.load('./models/model.tflearn');

predicted = speech.classify(test['features'].tolist());

actual    = [np.argmax(i) for i in test['target'].tolist()]

y_actu = pd.Series(actual, name='Actual')
y_pred = pd.Series(predicted, name='Predicted')

df_confusion = pd.crosstab(y_actu, y_pred, margins = True)

print(df_confusion);