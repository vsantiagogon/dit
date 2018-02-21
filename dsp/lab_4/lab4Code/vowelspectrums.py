# from __future__ import print_function, division

import librosa

import matplotlib.pyplot as plt
import numpy as np

import peakutils.peakutils as peakutils # used to find format peaks from: https://bitbucket.org/lucashnegri/peakutils

# Article on peak finding: https://blog.ytotech.com/2015/11/01/findpeaks-in-python/
# Peak smoothing baseline- peakutils documenation: http://pythonhosted.org/PeakUtils/tutorial_a.html#estimating-and-removing-the-baseline
from os import listdir

formants=[[],[]]



basedir='./vowelphonemes/'

phonemefilenames=listdir(basedir)
phonemenames=[]

phonemefilenames = [x for x in phonemefilenames if x.__contains__('.wav')] # remove non-wavfiles from list

#parse out the word names from the files by getting the text between the - and the .wav extn
phonemenames = [name.split('-')[-1].split('.')[0] for name in phonemefilenames]

print('phoneme', '\t\t', 'F1 (Hz)', '  \t\t\t', 'F2 (Hz)')
for idx,fname in enumerate(phonemefilenames):

    #wave_phoneme=thinkdsp.read_wave(basedir+fname)
    y, sr = librosa.load(basedir+fname, sr=None)
    high, low = abs(max(y)), abs(min(y))
    y = y / max(high, low)#normalize
    
    spectrum = np.fft.rfft(y)
    amps = abs(spectrum)
    freqs = np.fft.rfftfreq(len(y), 1 /sr)
    
    #spectrum = wave_phoneme.make_spectrum()
    plt.plot(freqs,amps)
    plt.title(fname)
    plt.xlim((0,3000))
    plt.ylim((0, 1000))
    plt.grid(axis='both')
    plt.xlabel('Freq. (Hz)')
    plt.ylabel('Magnitude')
    plt.savefig('plots/'+fname+'.png')
    plt.clf()
    #rpeaks=abs(spectrum.real)
    rpeaks=abs(np.real(spectrum))
    freq_res = sr / 2 / (len(freqs) - 1)
    indexes = peakutils.indexes(rpeaks, thres=0.02/max(rpeaks), min_dist=130/freq_res)

    indexes.sort()

    peaks=[freqs[indexes],amps[indexes]]
    # print(peaks)
    apeaks=np.array(peaks,np.float32)

    # find the first and second formant
    # first formant is max peak between ~ 250 and  650 Hz
    # second formant is max peak between ~ 650 and 2100 Hz

    fmin = 250
    fidxs=np.argwhere(apeaks[0] <= fmin)
    fidxs=fidxs[:]

    f1max=650
    f1idxs = np.argwhere(apeaks[0] <= f1max)
    f1idxs = [f for f in f1idxs.flatten() if f not in fidxs.flatten()]  #remove F1 freqs from F2 idx list
    f1idxs=f1idxs[:]

    maxf1idx = np.argmax(apeaks[1][f1idxs])

    if fidxs is not None:
        f1idxs.extend(fidxs) # remove all indexes below 650, so fidxs and f1idxs

    f2max=2100
    f2idxs = np.argwhere(apeaks[0] <= f2max)
    f2idxs = [f for f in f2idxs.flatten() if f not in f1idxs]  #remove F1 freqs from F2 idx list
    f2idxs=f2idxs[:]

    maxf2idx = np.argmax(apeaks[1][f2idxs])

    f1=apeaks[0][f1idxs[maxf1idx]].flatten()
    f2=apeaks[0][f2idxs[maxf2idx]].flatten()

    formants[0].append(f1)
    formants[1].append(f2)
    print(phonemenames[idx],'\t\t\t',int(f1),' \t\t\t',int(f2))

np.save('vowelformants.npy',np.array(formants,np.float32)) # write the array of formant values to a file

