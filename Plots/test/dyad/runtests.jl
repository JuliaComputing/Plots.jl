module PlotsDyadTest

using Test: @testset

@testset "`Plots` as shipped in the Dyad distribution" begin
    include("./animation_test.jl")
    include("./default_backend_test.jl")
    include("./gr_test.jl")
    include("./latexify_test.jl")
    include("./static_export_test.jl")
end

end
