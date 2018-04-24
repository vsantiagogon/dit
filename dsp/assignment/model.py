import tensorflow as tf
import tflearn
import numpy as np
import pandas as pd
import math

class Speech():

	def __init__( self, epochs = 300 ):

		tf.reset_default_graph() # Avoid tflearn's "index out of range" bug (Issue 408)
		 
		self.epochs = epochs

		width         = 20 # Mel's features
		height        = 80
		classes       = 10 # digits

		net = tflearn.input_data(shape=[None, width, height])
		net = tflearn.fully_connected(net, 64)
		net = tflearn.dropout(net, 0.5)
		net = tflearn.fully_connected(net, classes, activation='softmax')
		net = tflearn.regression(net, optimizer='adam', loss='categorical_crossentropy')

		# tflearn.init_graph(num_cores = 4)

		# net   = tflearn.input_data(shape=[None, width, height])
		# net   = tflearn.lstm(net, 128, dropout = 0.8);
		# net   = tflearn.fully_connected(net, 64)
		# net   = tflearn.dropout(net, 0.5)
		# net   = tflearn.fully_connected(net, 164)
		# net   = tflearn.dropout(net, 0.5)
		# net   = tflearn.fully_connected(net, classes, activation='softmax')
		# net   = tflearn.regression(net, optimizer='adam', loss='categorical_crossentropy')

		self.model = tflearn.DNN( net, tensorboard_verbose = 3);


	def train(self, path = 'data/data.pkl'):

		data  = pd.read_pickle(path);
		data  = data.sample(frac = 1)

		train = data[0: math.floor(0.8*len(data))]
		test  = data[(math.floor(0.8*len(data)) + 1 ): len(data)]

		X, Y  = train['features'].tolist(), train['target'].tolist()
		val   = (test['features'].tolist(), test['target'].tolist())

		self.model.fit( X, Y, n_epoch = self.epochs, validation_set = val, show_metric=True)

	def save(self, path = 'models/model.tflearn'):

		self.model.save(path)

	def load(self, path = './models/model.tflearn'):

		self.model.load(path);

	def classify(self, data):

		return [np.argmax(i) for i in self.model.predict(data)]

