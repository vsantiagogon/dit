import tensorflow as tf
import tflearn
import numpy as np
#from sklearn.metrics import confusion_matrix

from encode import encoding

sample        = encoding(2403)
learning_rate = 0.00001
epochs        = 400
width         = 20 # Mel's features
height        = 80
classes       = 10 # digits

X, Y = next(sample);

trainX, trainY = X, Y
testX,  testY   = X, Y #overfit for now

tflearn.init_graph(num_cores=8)

net = tflearn.input_data(shape=[None, width, height])
net = tflearn.lstm(net, 128, dropout = 0.8);
net = tflearn.fully_connected(net, 64)
net = tflearn.dropout(net, 0.5)
net = tflearn.fully_connected(net, 164)
net = tflearn.dropout(net, 0.5)
net = tflearn.fully_connected(net, classes, activation='softmax')
net = tflearn.regression(net, optimizer='adam', loss='categorical_crossentropy')

# net = tflearn.input_data([None, width, height]);
# net = tflearn.lstm(net, 128, dropout = 0.8);
# net = tflearn.fully_connected(net, classes, activation='tanh')
# net = tflearn.regression(net, optimizer='adam', learning_rate=learning_rate, loss='categorical_crossentropy')

model = tflearn.DNN(net, tensorboard_verbose=0);

model.fit(trainX, trainY, n_epoch = epochs, validation_set = (testX, testY), show_metric=True)

#predictions = model.predict(testX)

# for i in range(0, len(predictions)):
# 	print('Predicted: ' + str(np.argmax(predictions[i])) + ' Real: ' + str(np.argmax(testY[i])))
