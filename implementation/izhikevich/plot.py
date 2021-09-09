import sys
import os
sys.path.append(os.getcwd() + '/..')

from utils.neuron_plot import plot_neuron, plot_neuron_state
import izhikevich


delta_t = 1 # ms
time = 100 # ms

for I in [2.0, 4.0, 6.0, 9.0, 12.0, 16.0]:
    plot_neuron(izhikevich.rs, delta_t, time, I=I)
    plot_neuron_state(izhikevich.rs, delta_t, time, I=I)


plot_neuron(izhikevich.all, delta_t, time, I=4, name='Izhikevich neurons')