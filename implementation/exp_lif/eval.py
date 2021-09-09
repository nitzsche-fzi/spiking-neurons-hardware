import sys
import os
sys.path.append(os.getcwd() + '/..')

import exp_lif
from utils.neuron_eval import eval, load_fpga_output, get_args

input, l = load_fpga_output()

args = get_args()

reduction = lambda key: ''.join('_'.join(key.split('_')[:-1]))
name_col = lambda file: file.split('_')[1]

eval(input, l, exp_lif.exp_lif, dt=1, reduce_metric_mean=reduction, name_column=name_col, filter_name=lambda n: n.startswith('cordic'), file_name='exp_lif_cordic', **args) #8,16
eval(input, l, exp_lif.exp_lif, dt=1, reduce_metric_mean=reduction, name_column=name_col, filter_name=lambda n: n.startswith('power2'), file_name='exp_lif_power2', **args) #6,7,16
