using Revise
using MeshPlotter
MP = MeshPlotter

points = [
    0.0 1.0 2.0
    0.0 1.0 0.0
]

connectivity = [
    1
    3
    2
]

fig, ax = MP.plot_mesh(points, connectivity, number_vertices=true)
fig

# node_numbers = 1:3
# @assert size(points, 2) == length(node_numbers)
# MP.plot_node_numbers!(ax, points', node_numbers, 10)
# fig

