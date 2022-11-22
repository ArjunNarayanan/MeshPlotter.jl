function single_color_cmap(rgb::Vector{Float64})
    args = [(t, v, v) for t = 0.0:1.0, v in rgb]
    ColorMap("", args[:, 1], args[:, 2], args[:, 3])
end


function plot_mesh!(ax, points, connectivity; elem_color=[0.8, 1.0, 0.8],)
    ax.tripcolor(
        points[:, 1],
        points[:, 2],
        connectivity .- 1,
        0 * connectivity[:, 1],
        cmap=single_color_cmap(elem_color),
        edgecolors="k",
        linewidth=1,
        facecolor="g",
    )
end

function plot_node_numbers!(ax, points, fontsize; size=600)
    tpars = Dict(
        :color => "white",
        :horizontalalignment => "center",
        :verticalalignment => "center",
        :fontfamily => "sans-serif",
        :fontsize => fontsize,
    )
    ax.scatter(
        points[:, 1],
        points[:, 2],
        s=size,
        color="black",
        edgecolors="black"
    )
    for (idx, point) in enumerate(eachrow(points))
        ax.text(point[1], point[2], "$idx"; tpars...)
    end
end

function plot_elem_numbers!(ax, points, connectivity, fontsize)
    tpars = Dict(
        :color => "k",
        :horizontalalignment => "center",
        :verticalalignment => "center",
        :fontfamily => "sans-serif",
        :fontsize => fontsize,
    )
    npts = size(connectivity, 2)
    for (idx, nodes) in enumerate(eachrow(connectivity))
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

function plot_internal_order!(ax, points, connectivity, fontsize)
    tpars = Dict(
        :color => "r",
        :horizontalalignment => "center",
        :verticalalignment => "center",
        :fontsize => fontsize,
        :fontweight => "bold",
    )

    for (elem_id, conn) in enumerate(eachrow(connectivity))
        p = points[conn, :]
        plot_element_internal_order!(ax, p, tpars)
    end
end

function plot_vertex_score!(ax, points, vertex_score, fontsize, vertex_size)
    @assert length(vertex_score) == size(points, 1)

    neg_mask = vertex_score .< 0
    ax.scatter(points[neg_mask, 1], points[neg_mask, 2], s = vertex_size, color="r")

    pos_mask = vertex_score .> 0
    ax.scatter(points[pos_mask, 1], points[pos_mask, 2], s = vertex_size, color="m")

    tpars = Dict(
        :color => "w",
        :horizontalalignment => "center",
        :verticalalignment => "center",
        :fontsize => fontsize,
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
    number_vertices = false,
    number_elements = false,
    internal_order = false,
    figsize=15,
    fontsize = 20,
    elem_color=[0.8, 1.0, 0.8],
    vertex_size = 20)

    points = Array(points')
    connectivity = Array(connectivity')
    
    fig, ax = PyPlot.subplots(figsize=(figsize, figsize))

    ax.set_aspect("equal")
    ax.axis("off")

    plot_mesh!(ax, points, connectivity, elem_color = elem_color)

    if number_vertices
        plot_node_numbers!(ax, points, fontsize, size = vertex_size^2)
    end

    if number_elements
        plot_elem_numbers!(ax, points, connectivity, fontsize)
    end

    if internal_order
        plot_internal_order!(ax, points, connectivity, fontsize)
    end

    if length(vertex_score) > 0
        @assert length(vertex_score) == size(points, 1)
        plot_vertex_score!(ax, points, vertex_score, fontsize, vertex_size^2)
    end

    return fig
end
