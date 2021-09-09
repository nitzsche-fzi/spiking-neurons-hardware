import sys
import os
sys.path.append(os.getcwd() + '/..')

import numpy as np

import hodgkin_huxley
from utils.neuron_eval import eval, load_fpga_output, get_args

dt = 0.0625
input, l = load_fpga_output()

args = get_args()

reduction = lambda key: ''.join('_'.join(key.split('_')[:-1]))
name_column = lambda file: file.split('_')[1]
eval(input, l, hodgkin_huxley.hodgkin_huxley, dt, name_column=name_column, reduce_metric_mean=reduction, file_name='hodgkin_huxley', **args) #16, 24
