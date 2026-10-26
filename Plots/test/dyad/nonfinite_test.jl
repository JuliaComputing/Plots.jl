module NonfiniteTest

using Plots: Plots, hline!, plot
using Test: @test, @testset

# A horizontal line across several decades of a log axis extends to `x = [0, Inf]`.
function nonfinite_plot()
    return hline!(plot([1, 1.0e6], [1, 3]; xscale = :log10), [2])
end

function test_series_json_writes_null()
    json = Plots.plotly_series_json(nonfinite_plot())
    @test occursin("null", json)
    @test !occursin(r"Inf|NaN", json)
    return nothing
end

function test_html_and_plotly_json_render()
    plt = nonfinite_plot()
    @test occursin("Plotly.newPlot", repr(MIME("text/html"), plt))
    @test occursin("null", repr(MIME("application/vnd.plotly.v1+json"), plt))
    return nothing
end

@testset "non-finite values with the `plotly` backend" begin
    @testset "series JSON writes them as `null`" test_series_json_writes_null()
    @testset "HTML and plotly JSON render" test_html_and_plotly_json_render()
end

end
