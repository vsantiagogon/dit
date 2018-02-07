import numpy as np 
import librosa as lsa
import matplotlib.pyplot as plt
import sounddevice as sd

# Defines utility functions for Sounds: plot, save & play
class Sound: 
	SR = 44100

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
