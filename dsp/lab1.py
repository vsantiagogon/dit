import matplotlib.pyplot as plt 
import numpy as np
import os

import urllib.request as URL
from wave import open as open_wave

# Exercise 1 : create an array

print ('\n#### Exercise 1: create an array\n')

ex1 = np.array([1, 0, -1], dtype = np.float32)
print(ex1)

# Exercise 2 : print sin of the former array.

print('\n#### Exercise2: Sin of an array\n')
print(np.sin(ex1))

# Exercise 3: Create matrix of floating points. 

print('\n#### Exercise 3: creating a matrix\n')
m1 = [ 
		[0, 1, 2, 3, 2, 1, 0, -1, -2, -3], 
		[0, 1, 2, 3, 2, 1, 0, -1, -2, -3] 
	]
ex3 = np.array(m1, dtype = np.float32);

print(ex3)  
print('We have created a %d x %d matrix.\n' % ex3.shape)

# Exercise 4: Matrix calculations. 

print('\n#### Exercise 4: calculate matrix elements.\n')

ex4 = np.array([
				[0 ,1 ,2 ,3 ,4 ,5 ,6 ,7 ,8 ,9] ,
				[0 ,.1 ,.2 ,.3 ,2 ,1 ,0 ,.1 ,.2 ,.3]
			], 
			dtype = np.float32
		)

print('\n The max value is %d', np.amax(ex4[1, :]) )
print('\n then we set it to zero, and plot.');

ex4[1, np.argmax(ex4[1, : ])] = 0

plt.plot(ex4[0, :], ex4[1, :], 'r-x')
plt.show()

# Exercise 5: Create array of 201 sin samples

print('\n#### Exercise 5: Create array with 201 sin samples.\n')

freq = 2
fs = 100

x = np.arange(-1, 1 + 1/fs, 1/fs)
A = np.sin(2*freq*x) 
plt.plot(x, A)
plt.show()

print('\n Size of x:', x.size)
print('\n Why 201? Because arange starts counting on 0?')

# Exercise 6: subset the previous chart and save it as PDF.

print('\n#### Exercise 6: subsetting the former array and plot.\n')

print('''
Notice that the plot will be saved on your local machine at your projec\'s 
root folder in a PDF file called lab1fig6-1.pdf
''')

ex6 = plt.figure()
plt.plot(x[x.size // 2+1 ::], A[A.size // 2 + 1 ::], 'o-r')
plt.show()
ex6.savefig('lab1fig6-1.pdf', bbox_inches='tight')

# Exercise 7: opening and displaying .wav file.

print('\n#### Exercise 7: plotting a .wav file.\n')

print('''
	\n This code will download the required file and it will delete it at the end
	\n I could\'t achieve the same goal using librosa. 
	\n That doesn\'t mean this library is not able to do it.
''')

file_path = './ex7.wav'

if not os.path.exists(file_path):
	URL.urlretrieve('https://tinyurl.com/196959apples', './ex7.wav')

fp = open_wave(file_path, 'r')

strframes = fp.readframes(fp.getnframes())
fp.close()
os.remove(file_path)

ys = np.fromstring(strframes, dtype = np.int16)
ts = np.arange(len(ys)) / fp.getframerate()

plt.plot(ts, ys, 'b-')
plt.xlabel('time(s)', fontsize=16)
plt.ylabel('amplitude', fontsize=16)
plt.show()