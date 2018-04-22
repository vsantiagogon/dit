import tensorflow as tf 
import tflearn
import numpy as np 
import pandas as pd
import math

from sklearn.metrics import confusion_matrix

width         = 20 # Mel's features
height        = 80
classes       = 10 # digits

data = pd.read_pickle('data/data.pkl');
data = data.sample(frac = 1)

test = data[(math.floor(0.8*len(data)) + 1 ): len(data)];

tflearn.init_graph(num_cores=8)

net   = tflearn.input_data(shape=[None, width, height])
net   = tflearn.lstm(net, 128, dropout = 0.8);
net   = tflearn.fully_connected(net, 64)
net   = tflearn.dropout(net, 0.5)
net   = tflearn.fully_connected(net, 164)
net   = tflearn.dropout(net, 0.5)
net   = tflearn.fully_connected(net, classes, activation='softmax')
net   = tflearn.regression(net, optimizer='adam', loss='categorical_crossentropy')

model = tflearn.DNN( net, tensorboard_verbose = 3);

model.load('./models/model.tflearn');

results = model.predict(test['features'].tolist());

predicted = [np.argmax(i) for i in results]
actual    = [np.argmax(i) for i in test['target'].tolist()]

y_actu = pd.Series(actual, name='Actual')
y_pred = pd.Series(predicted, name='Predicted')

df_confusion = pd.crosstab(y_actu, y_pred, margins = True)

print(df_confusion)