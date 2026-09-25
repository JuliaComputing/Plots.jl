# Plots for the Dyad distribution

This branch is `Plots` v1 as the Dyad distribution ships it. It differs
from the upstream release it is based on in two ways:

- `plotly` is the only backend loaded by default, and it can export
  static images.
- The dependencies that bring restrictively licensed binaries into the
  distribution are optional, not required.

Each difference is its own commit. The commit message says what it
removes, why, how a user gets the feature back, and how to redo the
change on a newer upstream release. Tracked in
JuliaComputing/dyad-studio#1063.

## Patches

| Commit subject | What changes for users | Removes from the distribution |
| --- | --- | --- |
| make plotly unconditional and disable other Plotly integrations | `plotly` needs no runtime loading | — |
| default to the `plotly` backend | `using Plots` selects `plotly`, not GR | — |
| restore static export for the `plotly` backend | PNG, PDF, SVG and EPS export through PlotlyKaleido | — |
| make GR an optional backend | `gr()` needs `Pkg.add("GR")` | `GR`, `GR_jll`, Qt6, the X11 and input stack, GLFW, Cairo |
| make FFMPEG a weak dependency | encoding animations needs `Pkg.add("FFMPEG")` and `using FFMPEG` | `FFMPEG`, `FFMPEG_jll`, x264, x265, libfdk-aac |
| make Latexify an optional dependency | `pgfplotsx()` needs `Pkg.add("Latexify")` | `Latexify`, `Ghostscript_jll` |

Removing GR and FFMPEG only helps together: `GR_jll` itself depends on
`FFMPEG_jll`.

## Checking the branch

`Plots/test/dyad` is a small test environment without GR, FFMPEG or
Latexify. It checks the behavior listed above:

```sh
julia --project=Plots/test/dyad -e 'include("Plots/test/dyad/runtests.jl")'
```

The upstream test suite in `Plots/test` still installs GR, FFMPEG and
Latexify, and is not kept passing on this branch.

## Moving to a newer upstream release

1. Rebase the patch commits onto the new upstream `Plots-v1.x.y` tag.
2. Where a commit conflicts, redo it by hand from the "Redo on rebase"
   steps in its message.
3. Run `Plots/test/dyad`.
4. Point the distribution at the rebased branch and check its license
   report: none of the packages in the last column above should be
   back.
