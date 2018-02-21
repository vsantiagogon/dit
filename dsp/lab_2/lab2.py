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

	def plot(self, title = '', samples=0):
		plt.figure()
		# Use the number of samples given
		if samples == 0:
			x = self.time
			y = self.wave
		# full signal otherwise
		else:
			x = self.time[0:samples]
			y = self.time[0:samples]

		plt.plot(x, y)
		plt.xlabel('time(s)')
		plt.title(title)
		plt.show()
		return self
	
	def filter(self, order = 6, cutoff = 1000):
		cutoff = cutoff / (0.5 * self.SR) # Nyquist frequency
		a, b = signal.butter(order, cutoff)
		self.wave = signal.filtfilt(a, b, self.wave)
		return self

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

# DTMF tones are sums of signals. But cos(A + B) = 2 cos(A + B)cos(A-B) so, now
# 	x(t) := cos(pi * t * (f1 + f2)) * cos(pi * t * (f1 - f2))

# Inherits Sound

class Beep(Sound):

	def __init__(self, time, freq1, freq2):
		self.time = np.arange(0, time, 1 /self.SR )
		self.wave = np.cos(np.pi * self.time * (freq1 + freq2)) \
			* np.cos(np.pi * self.time * (freq1 - freq2))

# Create a Sound from WAV file
def load(name):
	wave, SR = lsa.core.load(name, sr = 44100)
	duration = lsa.core.get_duration(y = wave, sr = SR)
	return Sound(duration, wave)

# Creates Beeps on demand
def dial(key):
	# DTMF's codes
	DTMF = {
		'1' : [697, 1209],
		'2' : [697, 1336],
		'3' : [697, 1477],
		'A' : [697, 1633],

		'4' : [770, 1209],
		'5' : [770, 1336],
		'6' : [770, 1477],
		'B' : [770, 1633],
		
		'7' : [852, 1209],
		'8' : [852, 1336],
		'9' : [852, 1477],
		'C' : [852, 1633],
		
		'*' : [941, 1209],
		'0' : [941, 1336],
		'#' : [941, 1477],
		'D' : [941, 1633]
	}

	if key in DTMF:
		x = Beep(0.2, DTMF[key][0], DTMF[key][0])
		x.save(key + '.wav')
	else:
		print('ERROR: key doesn\'t map any DTMF symbol!')

################################################################################
# LAB'S FLOW
################################################################################

def main():

	# Create a 770Hz signal, 0.02 and 0.5 seconds long

	sig770_long  = Signal(0.5, 770)
	sig770_short = Signal(0.02, 770)

	# Create a second signal, 1209Hz and 0.02 and 0.5 seconds long

	beep = Beep(0.02, 770, 1209)

	# Plots... 
	sig770_short.plot('770 Hz, 0.02 seconds')
	sig770_long.plot('770 Hz, 0.02 seconds')
	beep.plot('1209Hz + 770Hz, 0.02 seconds')

	print('''
		Mono-tone signals show perfect sinusoid grahps, while 1209+770 draws 
		a more complicated plot.
		''')

	print('''
		The longer the time span, the more compressed the graph is. For a 0.5s
		long signal they look like a solid square.
		''')

	# Testing "dial" function:
	dial('A')

	# Creating a '3' beep
	three = Beep(0.02, 697, 1477)
	# then filter and plot at 50 samples, 200 samples and full length
	three.filter().plot(title='Filtered, 50 samples', samples=50) \
		.plot(title='Filtered, 200 samples', samples=200) \
		.plot(title='Filtered, FULL signal')

	print('\n Amplitude decreases until the point in which the sound is inaudible')


if __name__ == '__main__':
	main()