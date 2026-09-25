module PlotsDyadTest

using Test: @testset

@testset "`Plots` as shipped in the Dyad distribution" begin
    include("./default_backend_test.jl")
    include("./gr_test.jl")
    include("./static_export_test.jl")
end

end
