from collections import Iterable

def solve(variables, dif_equations, delta_t, I, method='euler'):
    iterable = True
    if not isinstance(variables, Iterable):
        variables = (variables,)
        dif_equations = (dif_equations,)
        iterable = False

    def helper():
        for var, dt in zip(variables, dif_equations):
            if method == 'euler':
                yield euler(var, dt, delta_t, I)
            else:
                yield method(var, dt, delta_t, I)

    ret = helper()

    return ret if iterable else next(ret)

def euler(var, dt, delta_t, I):
    return var + delta_t * dt(var, I)
