module AnimationTest

using Plots: Animation, gif
using Test: @test, @testset

function test_does_not_load_ffmpeg()
    @test !any(package -> package.name == "FFMPEG", keys(Base.loaded_modules))
    return nothing
end

function test_points_to_installing_ffmpeg()
    animation = Animation(mktempdir(), ["000001.png"])
    error = try
        gif(animation; show_msg = false)
        nothing
    catch caught
        caught
    end
    # Only the verdict goes into `@test`: a failure would otherwise print the
    # whole `ffmpeg` process environment.
    points_to_installing = occursin("Pkg.add(\"FFMPEG\")", sprint(showerror, error))
    @test points_to_installing
    return nothing
end

@testset "animations" begin
    @testset "do not load `FFMPEG` with `Plots`" test_does_not_load_ffmpeg()
    @testset "point to installing `FFMPEG` when encoding without it" test_points_to_installing_ffmpeg()
end

end
