module StaticExportTest

using Plots: Plots, plot, savefig
using Test: @test, @testset

function saved_bytes(extension)
    return mktempdir() do directory
        path = joinpath(directory, "plot.$extension")
        savefig(plot(1:3), path)
        return read(path)
    end
end

function test_saves_html()
    @test occursin("plotly", String(saved_bytes("html")))
    return nothing
end

function test_saves_pdf()
    @test startswith(String(saved_bytes("pdf")), "%PDF")
    return nothing
end

function test_saves_png()
    @test saved_bytes("png")[1:8] == [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]
    return nothing
end

function test_saves_svg()
    @test occursin("<svg", String(saved_bytes("svg")))
    return nothing
end

@testset "static export with the `plotly` backend" begin
    @testset "saves HTML" test_saves_html()
    @testset "saves PDF" test_saves_pdf()
    @testset "saves PNG" test_saves_png()
    @testset "saves SVG" test_saves_svg()
end

end
