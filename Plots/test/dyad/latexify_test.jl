module LatexifyTest

using Plots: Plots
using Test: @test, @testset

function test_is_not_a_dependency()
    @test Base.identify_package(Plots, "Latexify") === nothing
    return nothing
end

@testset "`Latexify`" begin
    @testset "is not a dependency of `Plots`" test_is_not_a_dependency()
end

end
