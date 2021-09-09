import sys
import os
sys.path.append(os.getcwd() + '/..')

import lif
from utils.neuron_eval import eval, load_fpga_output, get_args

input, outputs = load_fpga_output()

args = get_args()

reduction = lambda key: ''.join('_'.join(key.split('_')[:-1]))
eval(input, outputs, lif.LIF(threshold=1, R=1, tau=16), dt=1, reduce_metric_mean=reduction, file_name='lif', **args) #9, 16