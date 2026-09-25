module DefaultBackendTest

using Plots: Plots
using Test: @test, @testset

function test_selects_plotly_without_explicit_call()
    @test Plots.backend_name() === :plotly
    return nothing
end

@testset "default backend" begin
    @testset "is `plotly` without calling `plotly()`" test_selects_plotly_without_explicit_call()
end

end
