
import matplotlib.pyplot as plt
import numpy as np
from collections import Iterable
import math

def plot_neuron(neurons, delta_t, time, I, **kwargs):
    if  isinstance(neurons, Iterable):
        _plot_multiple(neurons, delta_t, time, I, name=kwargs['name'])
    else:
        _plot_single(neurons, delta_t, time, I)

def plot_neuron_state(neuron, delta_t, time, I):
    t, y = _forward(neuron, delta_t, time, I)

    fig, axs = plt.subplots(len(y), num=neuron.name)
    
    if len(y) > 1:
        for i, (variable_name,variable_values) in enumerate(y.items()):
            axs[i].plot(t, variable_values)
            axs[i].set_title(variable_name)
    else:
        axs.plot(t, y['v'])
        axs.set_title('v')

    for variable_name, variable_values in y.items():
        print(variable_name, 'min:', min(variable_values), 'max:', max(variable_values), 'min_abs:', np.min(np.abs(variable_values)))

    plt.show()

def _forward(neuron, delta_t, time, I):    
    y = {}
    neuron.reset()

    def add_vals(neuron, i):
        nonlocal y
        neuron.forward(delta_t, i)
        state = neuron.state().items()
        
        for variable_name, variable_value in state:
            y.setdefault(variable_name, []).append(variable_value)


        
    if  isinstance(I, Iterable):
        t = np.cumsum(0.0, len(I) * delta_t)
        
        for i in I:
            add_vals(neuron, i)
        
        return t, y
    else:
        t = np.arange(0.0, time, delta_t)

        for _ in range(len(t)):
            add_vals(neuron, I)
            
        return t, y

def _plot_multiple(neurons, delta_t, time, I, name):
    fig, axs = plt.subplots(math.ceil(len(neurons)/2), 2, num=name)
    fig.tight_layout(pad=1.5)
    axs = axs.flatten()
    for i, neuron in enumerate(neurons):
        ax = axs[i]
        
        t, y = _forward(neuron, delta_t, time, I)

        ax.plot(t, y['v'])

        ax.set(xlabel='Time (ms)', ylabel='Membrane potential (mV)', title=neuron.name)
        ax.grid()

    for i in range(len(neurons), len(axs)):
        fig.delaxes(axs[i])

    plt.show()

def _plot_single(neuron, delta_t, time, I):
    _, ax = plt.subplots(num=neuron.name)
    
    t, y = _forward(neuron, delta_t, time, I)

    ax.plot(t, y['v'])

    ax.set(xlabel='Time (ms)', ylabel='Membrane potential (mV)')
    ax.grid()

    plt.show()    
