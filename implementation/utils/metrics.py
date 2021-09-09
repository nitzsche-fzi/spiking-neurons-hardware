import sklearn.metrics as metrics
import math
from fastdtw import fastdtw
from scipy.spatial.distance import euclidean

import numpy as np

def __normalization_constant(y_true):
    return max(y_true) - min(y_true)

def RMSE(y_true, y_pred, normalized = False):
    rmse = math.sqrt(metrics.mean_squared_error(y_true, y_pred))

    if normalized and rmse != 0.0:
        return rmse / __normalization_constant(y_true) * 100.0

    return rmse

def MAE(y_true, y_pred, normalized = False):
    mae = metrics.mean_absolute_error(y_true, y_pred)

    if normalized and mae != 0.0:
        return mae / __normalization_constant(y_true) * 100.0

    return mae

def ME(y_true, y_pred):
    return max(abs(el1 - el2) for el1, el2 in zip(y_true, y_pred))

def MRE(y_true, y_pred):
    return sum(rel_dif(y_true, y_pred)) / len(y_true) * 100.0

def dtw_score(y_true, y_pred):
    return fastdtw(y_pred, y_true, radius=5, dist=euclidean)[0]
    
def metrics_dict(y_true, y_pred):
    return {
        'RMSE': RMSE(y_true, y_pred),
        'NRMSE': RMSE(y_true, y_pred, normalized=True),
        'MAE': MAE(y_true, y_pred),
        'NMAE': MAE(y_true, y_pred, normalized=True),
        'ME': ME(y_true, y_pred),
        'MRE': MRE(y_true, y_pred),
        'DTW': dtw_score(y_true, y_pred)
    }

def save_to_file(file_name, metrics):
    header = ['method', 'RMSE', 'NRMSE', 'MAE', 'NMAE', 'ME', 'MRE', 'DTW']
    content = [[method] + [results[metric] for metric in header[1:]] for method, results in metrics]
    np.savetxt(file_name, content, delimiter=',', comments='', header=','.join(header), fmt='%s')

def abs_dif(y_true, y_pred):
    return [abs(e1-e2) for e1, e2 in zip(y_true, y_pred)]
    
def rel_dif(y_true, y_pred):   
    return [abs(e1-e2) / max(abs(e1), abs(e2)) if e1 != e2 else 0.0 for e1, e2 in zip(y_true, y_pred)]