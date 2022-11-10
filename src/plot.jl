function plot_mesh!(ax, points, connectivity)
    connectivity = connectivity'
    ax.tripcolor(
        points[1, :],
        points[2, :],
        connectivity .- 1,
        0 * connectivity[:, 1],
        cmap="Set3",
        edgecolors="k",
        linewidth=1,
        facecolor="g",
    )
end

function plot_node_numbers!(ax, points; size=400)
    tpars = Dict(
        :color => "k",
        :horizontalalignment => "center",
        :verticalalignment => "center",
        :fontfamily => "sans-serif",
        :fontsize => 10,
    )
    ax.scatter(
        points[:, 1],
        points[:, 2],
        s=size,
        facecolors="white",
        edgecolors="black"
    )
    for (idx, point) in enumerate(eachrow(points))
        ax.text(point[1], point[2], "$idx"; tpars...)
    end
end

function plot_elem_numbers!(ax, points, connectivity)
    tpars = Dict(
        :color => "k",
        :horizontalalignment => "center",
        :verticalalignment => "center",
        :fontfamily => "sans-serif",
        :fontsize => 10,
    )
    for (idx, nodes) in enumerate(eachrow(connectivity))
        npts = size(connectivity, 2)
        pc = sum(points[nodes, :], dims=1) / npts
        ax.text(pc[1], pc[2], "$idx"; tpars...)
    end
end

function plot_element_internal_order!(ax, points, tpars; scale=0.25)
    npts = size(points, 1)
    centroid = sum(points, dims=1) / npts
    displacement = scale * (centroid .- points)
    coords = points + displacement

    for (idx, point) in enumerate(eachrow(coords))
        txt = string(idx)
        ax.text(point[1], point[2], txt; tpars...)
    end
end

function plot_internal_order!(ax, points, connectivity)
    tpars = Dict(
        :color => "r",
        :horizontalalignment => "center",
        :verticalalignment => "center",
        :fontsize => 12,
        :fontweight => "bold",
    )

    for (elem_id, conn) in enumerate(eachrow(connectivity))
        p = points[conn, :]
        plot_element_internal_order!(ax, p, tpars)
    end
end

function plot_vertex_score!(ax, points, vertex_score)
    @assert length(vertex_score) == size(points, 1)

    neg_mask = vertex_score .< 0
    ax.scatter(points[neg_mask, 1], points[neg_mask, 2], 450, color="r")

    pos_mask = vertex_score .> 0
    ax.scatter(points[pos_mask, 1], points[pos_mask, 2], 450, color="m")

    tpars = Dict(
        :color => "w",
        :horizontalalignment => "center",
        :verticalalignment => "center",
        :fontsize => 12,
        :fontweight => "bold",
    )


    for (i, point) in enumerate(eachrow(points))
        vs = vertex_score[i]
        if vs != 0
            txt = string(vs)
            if vs > 0
                txt = "+" * txt
            end
            ax.text(point[1], point[2], txt; tpars...)
        end
    end
end

function plot_mesh(points, connectivity; vertex_score=[],
    node_numbers = false,
    elem_numbers = false,
    internal_order = false,
    figsize=10,
    filename="")

    fig, ax = PyPlot.subplots(figsize=(figsize, figsize))

    ax.set_aspect("equal")
    ax.axis("off")

    plot_mesh!(ax, points, connectivity)

    if node_numbers
        plot_node_numbers!(ax, points)
    end

    if elem_numbers
        plot_elem_numbers!(ax, points, connectivity)
    end

    if internal_order
        plot_internal_order!(ax, points, connectivity)
    end

    if length(vertex_score) > 0
        plot_vertex_score!(ax, points, vertex_score)
    end

    if length(filename) > 0
        fig.savefig(filename)
    end

    return fig
end
