import numpy as np 
import librosa as lsa
import matplotlib.pyplot as plt
import sounddevice as sd
from scipy import signal

# Sound class
# This is the same code I've used in past labs but overriding + operator.

class Sound:

	SR = 44100

	def __init__(self, duration, freq, amplitude = 0.5):
		self.duration  = duration
		self.freq      = freq
		self.amplitude = amplitude
		self.time = np.arange( 0, duration, 1 / self.SR )
		self.wave = self.amplitude * np.cos( 2 * np.pi * freq * self.time )

	def play(self):
		sd.play( self.wave, blocking = True )
		return self

	def save (self, name):
		lsa.output.write_wav( name, self.wave, self.SR, True )
		return self

	def plot(self, title = '', init = 0, end = 0):
		plt.figure()
		# Use the number of samples given
		if end == 0:
			x = self.time
			y = self.wave
		# full signal otherwise
		else:
			x = self.time[init:end]
			y = self.wave[init:end]

		plt.plot( x , y)
		plt.xlabel('time(s)')
		plt.title(title)
		plt.show()
		return self

	# Overriding +: it creates a new sound summing up the frequencies
	def __add__(self, other):
		new_duration = max( self.duration, other.duration )
		new_freq     = self.freq + other.freq
		return Sound( new_duration, new_freq )

	def concat(self, other):
		self.duration = self.duration + other.duration;
		self.time = np.array(np.arange( 0, self.duration, 1 / self.SR ))
		self.wave = np.append(self.wave, other.wave)
		return self


# Exercise1. 
#
# Creates the signals, sum them up and then save them to local system

def exercise1():
	f1 = Sound(1, 196)
	f2 = Sound(1, 392) 
	f3 = Sound(1, 558) 
	f4 = Sound(1, 784)

	fA = f1 + f2 + f3 + f4
	fB =      f2 + f3 + f4

	fA.save('FA.wav')
	fB.save('FB.wav') 

def exercise2():
	# Create a tone with frequency 800Hz and amplitude 0.05
	f1 = Sound(2, 800, 0.05)
	# Create a tone with frequency 880Hz and amplitde 1
	f2 = Sound(2, 880)

	# Make a .wav output for both signals with duration 2 seconds.
	f1.save('Exercise2.F1.wav')
	f2.save('Exercise2.F2.wav')

	# Combine the signals (sum them) and create a combined .wav ...
	s = f1 + f2
	# ... and create a combined .wav.
	s.save('combined.wav')
	# ... plot the spectrum
	s.plot(end = 1000)
	# Concatenate the file 
	c = f1.concat(f2)
	# and save it to a .wav file
	c.save('concatenated.wav')


def reverse(chunk_length = 0.03):
	y , sr = lsa.load('example.wav')

	chunk_samples = int(sr * chunk_length)
	total_chunks  = np.floor(len(y) / chunk_samples).astype(int)

	yRevChunk = np.zeros(y.shape)

	for i in range(0, total_chunks):
		startidx = i * chunk_samples
		stopidx  = (i + 1) * chunk_samples
		yRevChunk[startidx:stopidx:] = y[startidx : stopidx:][::-1]

	lsa.output.write_wav('reversed_' + str(chunk_length) + '.wav', yRevChunk, sr)

def flipAmplitude(chunk_length = 0.03):
	y , sr = lsa.load('example.wav')

	chunk_samples = int(sr * chunk_length)
	total_chunks  = np.floor(len(y) / chunk_samples).astype(int)

	yRevChunk = np.zeros(y.shape)

	for i in range(0, total_chunks):
		startidx = i * chunk_samples
		stopidx  = (i + 1) * chunk_samples
		yRevChunk[startidx:stopidx:] = -1*y[startidx : stopidx:]

	lsa.output.write_wav('flipped_amplitude_' + str(chunk_length) + '.wav', yRevChunk, sr)


def exercise3():
	# Reverse 30ms chunks.
	reverse()
	# Reverse 120ms chunks
	reverse(0.120)
	# Reverse 240ms chunks
	reverse(0.240)
	# Flip amplitude
	flipAmplitude()


def main():
	exercise1()
	exercise2()
	exercise3()

if __name__ == '__main__':
	main()