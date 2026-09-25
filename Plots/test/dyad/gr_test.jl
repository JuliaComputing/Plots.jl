module GRTest

using Plots: Plots, gr, plotly
using Test: @test, @testset

function test_is_not_a_dependency()
    @test Base.identify_package(Plots, "GR") === nothing
    return nothing
end

function test_points_to_installing_gr()
    error = try
        gr()
        nothing
    catch caught
        caught
    finally
        plotly()
    end
    @test error isa ArgumentError
    @test occursin("Pkg.add(\"GR\")", sprint(showerror, error))
    return nothing
end

@testset "`GR` backend" begin
    @testset "is not a dependency of `Plots`" test_is_not_a_dependency()
    @testset "points to installing `GR` when selected without it" test_points_to_installing_gr()
end

end
