import numpy as np 
import librosa as lsa
import sounddevice as sd 


class Beep:

	SR = 44100

	def __init__(self, time, freq1, freq2):
		t = np.arange(0, time, 1 /self.SR )
		self.wave = np.cos(np.pi * t * (freq1 + freq2)) * np.cos(np.pi * t * (freq1 - freq2))

	def play (self):
		sd.play(self.wave, blocking = True)

	def save (self, name):
		print(len(self.wave))
		lsa.output.write_wav(name, self.wave, self.SR, True)
