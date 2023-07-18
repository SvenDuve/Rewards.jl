using Rewards
using Documenter

DocMeta.setdocmeta!(Rewards, :DocTestSetup, :(using Rewards); recursive=true)

makedocs(;
    modules=[Rewards],
    authors="Sven Duve <svenduve@gmail.com> and contributors",
    repo="https://github.com/SvenDuve/Rewards.jl/blob/{commit}{path}#{line}",
    sitename="Rewards.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://SvenDuve.github.io/Rewards.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/SvenDuve/Rewards.jl",
    devbranch="main",
)
