import sys
import os
sys.path.append(os.getcwd() + '/..')

from utils.neuron_plot import plot_neuron, plot_neuron_state
import quadratic_lif

delta_t = 1 # ms
time = 100 # ms

for I in [0.75, 0.8125, 0.875, 0.9375, 1.0, 1.125]:
    plot_neuron(quadratic_lif.all, delta_t, time, I=I, name='QuadLIF')