import utils.differential_equation_solver as ds

class QuadraticLIF:
    def __init__(self, threshold, tau, uc, a0 = 1, R=1, ur = 0, name = 'QuadraticLIF'):
        self.reset()
        self.threshold = threshold

        self.name = name

        self.dvdt = lambda u, I: (a0 * (u - ur) * (u-uc) + R * I) / tau

    def forward(self, delta_t, I):
        self.v = ds.solve(self.v, self.dvdt, delta_t, I)

        if self.v >= self.threshold:
            self.v = 0

    def state(self):
        return {'v': self.v}

    def reset(self):
        self.v = 0

quadratic_lif = QuadraticLIF(threshold=10, tau=4, uc=1.75)
all = [quadratic_lif]