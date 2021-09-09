import numpy as np
import matplotlib.pyplot as plt
import os

from matplotlib.ticker import MaxNLocator
import utils.metrics as metrics

from natsort import natsorted, ns

from utils.metrics import save_to_file

def eval(input, outputs, neuron, dt, plot=False, reduce_metric_mean=None, filter_name=None, name_column=None, file_name=''):
    metric_results = {}

    if not name_column:
        name_column = lambda x: x

    if filter_name:
        filtered_indices = [i for i in range(len(outputs)) if filter_name(outputs[i][0])]
        input = [input[i] for i in filtered_indices]
        outputs = [outputs[i] for i in filtered_indices]

        if len(input) == 1:
            input = input[0]

    def sim_neuron(input):
        neuron.reset()
        ref_output = []
        for I in input:
            neuron.forward(dt, I)
            ref_output.append(neuron.v)

        return ref_output

    for i in range(len(input)):
        output_name, output = outputs[i]
        ref_output = sim_neuron(input[i])

        metric_results[output_name] = metrics.metrics_dict(ref_output, output)

        if plot:
            t = np.cumsum([dt] * len(input[i]))

            _, ax = plt.subplots(num=neuron.name)

            ax.plot(t, ref_output, linestyle=':', label='Python reference')
            ax.plot(t, output, label=output_name)

            ax.set(xlabel='Time (ms)', ylabel='Membrane potential')
            ax.grid()
            ax.legend()
            plt.savefig('.plots/{}.pdf'.format(output_name), bbox_inches='tight')
            plt.clf()

    if reduce_metric_mean:
        def reduce_mean(li):
            r = {k: [v] for k,v in li[0].items()}

            for m in li[1:]:
                for k,v in m.items():
                    r[k].append(v)

            return {k: sum(v)/len(v) for k,v in r.items()}

        metric_results_reduced = {}
        for key in metric_results.keys():
            metric_results_reduced.setdefault(reduce_metric_mean(key), []).append(metric_results[key])

        metric_results = {k: reduce_mean(v) for k, v in metric_results_reduced.items()}

    for output_name in metric_results.keys():
        print(output_name + ': ' + ', '.join([k + ':' + str(v) for k,v in metric_results[output_name].items()]))

    path = './.metrics/{}.csv'.format(file_name)

    save_to_file(path, [(name_column(k), v) for k,v in metric_results.items()])
    if plot:
        data = np.loadtxt(path, delimiter=',', skiprows=1)

        x = data[:,0]
        nrmse = data[:,2]
        nmae = data[:,4]
        mre = data[:,6]
        dtw = data[:,7]
        dtw = (dtw - np.min(dtw)) / np.ptp(dtw) * 100.0

        fig = plt.figure()
        plt.plot(x, nrmse, 'r', label='NRMSE', linestyle=':', marker='^')
        plt.plot(x, nmae, 'g', label='NMAE', linestyle=':', marker='s')
        plt.plot(x, mre, 'b', label='MRE', linestyle=':', marker='P')
        plt.plot(x, dtw, 'y', label='DTW normalized', linestyle=':', marker='o')
        plt.xlabel('Decimal bit width')
        plt.ylabel('Error (%)')
        ax = fig.gca()
        ax.xaxis.set_major_locator(MaxNLocator(integer=True))
        plt.legend(loc='upper right')
        plt.savefig('./.plots/{}.pdf'.format(file_name), bbox_inches='tight')
        plt.clf()

def load_fpga_output():
    l = [(f,) + tuple(np.loadtxt('.output/' + f, unpack=True)) for f in natsorted(os.listdir('.output'), alg=ns.IGNORECASE)]
    return [inputs for _, inputs, _ in l], [(file, output) for file, _, output in l]

def get_args():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--plot', default=False, action='store_true')
    args = parser.parse_args()
    return vars(args)
