# -*- coding: utf-8 -*-

import numpy as np
from bsplines import Analysis, MeshDomain
from exportVTUmodified import exportVTU

L = 10.
R = 1.
H = 0.1

p = 2
q = 2

Xi = np.array([0.,0.,0.,1.,1.,2.,2.,3.,3.,4.,4.,4.])
Eta = np.array([0.,0.,0.,1.,1.,1.])

nxi = 100
neta = 100
nzeta = 10

axi = np.linspace(0.,4.,nxi,endpoint=False)
aeta = np.linspace(0.,1.,neta)
azeta = np.linspace(-H/2.,H/2,nzeta)

B = np.zeros((9,3,4))

B[0,0] = np.array([ R , 0.,0. ,1.            ])
B[0,1] = np.array([ R , 0.,L/2,1.            ])
B[0,2] = np.array([ R , 0.,L  ,1.            ])
B[1,0] = np.array([ R , R ,0. ,1./np.sqrt(2.)])
B[1,1] = np.array([ R , R ,L/2,1./np.sqrt(2.)])
B[1,2] = np.array([ R , R ,L  ,1./np.sqrt(2.)])
B[2,0] = np.array([ 0., R ,0. ,1.            ])
B[2,1] = np.array([ 0., R ,L/2,1.            ])
B[2,2] = np.array([ 0., R ,L  ,1.            ])
B[3,0] = np.array([-R , R ,0. ,1./np.sqrt(2.)])
B[3,1] = np.array([-R , R ,L/2,1./np.sqrt(2.)])
B[3,2] = np.array([-R , R ,L  ,1./np.sqrt(2.)])
B[4,0] = np.array([-R , 0.,0. ,1.            ])
B[4,1] = np.array([-R , 0.,L/2,1.            ])
B[4,2] = np.array([-R , 0.,L  ,1.            ])
B[5,0] = np.array([-R ,-R ,0. ,1./np.sqrt(2.)])
B[5,1] = np.array([-R ,-R ,L/2,1./np.sqrt(2.)])
B[5,2] = np.array([-R ,-R ,L  ,1./np.sqrt(2.)])
B[6,0] = np.array([ 0.,-R ,0. ,1.            ])
B[6,1] = np.array([ 0.,-R ,L/2,1.            ])
B[6,2] = np.array([ 0.,-R ,L  ,1.            ])
B[7,0] = np.array([ R ,-R ,0. ,1./np.sqrt(2.)])
B[7,1] = np.array([ R ,-R ,L/2,1./np.sqrt(2.)])
B[7,2] = np.array([ R ,-R ,L  ,1./np.sqrt(2.)])
B[8,0] = np.array([ R , 0.,0. ,1.            ])
B[8,1] = np.array([ R , 0.,L/2,1.            ])
B[8,2] = np.array([ R , 0.,L  ,1.            ])

r = 10.

b = np.zeros((9,3,4))

b[:,:,0] = B[:,:,0]-(B[:,:,0]+r)*(1.-np.cos(B[:,:,2]/r))
b[:,:,1] = B[:,:,1]*1.
b[:,:,2] = (B[:,:,0]+r)*np.sin(B[:,:,2]/r)
b[:,:,3] = B[:,:,3]*1.

ref = np.array([-r,0.,0.])

for i in range(9):
    b1 = b[i,0,0:3]-ref
    b3 = b[i,2,0:3]-ref
    b1[1] = 0.
    b3[1] = 0.
    costheta = np.dot(b1,b3)/(np.linalg.norm(b1)*np.linalg.norm(b3))
    b[i,1,3] *= np.sqrt((1.+costheta)/2.)
    norm2 = np.linalg.norm(b1)/np.sqrt((1.+costheta)/2.)
    b2 = (b1+b3)/np.linalg.norm(b1+b3)*norm2
    coord2 = b[i,1,1]
    b[i,1,0:3] = b2+ref
    b[i,1,1] = coord2

x, y, F, J, lamb, N = Analysis(axi,aeta,azeta,p,q,B,b,Xi,Eta)

IEN = MeshDomain(nxi,neta,nzeta)

fnameref = 'flexion_ref'
exportVTU(fnameref,x,IEN,J,lamb,N)

exportVTU(f"def_{fnameref}", y, IEN, J, lamb, N)