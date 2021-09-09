import sys
import os
sys.path.append(os.getcwd() + '/..')

from utils.neuron_plot import plot_neuron, plot_neuron_state
import hodgkin_huxley

delta_t = 0.0625 # s
time = 100 # ms

for I in [0.5, 1.0, 2.0]:
    plot_neuron(hodgkin_huxley.hodgkin_huxley, delta_t, time, I=I, name='Hodgkin-Huxley')
    #plot_neuron_state(hodgkin_huxley.hodgkin_huxley, delta_t, time, I=I)