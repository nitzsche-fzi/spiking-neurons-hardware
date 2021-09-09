import math
from os import urandom
import utils.differential_equation_solver as ds

class AdEx:
    def __init__(self, threshold, R, tau_m, dt, theta, tau_w, a, b, ur = 0, u_rest = 0, name = 'AdEx'):        
        self.ur = ur
        self.u_rest = u_rest
        self.reset()
        self.b = b
        self.threshold = threshold

        self.name = name

        self.dvdt = lambda u, I: (-(u-u_rest) + dt * math.exp((u - theta) / dt) + R * I - R * self.w) / tau_m
        self.dwdt = lambda w, _: (a * (self.v-u_rest) - w) / tau_w 

    def forward(self, delta_t, I):
        self.v, self.w = ds.solve([self.v, self.w], [self.dvdt, self.dwdt], delta_t, I)

        if self.v >= self.threshold:
            self.v = self.ur
            self.w += self.b

    def state(self):
        return {'v': self.v, 'w': self.w}

    def reset(self):
        self.v = self.ur
        self.w = 0

ad_ex = AdEx(tau_m=4, R=1, threshold=10,  theta=1.75, dt=1, a=0, tau_w=128, b=1, ur=0, u_rest=0)
all = [ad_ex]