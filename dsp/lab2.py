import numpy as np 
import librosa as lsa
import matplotlib.pyplot as plt
import sounddevice as sd
from scipy import signal

# Defines utility functions for Sounds: plot, save & play
class Sound: 
	SR = 44100

	def __init__(self, duration, wave):
		self.time = np.arange(0, duration, 1 /self.SR)
		self.wave = wave

	def play(self):
		sd.play(self.wave, blocking = True)

	def play (self):
		sd.play(self.wave, blocking = True)

	def save (self, name):
		lsa.output.write_wav(name, self.wave, self.SR, True)

	def plot(self, title = ''):
		plt.figure()
		plt.plot(self.time, self.wave)
		plt.xlabel('time(s)')
		plt.title(title)
		plt.show(block=False)
	
	def filter(self, order = 6, cutoff = 1000):
		cutoff = cutoff / (0.5 * self.SR)
		a, b = signal.butter(order, cutoff)
		y = signal.filtfilt(b, a, self.wave)
		plt.figure()
		plt.plot(self.time, self.wave, alpha=0.75)
		plt.plot(self.time, y, color='grey')
		plt.show(block=False)

# Create a Sound from WAV file
def load(name):
	wave, SR = lsa.core.load(name, sr = 44100)
	duration = lsa.core.get_duration(y = wave, sr = SR)
	return Sound(duration, wave)

# Tones are defined as x(t) = 0.5 cos(2*pi*freq*t)
class Signal(Sound): 

	def __init__(self, time, freq):
		self.time = np.arange(0, time, 1 / self.SR)
		self.wave = 0.5 * np.cos(2 * np.pi * freq * self.time)

# DTMF tones are sums of signals. But cos(A + B) = 2 cos(A + B)cos(A-B) so, now
# 	x(t) := cos(pi * t * (f1 + f2)) * cos(pi * t * (f1 - f2))
class Beep(Sound):

	def __init__(self, time, freq1, freq2):
		self.time = np.arange(0, time, 1 /self.SR )
		self.wave = np.cos(np.pi * self.time * (freq1 + freq2)) * np.cos(np.pi * self.time * (freq1 - freq2))
