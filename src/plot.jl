function plot_mesh!(ax, m; d0 = m.d, vertex_score = true)
    ax.clear()
    ax.set_aspect("equal")
    ax.axis("off")
    ax.set_xlim(-1.1, 1.1)
    ax.set_ylim(-1.1, 1.1)

    ax.tripcolor(
        m.p[:, 1],
        m.p[:, 2],
        Array(m.t .- 1),
        0 * m.t[:, 1],
        cmap = "Set3",
        edgecolors = "k",
        linewidth = 1,
        facecolor = "g",
    )

    dd = m.d - d0
    tpars = Dict(
        :color => "w",
        #:fontfamily=>"sans-serif",
        :horizontalalignment => "center",
        :verticalalignment => "center",
        :fontsize => 12,
        :fontweight => "bold",
    )

    if vertex_score
        ax.scatter(m.p[dd.<0, 1], m.p[dd.<0, 2], 450, color = "r")
        ax.scatter(m.p[dd.>0, 1], m.p[dd.>0, 2], 450, color = "m")
        # ax.scatter(m.p[dd.==0, 1], m.p[dd.==0, 2], 450, color = "b")
        for i = 1:size(m.p, 1)
            if dd[i] != 0
                txt = string(dd[i])
                if dd[i] > 0
                    txt = "+" * txt
                end
                ax.text(m.p[i, 1], m.p[i, 2], txt; tpars...)
            end
        end
    end
end

function plot_mesh(m; d0 = m.d, vertex_score = true, figsize = 10, filename = "")
    fig, ax = PyPlot.subplots(figsize = (figsize, figsize))
    plot_mesh!(ax, m, d0 = d0, vertex_score = vertex_score)

    if length(filename) > 0
        fig.savefig(filename)
    end

    return fig, ax
end
