# -*- coding: utf-8 -*-

import numpy as np

def FindSpan(p,u,U):
    n = np.shape(U)[0]-p-2
    if u == U[n+1]:
        return n
    low = p
    high = n+1
    mid = int((low+high)/2)
    while (u < U[mid] or u >= U[mid+1]):
        if (u < U[mid]):
            high = mid
        else:
            low = mid
        mid = int((low+high)/2)
    return mid

def Bspline(u,p,U):
    i = FindSpan(p,u,U)
    n = 2
    ndu = np.zeros((p+1,p+1))
    ders = np.zeros((n+1,p+1))
    left = np.zeros(p+1)
    right = np.zeros(p+1)
    a = np.zeros((n+1,n+1))
    ndu[0,0] = 1.
    for j in range(1,p+1):
        left[j] = u-U[i+1-j]
        right[j] = U[i+j]-u
        saved = 0.
        for r in range(j):
            ndu[j,r] = right[r+1]+left[j-r]
            temp = ndu[r,j-1]/ndu[j,r]
            ndu[r,j] = saved+right[r+1]*temp
            saved = left[j-r]*temp
        ndu[j,j] = saved
    for j in range(p+1):
        ders[0,j] = ndu[j,p]*1.
    for r in range(p+1):
        s1 = 0
        s2 = 1
        a[0,0] = 1.
        for k in range(1,n+1):
            d = 0.
            rk = r-k
            pk = p-k
            if (r >= k):
                a[s2,0] = a[s1,0]/ndu[pk+1,rk]
                d = a[s2,0]*ndu[rk,pk]
            if (rk >= -1):
                j1 = 1
            else:
                j1 = -rk
            if (r-1 <= pk):
                j2 = k-1
            else:
                j2 = p-r
            for j in range(j1,j2+1):
                a[s2,j] = (a[s1,j]-a[s1,j-1])/ndu[pk+1,rk+j]
                d += a[s2,j]*ndu[rk+j,pk]
            if (r <= pk):
                a[s2,k] = -a[s1,k-1]/ndu[pk+1,r]
                d += a[s2,k]*ndu[r,pk]
            ders[k,r] = d
            j = s1
            s1 = s2
            s2 = j
    r = p
    for k in range(1,n+1):
        for j in range(p+1):
            ders[k,j] *= r
        r *= (p-k)
    N = ders[0]
    DN = ders[1]
    DDN = ders[2]
    return N, DN, DDN

def NURBSsurface(xi,eta,p,q,B,Xi,Eta):
    R = np.zeros((p+1,q+1))
    DR = np.zeros((p+1,q+1,2))
    DDR = np.zeros((p+1,q+1,3))
    sum_xi = sum_eta = sum_tot = 0
    sum_xixi = sum_xieta = sum_etaeta = 0
    ni = FindSpan(p,xi,Xi)
    nj = FindSpan(q,eta,Eta)
    N, DN, DDN = Bspline(xi,p,Xi)
    M, DM, DDM = Bspline(eta,q,Eta)
    for j in range(q+1):
        for i in range(p+1):
            R[p-i,q-j] = N[p-i]*M[q-j]*B[ni-i,nj-j,3]
            sum_tot += R[p-i,q-j]
            DR[p-i,q-j,0] = DN[p-i]*M[q-j]*B[ni-i,nj-j,3]
            sum_xi += DR[p-i,q-j,0]
            DR[p-i,q-j,1] = N[p-i]*DM[q-j]*B[ni-i,nj-j,3]
            sum_eta += DR[p-i,q-j,1]
            DDR[p-i,q-j,0] = DDN[p-i]*M[q-j]*B[ni-i,nj-j,3]
            sum_xixi += DDR[p-i,q-j,0]
            DDR[p-i,q-j,1] = DN[p-i]*DM[q-j]*B[ni-i,nj-j,3]
            sum_xieta += DDR[p-i,q-j,1]
            DDR[p-i,q-j,2] = N[p-i]*DDM[q-j]*B[ni-i,nj-j,3]
            sum_etaeta += DDR[p-i,q-j,2]
    for j in range(q+1):
        for i in range(p+1):
            R[p-i,q-j] = R[p-i,q-j]/sum_tot
            DR[p-i,q-j,0] = (DR[p-i,q-j,0]-R[p-i,q-j]*sum_xi)/sum_tot
            DR[p-i,q-j,1] = (DR[p-i,q-j,1]-R[p-i,q-j]*sum_eta)/sum_tot
            DDR[p-i,q-j,0] = (DDR[p-i,q-j,0]-2.*DR[p-i,q-j,0]*sum_xi-R[p-i,q-j]*sum_xixi)/sum_tot
            DDR[p-i,q-j,1] = (DDR[p-i,q-j,1]-DR[p-i,q-j,0]*sum_eta-DR[p-i,q-j,1]*sum_xi-R[p-i,q-j]*sum_xieta)/sum_tot
            DDR[p-i,q-j,2] = (DDR[p-i,q-j,2]-2.*DR[p-i,q-j,1]*sum_eta-R[p-i,q-j]*sum_etaeta)/sum_tot
    return R, DR, DDR

def Analysis(axi,aeta,azeta,p,q,B,b,Xi,Eta):
    nxi = np.shape(axi)[0]
    neta = np.shape(aeta)[0]
    nzeta = np.shape(azeta)[0]
    x = np.zeros((nxi*neta*nzeta,3))
    y = np.zeros((nxi*neta*nzeta,3))    
    F = np.zeros((nxi*neta*nzeta,3,3))
    J = np.zeros(nxi*neta*nzeta)
    lamb = np.zeros((nxi*neta*nzeta,3))
    Nlamb = np.zeros((nxi*neta*nzeta,3,3))

    G = np.zeros((nxi*neta*nzeta,3,3))
    g = np.zeros((nxi*neta*nzeta,3,3))

    A = 0
    for eta in aeta:
        for xi in axi:
            ni = FindSpan(p,xi,Xi)
            nj = FindSpan(q,eta,Eta)
            R, DR, DDR = NURBSsurface(xi,eta,p,q,B,Xi,Eta)
            r, Dr, DDr = NURBSsurface(xi,eta,p,q,b,Xi,Eta)
            xtemp = ytemp = 0.
            E1 = E2 = 0.
            e1 = e2 = 0.
            E1_xi = E1_eta = E2_xi = E2_eta = 0.
            e1_xi = e1_eta = e2_xi = e2_eta = 0.
            for j in range(q+1):
                for i in range(p+1):
                    xtemp += R[p-i,q-j]*B[ni-i,nj-j,0:3]
                    ytemp += r[p-i,q-j]*b[ni-i,nj-j,0:3]

                    # R[p-i,q-j] representa Ra
                    # DR[p-i,q-j,0] representa Ra_xi
                    # DR[p-i,q-j,1] representa Ra_eta
                    # DDR[p-i,q-j,0] representa Ra_xi,xi
                    # DDR[p-i,q-j,1] representa Ra_xi,eta
                    # DDR[p-i,q-j,2] representa Ra_eta,eta

                    E1 += DR[p-i,q-j,0]*B[ni-i,nj-j,0:3]
                    E2 += DR[p-i,q-j,1]*B[ni-i,nj-j,0:3]

                    # Definir: e1, e2
                    #          E1_xi, E1_eta, E2_xi, E2_eta
                    #          e1_xi, e1_eta, e2_xi, e2_eta
                    e1 += Dr[p-i,q-j,0]*b[ni-i,nj-j,0:3]
                    e2 += Dr[p-i,q-j,1]*b[ni-i,nj-j,0:3]

                    E1_xi += DDR[p-i,q-j,0]*B[ni-i,nj-j,0:3]
                    E2_xi += DDR[p-i,q-j,1]*B[ni-i,nj-j,0:3]
                    E1_eta += DDR[p-i,q-j,1]*B[ni-i,nj-j,0:3]
                    E2_eta += DDR[p-i,q-j,2]*B[ni-i,nj-j,0:3]

                    e1_xi += DDr[p-i,q-j,0]*b[ni-i,nj-j,0:3]
                    e2_xi += DDr[p-i,q-j,1]*b[ni-i,nj-j,0:3]
                    e1_eta += DDr[p-i,q-j,1]*b[ni-i,nj-j,0:3]
                    e2_eta += DDr[p-i,q-j,2]*b[ni-i,nj-j,0:3]

            NORM = np.linalg.norm(np.cross(E1,E2))
            N = np.cross(E1,E2)/NORM

            # Definir: n
            #          N_xi, N_eta
            #          n_xi, n_eta
            norm = np.linalg.norm(np.cross(e1,e2))
            n = np.cross(e1,e2)/norm

            aux_N_xi = np.cross(E1_xi, E2)+np.cross(E1, E2_xi)
            N_xi = (aux_N_xi - np.dot(aux_N_xi,N)*N) / NORM
            aux_N_eta = np.cross(E1_eta, E2)+np.cross(E1, E2_eta)
            N_eta = (aux_N_eta - np.dot(aux_N_eta,N)*N) / NORM

            aux_n_xi = np.cross(e1_xi, e2)+np.cross(e1, e2_xi)
            n_xi = (aux_n_xi - np.dot(aux_n_xi,n)*n) / norm
            aux_n_eta = np.cross(e1_eta, e2)+np.cross(e1, e2_eta)
            n_eta = (aux_n_eta - np.dot(aux_n_eta,n)*n) / norm

            for zeta in azeta:
                x[A] = xtemp+zeta*N


                # Definir: y
                #          G, g
                #          F, J, lamb
                y[A] = ytemp+zeta*n

                G[A] = np.column_stack((E1+zeta*N_xi, E2+zeta*N_eta, N))
                g[A] = np.column_stack((e1+zeta*n_xi, e2+zeta*n_eta, n))

                G_recip_A = np.linalg.inv(G[A])
                F[A] = g[A] @ G_recip_A
                J[A] = np.linalg.det(F[A])

                # Me rehuso a usar la ia para entender como se calculaban las direcciones principales segun el paper.

                A += 1

    return x, y, F, J, lamb, Nlamb

def MeshDomain(nxi,neta,nzeta):
    nel = nxi*(neta-1)*(nzeta-1)
    IEN = np.zeros((nel,8))
    e = A = a = 0
    for j in range(neta-1):
        a = A
        for i in range(nxi):
            for k in range(nzeta-1):
                IEN[e] = np.array([A,A+nzeta,A+nzeta+1,A+1,
                        A+nzeta*nxi,A+nzeta*(nxi+1),A+nzeta*(nxi+1)+1,A+nzeta*nxi+1])
                if (i == nxi-1):
                    IEN[e] = np.array([A,a,a+1,A+1,
                        A+nzeta*nxi,a+nzeta*nxi,a+nzeta*nxi+1,A+nzeta*nxi+1])
                    a += 1
                e += 1
                A += 1
            A += 1
    return IEN
