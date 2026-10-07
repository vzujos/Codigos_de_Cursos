# -*- coding: utf-8 -*-

import numpy as np
from bsplines import Analysis, MeshDomain
from exportVTUmodified import exportVTU

L = 10.
R = 1.
H = 0.1

l = 10.
r = 1.5
h = 0.1

p = 2
q = 1

Xi = np.array([0.,0.,0.,1.,1.,2.,2.,3.,3.,4.,4.,4.])
Eta = np.array([0.,0.,1.,1.])

nxi = 100
neta = 100
nzeta = 10

axi = np.linspace(0.,4.,nxi,endpoint=False)
aeta = np.linspace(0.,1.,neta)
azeta = np.linspace(-H/2.,H/2,nzeta)

B = np.zeros((9,2,4))

B[0,0] = np.array([ R , 0.,0.,1.            ])
B[0,1] = np.array([ R , 0.,L ,1.            ])
B[1,0] = np.array([ R , R ,0.,1./np.sqrt(2.)])
B[1,1] = np.array([ R , R ,L ,1./np.sqrt(2.)])
B[2,0] = np.array([ 0., R ,0.,1.            ])
B[2,1] = np.array([ 0., R ,L ,1.            ])
B[3,0] = np.array([-R , R ,0.,1./np.sqrt(2.)])
B[3,1] = np.array([-R , R ,L ,1./np.sqrt(2.)])
B[4,0] = np.array([-R , 0.,0.,1.            ])
B[4,1] = np.array([-R , 0.,L ,1.            ])
B[5,0] = np.array([-R ,-R ,0.,1./np.sqrt(2.)])
B[5,1] = np.array([-R ,-R ,L ,1./np.sqrt(2.)])
B[6,0] = np.array([ 0.,-R ,0.,1.            ])
B[6,1] = np.array([ 0.,-R ,L ,1.            ])
B[7,0] = np.array([ R ,-R ,0.,1./np.sqrt(2.)])
B[7,1] = np.array([ R ,-R ,L ,1./np.sqrt(2.)])
B[8,0] = np.array([ R , 0.,0.,1.            ])
B[8,1] = np.array([ R , 0.,L ,1.            ])

b = np.zeros((9,2,4))

b[0,0] = np.array([ r , 0.,0.,1.            ])
b[0,1] = np.array([ r , 0.,l ,1.            ])
b[1,0] = np.array([ r , r ,0.,1./np.sqrt(2.)])
b[1,1] = np.array([ r , r ,l ,1./np.sqrt(2.)])
b[2,0] = np.array([ 0., r ,0.,1.            ])
b[2,1] = np.array([ 0., r ,l ,1.            ])
b[3,0] = np.array([-r , r ,0.,1./np.sqrt(2.)])
b[3,1] = np.array([-r , r ,l ,1./np.sqrt(2.)])
b[4,0] = np.array([-r , 0.,0.,1.            ])
b[4,1] = np.array([-r , 0.,l ,1.            ])
b[5,0] = np.array([-r ,-r ,0.,1./np.sqrt(2.)])
b[5,1] = np.array([-r ,-r ,l ,1./np.sqrt(2.)])
b[6,0] = np.array([ 0.,-r ,0.,1.            ])
b[6,1] = np.array([ 0.,-r ,l ,1.            ])
b[7,0] = np.array([ r ,-r ,0.,1./np.sqrt(2.)])
b[7,1] = np.array([ r ,-r ,l ,1./np.sqrt(2.)])
b[8,0] = np.array([ r , 0.,0.,1.            ])
b[8,1] = np.array([ r , 0.,l ,1.            ])

x, y, F, J, lamb, N = Analysis(axi,aeta,azeta,p,q,B,b,Xi,Eta)

IEN = MeshDomain(nxi,neta,nzeta)

fnameref = 'radial_ref'
exportVTU(fnameref,x,IEN,J,lamb,N)

exportVTU(f"def_{fnameref}", y, IEN, J, lamb, N)