```@meta
CurrentModule = Rewards
```

# Rewards

Documentation for [Rewards](https://github.com/SvenDuve/Rewards.jl).

Rewards.jl is required internally only. It provides the correct reward shaping to be used by the MPC unit in the MBRL.jl Package. Since the planning unit has no access to the actual environment, it is neccessary to emit deterministic rewards from the model. 

## Installation

In the julia REPL, run

```julia
using Pkg
Pkg.add(url="https://github.com/SvenDuve/Rewards.jl")
```

Bring package into scope with ( not required ):

```julia
using Rewards
```


## Function Reference

```@index
```

```@autodocs
Modules = [Rewards]
```
