import sys
import os
sys.path.append(os.getcwd() + '/..')

import quadratic_lif
from utils.neuron_eval import eval, load_fpga_output, get_args

input, l = load_fpga_output()

args = get_args()

reduction = lambda key: ''.join('_'.join(key.split('_')[:-1]))
eval(input, l, quadratic_lif.quadratic_lif, dt=1, reduce_metric_mean=reduction, file_name='quadratic_iaf', **args) #7, 16