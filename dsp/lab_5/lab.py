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

	def plot(self, title = '', samples = 0):
		plt.figure()
		# Use the number of samples given
		if samples == 0:
			x = self.time
			y = self.wave
		# full signal otherwise
		else:
			x = self.time[0:samples]
			y = self.time[0:samples]

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

def main():
	exercise1()

if __name__ == '__main__':
	main()