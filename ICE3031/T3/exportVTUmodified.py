import numpy as np

def exportVTU(fname,xyz,IEN,J,lamb,N):
    VTUfile=open(fname+'.vtu',"w")
    VTUfile.write('<?xml version="1.0"?>\n')
    VTUfile.write('<VTKFile type="UnstructuredGrid" version="0.1">\n')
    VTUfile.write('<UnstructuredGrid>\n')
    VTUfile.write('<Piece NumberOfPoints="'+str(int(xyz.shape[0]))+'" NumberOfCells="'+str(int(IEN.shape[0]))+'">\n')
    
    VTUfile.write('\n')
    VTUfile.write('<Points>\n')
    VTUfile.write('<DataArray type="Float64" Name="nodes" NumberOfComponents=" 3" format="ascii">\n')
    
    #Points
    for i in np.arange(xyz.shape[0]):
        VTUfile.write(str(xyz[i,0])+' ')
        VTUfile.write(str(xyz[i,1])+' ')
        VTUfile.write(str(xyz[i,2])+' ')
    
    VTUfile.write('\n')
    VTUfile.write('</DataArray>\n')
    VTUfile.write('</Points>\n')
    
    VTUfile.write('\n')
    VTUfile.write('<Cells>\n')
    VTUfile.write('<DataArray type="Int32" Name="connectivity" NumberOfComponents=" 1" format="ascii">\n')
    
    #Elements connectivity
    for i in np.arange(IEN.shape[0]):
        VTUfile.write(str(int(IEN[i,0]))+' ')
        VTUfile.write(str(int(IEN[i,1]))+' ')
        VTUfile.write(str(int(IEN[i,2]))+' ')
        VTUfile.write(str(int(IEN[i,3]))+' ')
        VTUfile.write(str(int(IEN[i,4]))+' ')
        VTUfile.write(str(int(IEN[i,5]))+' ')
        VTUfile.write(str(int(IEN[i,6]))+' ')
        VTUfile.write(str(int(IEN[i,7]))+' ')
        
    VTUfile.write('\n')
    VTUfile.write('</DataArray>\n')
    VTUfile.write('<DataArray type="Int32" Name="offsets" NumberOfComponents=" 1" format="ascii">\n')
    
    #Offsets
    offset=IEN.shape[1]
    dn=offset
    for i in np.arange(IEN.shape[0]):
        VTUfile.write(str(int(offset))+' ')
        offset=offset+dn
    
    VTUfile.write('\n')
    VTUfile.write('</DataArray>\n')
    VTUfile.write('<DataArray type="UInt8" Name="types" NumberOfComponents=" 1" format="ascii">\n')
    
    #Types
    ###Cambiar el tipo de elemento, a un tetraedro (el 3 es una linea recta)
    for i in np.arange(IEN.shape[0]):
        VTUfile.write(str(int(12))+' ')
    
    VTUfile.write('\n')
    VTUfile.write('</DataArray>\n')
    VTUfile.write('</Cells>\n')
    VTUfile.write('<PointData>\n')
    VTUfile.write('<DataArray type="Float64" Name="J" NumberOfComponents=" 1" format="ascii">\n')
    
    #J = det(F)
    for i in np.arange(xyz.shape[0]):
        VTUfile.write(str(J[i])+' ')

    VTUfile.write('</DataArray>\n')
    
    VTUfile.write('<DataArray type="Float64" Name="lambda_1" NumberOfComponents=" 1" format="ascii">\n')
    
    #lambda_1
    for i in np.arange(xyz.shape[0]):
        VTUfile.write(str(lamb[i,0])+' ')

    VTUfile.write('</DataArray>\n')
    
    VTUfile.write('<DataArray type="Float64" Name="lambda_2" NumberOfComponents=" 1" format="ascii">\n')
    
    #lambda_2
    for i in np.arange(xyz.shape[0]):
        VTUfile.write(str(lamb[i,1])+' ')

    VTUfile.write('</DataArray>\n')
    
    VTUfile.write('<DataArray type="Float64" Name="lambda_3" NumberOfComponents=" 1" format="ascii">\n')
    
    #lambda_3
    for i in np.arange(xyz.shape[0]):
        VTUfile.write(str(lamb[i,2])+' ')

    VTUfile.write('</DataArray>\n')
    
    VTUfile.write('<DataArray type="Float64" Name="N_1" NumberOfComponents=" 3" format="ascii">\n')
    
    #N_1
    for i in np.arange(xyz.shape[0]):
        VTUfile.write(str(N[i,0,0])+' ')
        VTUfile.write(str(N[i,0,1])+' ')
        VTUfile.write(str(N[i,0,2])+' ')

    VTUfile.write('</DataArray>\n')
    
    VTUfile.write('<DataArray type="Float64" Name="N_2" NumberOfComponents=" 3" format="ascii">\n')
    
    #N_2
    for i in np.arange(xyz.shape[0]):
        VTUfile.write(str(N[i,1,0])+' ')
        VTUfile.write(str(N[i,1,1])+' ')
        VTUfile.write(str(N[i,1,2])+' ')

    VTUfile.write('</DataArray>\n')
    
    VTUfile.write('<DataArray type="Float64" Name="N_3" NumberOfComponents=" 3" format="ascii">\n')
    
    #N_3
    for i in np.arange(xyz.shape[0]):
        VTUfile.write(str(N[i,2,0])+' ')
        VTUfile.write(str(N[i,2,1])+' ')
        VTUfile.write(str(N[i,2,2])+' ')

    VTUfile.write('</DataArray>\n')
    VTUfile.write('</PointData>\n')

#    VTUfile.write('<CellData>\n')
#    VTUfile.write('<DataArray type="Float64" Name="N" NumberOfComponents=" 1" format="ascii">\n')
#    
#    #N
#    for i in np.arange(N.shape[0]):
#        VTUfile.write(str(N[i])+' ')
#    
#    VTUfile.write('\n')
#    VTUfile.write('</DataArray>\n')
#    
#    VTUfile.write('<DataArray type="Float64" Name="fu" NumberOfComponents=" 1" format="ascii">\n')
#    
#    #fu
#    for i in np.arange(fu.shape[0]):
#        VTUfile.write(str(fu[i])+' ')
#    
#    VTUfile.write('\n')
#    VTUfile.write('</DataArray>\n')
#    
#    VTUfile.write('</CellData>\n')
    VTUfile.write('</Piece>\n')
    VTUfile.write('</UnstructuredGrid>\n')
    VTUfile.write('</VTKFile>')
    
    VTUfile.close()
    
    return()