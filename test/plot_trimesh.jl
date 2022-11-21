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

MP.plot_mesh(mesh.p, mesh.t, node_numbers = true, elem_numbers=true)