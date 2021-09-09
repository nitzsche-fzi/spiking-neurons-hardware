import utils.differential_equation_solver as ds
import math

class ExpLIF:
    def __init__(self, threshold, tau, dt, theta, name = 'ExpLIF'):
        self.reset()
        self.threshold = threshold

        self.name = name

        self.dvdt = lambda u, I: (-u + dt * math.exp((u - theta) / dt) + I) / tau

    def forward(self, delta_t, I):
        self.v = ds.solve(self.v, self.dvdt, delta_t, I)

        if self.v >= self.threshold:
            self.reset()

    def state(self):
        return {'v': self.v}

    def reset(self):
        self.v = 0

exp_lif = ExpLIF(threshold=10, tau=4, theta=1.75, dt=1)
all = [exp_lif]