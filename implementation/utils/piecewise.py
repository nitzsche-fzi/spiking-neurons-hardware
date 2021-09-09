import numpy as np
from numpy.linalg import lstsq

from os import makedirs

# Thanks to: https://datascience.stackexchange.com/a/32833
def segmented_linear_reg( X, Y, breakpoints , break_cond = 2**-31):
    ramp = lambda u: np.maximum( u, 0 )
    step = lambda u: ( u > 0 ).astype(float)

    nIterationMax = 100

    breakpoints = np.sort( np.array(breakpoints) )

    dt = np.min( np.diff(X) )
    ones = np.ones_like(X)

    for i in range( nIterationMax ):
        # Linear regression:  solve A*p = Y
        Rk = [ramp( X - xk ) for xk in breakpoints ]
        Sk = [step( X - xk ) for xk in breakpoints ]
        A = np.array([ ones, X ] + Rk + Sk )
        p =  lstsq(A.transpose(), Y, rcond=None)[0] 

        # Parameters identification:
        a, b = p[0:2]
        ck = p[ 2:2+len(breakpoints) ]
        dk = p[ 2+len(breakpoints): ]

        # Estimation of the next break-points:
        newBreakpoints = breakpoints - dk/ck 

        # Stop condition
        if np.max(np.abs(newBreakpoints - breakpoints)) < break_cond:
            break

        breakpoints = newBreakpoints
    else:
        print( 'maximum iteration reached' )

    # Compute the final segmented fit:
    Xsolution = np.insert( np.append( breakpoints, max(X) ), 0, min(X) )
    ones =  np.ones_like(Xsolution) 
    Rk = [ c*ramp( Xsolution - x0 ) for x0, c in zip(breakpoints, ck) ]

    Ysolution = a*ones + b*Xsolution + np.sum( Rk, axis=0 )

    return Xsolution, Ysolution

def export_segments(X, Y, var, input_var='v', dir = '.pwl'):
    name = 'PWL_' + var
    dX = np.diff(X)
    dY = np.diff(Y)
    m = dY / dX
    X = X[:-1]
    Y = Y[:-1]
    Y = Y - m * X
    makedirs(dir, exist_ok=True)
    with open(dir + '/' + name, mode='w') as fp:
        with open(dir + '/' + name + '_py', mode='w') as fp_py:
            for i in range(1, len(X)):
                fp.write('constant X_%s%i : real := %f;\n' % (var, i, X[i]))
                fp_py.write('X_%s%i = %f\n' % (var, i, X[i]))

            fp.write('\n')
            fp_py.write('\n')

            for i in range(len(m)):
                fp.write('constant m_%s%i : real := %f;\n' % (var, i, m[i]))
                fp_py.write('m_%s%i = %f\n' % (var, i, m[i]))

            fp.write('\n')
            fp_py.write('\n')

            for i in range(len(Y)):
                fp.write('constant k_%s%i : real := %f;\n' % (var, i, Y[i]))
                fp_py.write('k_%s%i = %f\n' % (var, i, Y[i]))

            fp.write('\n')
            fp_py.write('\n')
            
            fp_py.write('def %s(%s):\n' % (var, input_var))

            for i in range(len(X)):
                cond = ''

                if i < len(X) - 1:
                    cond = 'if %s < X_%s%d then\n' % (input_var, var, i+1)                    
                    cond_py = 'if %s < X_%s%d:\n' % (input_var, var, i+1)
                    if i != 0:
                        cond = 'els' + cond
                        cond_py = 'el' + cond_py
                else: 
                    cond = 'else\n'
                    cond_py = 'else:\n'

                fp.write(cond)

                fp.write('\t%s := resize(resize(m_%s%d * v, v) + k_%s%d, v);\n' % (var, var, i, var, i))

                
                fp_py.write('\t' + cond_py)

                fp_py.write('\t\treturn m_%s%d * v + k_%s%d\n' % (var, i, var, i))
            fp.write('end if;')