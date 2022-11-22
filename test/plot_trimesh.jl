using PyPlot
using Revise
using TriMeshGame
using MeshPlotter
TM = TriMeshGame
MP = MeshPlotter

points = [-1. 0.
           0. -1.
           1. 0.
           0. 1.]
connectivity = [1  2  4
                2  3  4]
mesh = TM.Mesh(Array(points'), Array(connectivity'))

MP.plot_mesh(TM.active_vertex_coordinates(mesh), TM.active_triangle_connectivity(mesh))