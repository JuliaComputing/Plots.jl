module LatexifyTest

using Plots: Plots, pgfplotsx, plotly
using Test: @test, @testset

function test_is_not_a_dependency()
    @test Base.identify_package(Plots, "Latexify") === nothing
    return nothing
end

function test_pgfplotsx_points_to_installing_latexify()
    error = try
        pgfplotsx()
        nothing
    catch caught
        caught
    finally
        plotly()
    end
    @test error isa ArgumentError
    @test occursin("Pkg.add(\"Latexify\")", sprint(showerror, error))
    return nothing
end

@testset "`Latexify`" begin
    @testset "is not a dependency of `Plots`" test_is_not_a_dependency()
    @testset "`pgfplotsx` points to installing `Latexify` without it" test_pgfplotsx_points_to_installing_latexify()
end

end
