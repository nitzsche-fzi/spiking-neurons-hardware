import math

print(','.join([str(math.exp(0.5**i)) for i in range(1, 65)]))
print()
print(','.join(["to_sfixed({}, fxp'high, fxp'low)".format(str(math.exp(i))) for i in range(-22, 23)]))
