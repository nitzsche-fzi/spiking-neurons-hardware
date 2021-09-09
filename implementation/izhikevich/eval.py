import sys
import os
sys.path.append(os.getcwd() + '/..')

import numpy as np

import izhikevich
from utils.neuron_eval import eval, load_fpga_output, get_args


input, l = load_fpga_output()

args = get_args()

reduction = lambda key: ''.join('_'.join(key.split('_')[:-1]))
name_col = lambda file: file.split('_')[2]

eval(input, l, izhikevich.rs, dt=1, filter_name=lambda n: n.startswith('standard'), name_column=name_col, reduce_metric_mean=reduction, file_name='standard_izhikevich', **args) #10,16
eval(input, l, izhikevich.rs, dt=0.78125, filter_name=lambda n: n.startswith('opt'), name_column=name_col, reduce_metric_mean=reduction, file_name='optimized_izhikevich', **args) #8, 16