import matplotlib.pyplot as plt 
import numpy as np 

# Exercise 1 : create an array

print ('\n#### Exercise 1: create an array\n')

ex1 = np.array([1, 0, -1], dtype = np.float32)
print(ex1)

# Exercise 2 : print sin of the former array.

print('\n#### Exercise2: Sin of an array\n')
print(np.sin(ex1))

# Exercise 3: Create matrix of floating points. 

print('\n#### Exercise 3: creating a matrix\n')
m1 = [ [0, 1, 2, 3, 2, 1, 0, -1, -2, -3], [0, 1, 2, 3, 2, 1, 0, -1, -2, -3] ]
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

freq = 2
fs = 100

x = np.arange(-1, 1 + 1/fs, 1/fs)
A = np.sin(2*freq*x) 
plt.plot(x, A)
plt.show()

print('Size of x:', x.size)
print('Why 201? Because arange starts counting on 0?')

