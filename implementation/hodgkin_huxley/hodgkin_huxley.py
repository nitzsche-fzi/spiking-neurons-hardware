import numpy as np
import math

import utils.differential_equation_solver as ds

xs = []

class HodkinHuxley:
    def __init__(self, name = 'Hodking-Huxley'):
        self.reset()

        self.E_K = -77
        self.E_Na = 55
        self.E_L = -65

        self.g_K = 35
        self.g_Na = 40
        self.g_L = 0.3
        
        self.alpha_n = lambda u: 0.02 * (u-25) / (1 - math.exp(-(u-25)/9))
        self.alpha_m = lambda u: 0.182 * (u+35) / (1 - math.exp(-(u+35)/9))
        self.alpha_h = lambda u: 0.25 * math.exp(-(u+90)/12)

        self.beta_n = lambda u: -0.002 * (u-25) / (1 - math.exp((u-25)/9))
        self.beta_m = lambda u: -0.124 * (u+35) / (1 - math.exp((u+35)/9))
        self.beta_h = lambda u: 0.25 * math.exp(((u+62)-(u+90)/2)/6)


        self.dvdt = lambda v, I: (I - self.g_K * self.n**4 * (v-self.E_K)
                                 - self.g_Na * self.m**3 * self.h * (v-self.E_Na)
                                 - self.g_L * (v - self.E_L))

        self.dndt = lambda n, _: self.alpha_n(self.v) * (1-n) - self.beta_n(self.v) * n
        self.dmdt = lambda m, _: self.alpha_m(self.v) * (1-m) - self.beta_m(self.v) * m
        self.dhdt = lambda h, _: self.alpha_h(self.v) * (1-h) - self.beta_h(self.v) * h

        self.name = name

    def forward(self, delta_t, I):
        self.v, self.n, self.m, self.h = ds.solve((self.v, self.n, self.m, self.h), (self.dvdt, self.dndt, self.dmdt, self.dhdt), delta_t, I)
  
    def reset(self):
        self.v = 0
        self.n = 0
        self.m = 0
        self.h = 0

    def state(self):
        return {'v': self.v,
        'n': self.n,
        'm': self.m,
        'h': self.h }

hodgkin_huxley = HodkinHuxley()
all = [hodgkin_huxley]

