# Plots for the Dyad distribution

This branch is `Plots` v1 as the Dyad distribution ships it. It differs
from the upstream release it is based on in two ways:

- `plotly` is the only backend loaded by default, and it can export
  static images.
- The dependencies that bring restrictively licensed binaries into the
  distribution are optional, not required.

Each difference is its own commit. The commit message says what it
changes, why, how a user gets the feature back, and how to redo the
change on a newer upstream release. The first commit has no message
body, so its redo steps are under
[Moving to a newer upstream release](#moving-to-a-newer-upstream-release).
Tracked in JuliaComputing/dyad-studio#1063.

## Patches

| Commit subject | What changes for users | Dependencies it changes |
| --- | --- | --- |
| make plotly unconditional and disable other Plotly integrations | `plotly` needs no runtime loading, but loses static export | — |
| default to the `plotly` backend | `using Plots` selects `plotly`, not GR | — |
| restore static export for the `plotly` backend | PNG, PDF and SVG export through PlotlyKaleido | adds `PlotlyBase`, `PlotlyKaleido` and `Kaleido_jll` (headless Chromium) |
| make GR an optional backend | `gr()` needs `Pkg.add("GR")` | removes `GR`, `GR_jll`, Qt6, the X11 and input stack, GLFW, Cairo |
| make FFMPEG a weak dependency | encoding animations needs `Pkg.add("FFMPEG")` and `using FFMPEG` | removes `FFMPEG`, `FFMPEG_jll`, x264, x265, libfdk-aac |
| make Latexify an optional dependency | `pgfplotsx()` needs `Pkg.add("Latexify")` | removes `Latexify`, `Ghostscript_jll` |

Removing GR and FFMPEG only helps together: `GR_jll` itself depends on
`FFMPEG_jll`.

## Checking the branch

`Plots/test/dyad` is a small test environment without GR, FFMPEG or
Latexify. It checks the behavior listed above:

```sh
julia --project=Plots/test/dyad -e 'include("Plots/test/dyad/runtests.jl")'
```

The upstream test suite in `Plots/test` still installs GR, FFMPEG and
Latexify. Neither it nor the documentation in `docs`, which calls
`gr()`, builds animations and still calls GR the default, is kept
working on this branch.

## Moving to a newer upstream release

1. Rebase the patch commits onto the new upstream `Plots-v1.x.y` tag.
2. Where a commit conflicts, redo it by hand from the "Redo on rebase"
   steps in its message. For the first commit, which has none:
   - `Plots/src/Plots.jl`: `include("backends/plotly.jl")` right before
     `include("init.jl")`;
   - `Plots/src/init.jl`: only `include(_path(backend_name()))` when
     `backend_name() !== :plotly`;
   - `Plots/src/backends.jl`: define `_post_imports(::PlotlyBackend)`
     and `_initialize_backend(::PlotlyBackend)` as no-ops that return
     `nothing`, in place of upstream's definitions.
3. Run `Plots/test/dyad`.
4. Point the distribution at the rebased branch and check its license
   report: none of the packages the table lists as removed should be
   back.
