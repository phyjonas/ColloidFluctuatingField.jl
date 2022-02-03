# ColloidFluctuatingField

[![Build Status](https://github.com/phyjonas/ColloidFluctuatingField.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/phyjonas/ColloidFluctuatingField.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/phyjonas/ColloidFluctuatingField.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/phyjonas/ColloidFluctuatingField.jl)


## Simulating the dynamics of a colloide (impurity) inserted in a fluctuating field

The goal of this package is to simulate the dynamics of a colloide in a fluctuating field. The package is designed to work in any dimension. For now the only provided methods are a Newtonian colloide and Model A for the fluctuating field. Over time more field theories and potentially different colloide dynamics will be added.

It is possible to provide costume functions for the colloid, the field and the impurity which will then be used to perform the time propagation.

## Functionality
The main function is

```julia
time_propagation(p, method_Φ, method_x, method_V, costum_Φ=nothing, costum_x=nothing, costum_V=nothing)
```
It performs the time propagation of the system and outputs the system configuration at the desired times.
### Arguments

- p ::para provides the parameters through a costum struct, detials will be provided below, if one wants to use a costum function use "costum"
- method_Φ::String function that propagates the field in time; currently implemented: ModelA-Galerkin, if one wants to use a costum function use "costum"
- method_x::String function that propagates the colloid in time; currently implemented: Newton, if one wants to use a costum function use "costum"
method_V::String function that propagates the colloid in time; currently implemented: Gaussian, if one wants to use a costum function use "costum"
- costum_(Φ,x,V)::func optional if one wants to procide a costum function this will be done here

**Parameter stuct**

```julia
@with_kw struct para
    Nt::Int64
    Δt::Float64
    L::Float64
    N::Int64
    Φ::Array
    x::Array{Float64,1}
    ẋ::Array{Float64,1}
    para_Φ::Array
    para_x::Array
    para_V::Array
    times_save::Array{Int64,1}=reverse([i for i = 1:Nt])
end
```

- Nt: Number of time-steps
- Δt: length of one time step, i.e. time deiscrtisation
- L: Length of the system
- Φ: Initial Field configutation
- x: Initial colloid position
- ẋ: Initial colloid velocity 
- para_(Φ,x,V): extra parameters provided to the function updating (Φ,x,V) these can contain any number of costum parameters
- times_save (optional) the time-steps when the configuration the the system is saved


## Propagation functions and how to provide a costum function
