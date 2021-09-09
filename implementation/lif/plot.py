import sys
import os
sys.path.append(os.getcwd() + '/..')

from utils.neuron_plot import plot_neuron
import lif

delta_t = 1 # ms
time = 100 # ms

for I in [1, 1.03125, 1.0625, 1.1875, 1.25, 1.5]:
    plot_neuron(lif.LIF(threshold=1, R=1, tau=16, name='LIF16'), delta_t, time, I=I)