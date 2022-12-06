import math

def f(x) :
    return x ** 2 - 2

def df(x) :
    return 2 * x

root = math.sqrt(2)
a, b, k = 1, 2, 0
fa, fb = f(a), f(b)
tol = 1.e-5

print("二分逼近法: 起始區間(", a, ", ", b, ")", sep = "")

while True :
    c = (a + b) / 2
    err = abs(c - root)
    k += 1

    print("{:<2} : {:<10e} {:<10e}".format(k, c, err), sep = "")
    
    fc = f(c)

    if abs(fc) < tol :
        break

    if fc * fa < 0 :
        b = c
        fb = fc
    else :
        a = c
        fa = fc

print()


"""
二分逼近法: 起始區間(1, 2)
1  : 1.500000e+00 8.578644e-02
2  : 1.250000e+00 1.642136e-01
3  : 1.375000e+00 3.921356e-02
4  : 1.437500e+00 2.328644e-02
5  : 1.406250e+00 7.963562e-03
6  : 1.421875e+00 7.661438e-03
7  : 1.414062e+00 1.510624e-04
8  : 1.417969e+00 3.755188e-03
9  : 1.416016e+00 1.802063e-03
10 : 1.415039e+00 8.255001e-04
11 : 1.414551e+00 3.372189e-04
12 : 1.414307e+00 9.307825e-05
13 : 1.414185e+00 2.899206e-05
14 : 1.414246e+00 3.204310e-05
15 : 1.414215e+00 1.525518e-06
"""