import numpy as np
import scipy as sp
from scipy import stats
from scipy.stats import norm
#
def start1():
    fa= open('data.dat','r')
    i1 = []
    for line in fa:
        a=line.split()
        i1.append(float(a[0]))
    fa.close()
    return i1
#
i1 = start1()
#
mu, std = norm.fit(i1)
#
av=np.mean(i1)
histo=np.histogram(i1, bins=100, density=True)
hist, bin_edges = np.histogram(i1, bins=100, density=True)
print "Mean and standard deviation"
print mu, std
#print av, np.average(i1)
#print hist
#print bin_edges
#print np.sqrt(np.mean((i1)**2))
#print np.sum(hist*np.diff(bin_edges))
i2=0.0
for j in range(len(i1)):
    i2=i2+i1[j]**2
# root mean square
#print np.sqrt(i2/len(i1))
print "N points, Min, Max, Mean, Variance, Skewness, Kurtosis"
print sp.stats.describe(i1)
#print sp.stats.normaltest(i1, axis=0)
# histograms
#print len(i1)
#print len(hist)
#print len(bin_edges)
out_name1="histo.dat"
fout1 = open(out_name1, "w")
for j in range(len(hist)):
    fout1.write("%15.6f %15.6f \n"%(bin_edges[j],hist[j]))
#    print bin_edges[j],hist[j]

#
# version script: 0.1
# Revised last time: 18.08.2016
# Authors: Enrico Spiga
# Institutions: The Francis Crick Institute
