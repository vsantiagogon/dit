import tensorflow as tf
import tflearn
import numpy as np
import pandas as pd
import math

learning_rate = 0.00001
epochs        = 300
width         = 20 # Mel's features
height        = 80
classes       = 10 # digits

data  = pd.read_pickle('data/data.pkl');
data  = data.sample(frac = 1)

train = data[0: math.floor(0.8*len(data))]
test  = data[(math.floor(0.8*len(data)) + 1 ): len(data)]

X, Y  = train['features'].tolist(), train['target'].tolist()
val   = (test['features'].tolist(), test['target'].tolist())

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

model.fit( X, Y, n_epoch = epochs, validation_set = val, show_metric=True)

model.save('models/model.tflearn');

