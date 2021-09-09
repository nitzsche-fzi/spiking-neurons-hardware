import sys
import os
sys.path.append(os.getcwd() + '/..')

from utils.metrics import rel_dif, abs_dif, metrics_dict, save_to_file

import math

import numpy as np
import math
import matplotlib.pyplot as plt

xs, power2_y = np.genfromtxt('./.output/power2_based_22.csv', delimiter=14, unpack=True)
power2_opt_x, power2_opt_y = np.genfromtxt('./.output/power2_based_opt_22.csv', delimiter=14, unpack=True)
cordic_x, cordic_y = np.genfromtxt('./.output/cordic_22.csv', delimiter=14, unpack=True)

assert((xs == cordic_x).all())
assert((xs == power2_opt_x).all())
math_y = [math.exp(x) for x in xs]

power2_abs_perf = abs_dif(math_y, power2_y)
power2_rel_perf = rel_dif(math_y, power2_y)

power2_opt_abs_perf = abs_dif(math_y, power2_opt_y)
power2_opt_rel_perf = rel_dif(math_y, power2_opt_y)

cordic_abs_perf = abs_dif(math_y, cordic_y)
cordic_rel_perf = rel_dif(math_y, cordic_y)

"""plt.plot(xs, math_y, 'r') 
plt.plot(xs, power2_y, 'b')
plt.plot(xs, cordic_y, 'y')
plt.plot(xs, power2_opt_y, 'g')
plt.show()"""

plt.figure()
plt.plot(xs, power2_abs_perf, 'b', label='ExpPwr2-precise')  
plt.plot(xs, cordic_abs_perf, 'y', label='CORDIC') 
plt.plot(xs, power2_opt_abs_perf, 'g', label='ExpPwr2-fast')
plt.xlabel('x')
plt.ylabel('Absolute Abweichung')
plt.legend(loc='upper left')
plt.savefig('.plots/exp_ad.pdf', bbox_inches='tight')

plt.figure()
plt.plot(xs, power2_rel_perf, 'b', label='ExpPwr2-precise')  
plt.plot(xs, cordic_rel_perf, 'y', label='CORDIC')  
plt.plot(xs, power2_opt_rel_perf, 'g', label='ExpPwr2-fast')
plt.xlabel('x')
plt.ylabel('Relative Abweichung')
plt.legend(loc='upper right')
plt.savefig('.plots/exp_rd.pdf', bbox_inches='tight')

res = [(method, metrics_dict(math_y, pred_y)) for method, pred_y in [('ExpPwr2-precise', power2_y), ('ExpPwr2-fast', power2_opt_y), ('CORDIC', cordic_y)]]
save_to_file('.metrics/metrics.csv', res)
