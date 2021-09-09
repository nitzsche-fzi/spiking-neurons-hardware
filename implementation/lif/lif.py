import utils.differential_equation_solver as ds
import math

class LIF:
    def __init__(self, threshold, R, tau, ur = 0, name = 'LIF'):
        self.v = 0
        self.threshold = threshold

        self.name = name

        self.dvdt = lambda v, I: (-(v - ur) + R * I) / tau

    def forward(self, delta_t, I):
        self.v = ds.solve(self.v, self.dvdt, delta_t, I)

        if self.v >= self.threshold:
            self.v = 0

    def state(self):
        return {'v': self.v}

    def reset(self):
        self.v = 0

lif = LIF(threshold=1, R=1, tau=32)
all = [lif]

