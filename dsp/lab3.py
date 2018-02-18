import numpy as np 
import librosa as lsa
import librosa.display as lsd
import matplotlib.pyplot as plt
import sounddevice as sd
from scipy import signal
from scipy.fftpack import fft, ifft
from scipy import signal

################################################################################
# Objects definitions: we re-use Lab's 2 clasess.
################################################################################

# Defines utility functions for Sounds: plot, save & play
class Sound: 

	SR = 44100

	def __init__(self, duration, wave):
		self.time = np.arange(0, duration, 1 /self.SR)
		self.wave = wave

	def setSR (self, SR):
		self.SR = SR

	def play(self):
		sd.play(self.wave, blocking = True)

	def play (self):
		sd.play(self.wave, blocking = True)

	def save (self, name):
		lsa.output.write_wav(name, self.wave, self.SR, True)

	def plot(self, title = '', samples = 0):
		plt.figure()
		# Use the number of samples given
		if samples == 0:
			samples = self.SR
		plt.plot(self.wave)
		plt.xlabel('samples')
		plt.xlim(0, samples)
		plt.title(title)
		plt.show()
		return self
	
	def filter(self, order = 6, cutoff = 1000):
		cutoff = cutoff / (0.5 * self.SR) # Nyquist frequency
		a, b = signal.butter(order, cutoff)
		self.wave = signal.filtfilt(a, b, self.wave)
		return self

	def window(self, samples):
		return self.wave[0:samples] * np.hamming(samples);

	def specshow(self):
		D = lsa.amplitude_to_db(lsa.stft(self.wave), ref=np.max)
		lsd.specshow(D, y_axis='linear')
		plt.show();


def Fourier (signal, samples, title = ''):
	plt.figure()
	plt.plot(fft(signal.wave)[0:samples]);
	plt.title(title);
	plt.show();

# Create a Sound from WAV file
def load(name):
	wave, SR = lsa.core.load(name, sr = 44100)
	duration = lsa.core.get_duration(y = wave, sr = SR)
	return Sound(duration, wave)

# Tones are defined as x(t) = 0.5 cos(2*pi*freq*t). Inherits Sound
class Signal(Sound): 

	def __init__(self, time, freq):
		self.time = np.arange(0, time, 1 / self.SR)
		self.wave = 0.5 * np.cos(2 * np.pi * freq * self.time)

# Periodic impulses: squared waves.
class Impulse(Sound):

	def __init__(self, time, period):
		self.time = np.arange(0, time, 1/self.SR)
		self.wave = signal.square(2 * np.pi * (self.SR / period) * self.time)

################################################################################
# LAB'S FLOW
################################################################################

def main(): 

	print('''
	################################################################
	QUESTION 1: FFT of a signal.
	################################################################
	''')

	# Create a signal of 1s and 10000 frequency.
	s = Signal(1, 10000)
	# Plot FFT
	Fourier(s, 1024, title = 'FFT 1024 samples')
	Fourier(s, 512,  title = 'FFT 512 samples')
	Fourier(s, 256,  title = 'FFT 256 samples')

	print('''
	################################################################
	QUESTION 2: FFT and WINDOW for the sum.
	################################################################
	''')

	s1 = Signal(1, 10100);
	s3 = Sound(1, s.wave + s1.wave);

	sig = Sound(1, s3.window(44100))
	Fourier(sig, 44100, title="FFT after hamming with 44100 samples")

	sig = Sound(1, s3.window(1024))
	Fourier(sig, 1024, title="FFT after hamming with 1024 samples")

	sig = Sound(1, s3.window(526))
	Fourier(sig, 526, title="FFT after hamming with 526 samples")

	sig = Sound(1, s3.window(256))
	Fourier(sig, 256, title="FFT after hamming with 256 samples")

	print('''
	################################################################
	QUESTION 4: IMPULSE.
	################################################################
	''')

	s   = Impulse(1, 10)
	I10 = Sound(1, s.window(1024)).plot('', 1024)
	
	s   = Impulse(1, 50)
	I50 = Sound(1, s.window(1024)).plot('', 1024)

	s   = Impulse(1, 100)
	I100 = Sound(1, s.window(1024)).plot('', 1024)

	print('''
	################################################################
	QUESTION 5: STFT.
	################################################################
	''')





if __name__ == '__main__':
	main()