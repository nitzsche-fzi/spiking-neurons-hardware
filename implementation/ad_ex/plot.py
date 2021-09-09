import sys
import os
sys.path.append(os.getcwd() + '/..')

from utils.neuron_plot import plot_neuron, plot_neuron_state
import ad_ex

delta_t = 1 # ms
time = 100 # ms

for I in [0.75, 1.0, 1.75, 2.25, 3.25, 4.0]:
    plot_neuron(ad_ex.ad_ex, delta_t, time, I=I, name='AdEx')