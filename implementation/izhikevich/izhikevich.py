import utils.differential_equation_solver as ds

class Izhikevich:
    # https://www.izhikevich.org/publications/spikes.htm
    def __init__(self, a, b, c, d, name='Izhikevich', threshold = 30.0):
        self.b = b
        self.c = c
        self.d = d
        self.threshold = threshold
        self.name = name

        self.reset()

        self.dvdt = lambda v, I: 0.04*v**2 + 5*v - self.u + I + 140
        self.dudt = lambda u, _: a * (b * self.v - u)

    def forward(self, delta_t, I):
        self.v, self.u = ds.solve((self.v, self.u), (self.dvdt, self.dudt), delta_t, I)
        if self.v >= self.threshold:
            self.v = self.c
            self.u += self.d 

    def state(self):
        return {'v': self.v, 'u': self.u}

    def reset(self):
        self.v = self.c
        self.u = self.b * self.v

rs = Izhikevich(0.02, 0.2, -65, 8, 'regular spiking')
fs = Izhikevich(0.1, 0.2, -65, 2, 'fast spiking')
lts = Izhikevich(0.02, 0.25, -65, 2, 'low-threshold spiking')
tc = Izhikevich(0.02, 0.25, -65, 0.05, 'thalamo cortical')
rz = Izhikevich(0.1, 0.26, -65, 2, 'resonator')
ib = Izhikevich(0.02, 0.2, -55, 4, 'Iintrinsically bursting')
ch = Izhikevich(0.02, 0.2, -50, 2, 'chattering')
all = [rs, fs, lts, tc, rz, ib, ch]