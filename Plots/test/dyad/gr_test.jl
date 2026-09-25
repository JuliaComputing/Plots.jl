module GRTest

using Plots: Plots, gr, plotly
using Test: @test, @test_throws, @testset

function test_does_not_load_gr()
    @test !any(package -> package.name == "GR", keys(Base.loaded_modules))
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
    @testset "is not loaded with `Plots`" test_does_not_load_gr()
    @testset "points to installing `GR` when selected without it" test_points_to_installing_gr()
end

end
