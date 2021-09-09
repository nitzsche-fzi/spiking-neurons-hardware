import numpy as np
import re
import os

def parse_power(str):
    content = open('./.reports/power_' + str, 'r').read()
    m = re.search(r'\|\sDynamic \(W\)\s*\|\s([0-9.]*)\s*\|', content)
    assert(m)
    return m.group(1)

def parse_frequency(str):
    content = open('./.reports/timing_' + str, 'r').read()

    m = re.search(r"^\s*WNS\(ns\)\s*TNS\(ns\).*\n.*\n\s*([0-9\-.]*)", content, re.MULTILINE)

    if m.group(1):
        return 1000.0 / (10.0 - float(m.group(1)))
    else:
        return -1.0

def parse_ressources(str):
    content = open('./.reports/utilization_' + str, 'r').read()
    m = re.search(r'CLB LUTs\s*\|\s*([0-9]*)[\s\S]*CLB Registers\s*\|\s*([0-9]*)[\s\S]*CARRY8\s*\|\s*([0-9]*)[\s\S]*DSPs\s*\|\s*([0-9]*)', content)

    return (m[1], m[2], m[3], m[4])

def parse_no_dsp_ressources(str):
    content = open('./.reports/nodsputilization_' + str, 'r').read()
    m = re.search(r'CLB LUTs\s*\|\s*([0-9]*)[\s\S]*CARRY8\s*\|\s*([0-9]*)', content)

    return (m[1], m[2])

methods = set('_'.join(f.split('_')[1:]) for f in os.listdir('./.reports/'))

data = [(s.split('.')[0], parse_frequency(s), parse_power(s), *parse_ressources(s), *parse_no_dsp_ressources(s)) for s in methods]

np.savetxt('.metrics/{}_hardware.csv'.format(os.path.basename(os.getcwd())), data, header='method,f,pwr,lut,reg,carry,dsp,nodsplut,nodspcarry',comments='',delimiter=',',fmt='%s')