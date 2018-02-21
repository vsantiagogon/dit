import matplotlib.pyplot as plt
import numpy as np

import peakutils.peakutils as peakutils # used to find format peaks from: https://bitbucket.org/lucashnegri/peakutils

from os import listdir

basedir='./vowelphonemes/'

phonemefilenames=listdir(basedir)
phonemefilenames = [x for x in phonemefilenames if x.__contains__('.wav')] # remove non-wavfiles from list
#parse out the word names from the files by getting the text between the - and the .wav extn
phonemenames = [name.split('-')[-1].split('.')[0] for name in phonemefilenames]

formants=np.array([],np.float32)
formants=np.load('vowelformants.npy')

fig = plt.figure()
ax=fig.add_subplot(111)
plt.scatter(-(formants[1][:]-formants[0][:]),formants[0][:])
plt.xlim((-2700, 0))
plt.ylim((1000, 100))
plt.grid(axis='both')
plt.xlabel('-(F2-F1) (Hz)')
plt.ylabel('F1 (Hz)')

for idx, phonemename in enumerate(phonemenames):
    ax.annotate(phonemename,  xy=(-(formants[1][idx]-formants[0][idx]),formants[0][idx]))
    print(phonemename,'\t\t',int(formants[0][idx]),' \t\t',int(-(formants[1][idx]-formants[0][idx])))

plt.savefig('plots/vowelf1f2scatter.png')