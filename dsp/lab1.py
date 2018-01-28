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
					[0, 1, 2, 3, 4, 5, 6, 7, 8, 0], 
					[0, .1, .2, .3, 2, 1, 0, .1, .2, .3]
				], 
				dtype = np.float32
		)

print(ex4.argmax())

print(ex4[ex4.argmax()])

print('\n then we set it to zero, and plot.');

plt.plot(ex4[0, :], ex4[1, :], 'r-x')
#plt.show()