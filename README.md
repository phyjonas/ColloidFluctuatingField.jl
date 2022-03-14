# ColloidFluctuatingField.jl

[![Build Status](https://github.com/phyjonas/ColloidFluctuatingField.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/phyjonas/ColloidFluctuatingField.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/phyjonas/ColloidFluctuatingField.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/phyjonas/ColloidFluctuatingField.jl)


## Simulating the dynamics of a colloid (impurity) inserted in a fluctuating field

This package aims to simulate the dynamics of a colloid in a fluctuating field. The package is designed to work in any dimension. The only provided methods are a Newtonian colloid and Model A for the fluctuating field. Over time more field theories and potentially different colloid dynamics will be added.

It is possible to provide costume functions for the field which will then be used to perform the time propagation. The impurity dynamics are constrained to Newtonian dynamics for now. Here we use Verlet integration to perform the time propagation.
# Table of Contents
1. [Functionality](#Functionality)
    1. [Arguments](#Arguments)
    2. [Output](#Output)
    3. [Parameter-struct](#Parameter-struct)
2. [Propagation functions and how to provide a costum function](#Propagation-functions)
    1. [Field](#Field)
    2. [Colloid](#Colloid)
    3. [Potential](#Potential)



## Functionality
The main function is

```julia
time_propagation(p, method_Φ, method_x, method_V, costum_Φ=nothing, costum_x=nothing, costum_V=nothing)
```
It performs the time propagation of the system and outputs the system configuration at the desired times.
### Arguments

- p ::para provides the parameters through a custom struct, details will be provided below; if one wants to use a custom function, use "custom"
- method_Φ::String function that propagates the field in time; currently implemented: Modele-Galerkin, if one wants to use a custom function, use "custom"
- method_x::String function that propagates the colloid in time; currently implemented: Newton, if one wants to use a custom function use "custom" method_V::String function that propagates the colloid in time; currently implemented: Gaussian, if one wants to use a custom function use "custom"
- costum_(Φ,x,V)::func optional if one wants to provide a custom function this will be done here
### Output

ɸ_r(x_r, ẋ_r) Array containing the system configurations at the desired times

### Parameter-struct

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
- Φ: Initial Field configuration
- x: Initial colloid position
- ẋ: Initial colloid velocity 
- para_(Φ,x,V): extra parameters provided to the function updating (Φ,x,V) these can contain any number of custom parameters
- times_save (optional) the time-steps when the configuration the the system is saved


## Propagation-functions

### Field

All functions have to be of the form (note that, for example even if not needed t still has to be supplied)

```Julia
f(Φ, V, t, Δt, para_Φ...)
```
- Φ: Array{Number} the current field configuration
- V: Array{Float64} the current potential (usually depends on x) but is updated automatically
- Δt: the time discretisation
- para_Φ: all extra parameter needed to perform a time-step 

#### Pre-implemented

**ModelA-Galerkin**

Spectral-Galerkin method to propagate the field 

para_Φ = [λ::Float64, r::Float64, g::Float64,  k::Array{Float64,1},Δx::Float64, T::Float64]

### Colloid

All functions have to be of the form 

```Julia
f(Φ, V, x, ẋ, Δt, para_x...)
```
- Φ::Array the current field configuration
- V::Array{<:Array{Float64}} current Potential, including its derivatives
- x::Array{Float64,1} current position of the colloid
- ẋ::Array{Float64,1} current velocity of the colloid
- Δt::Float64 the time discretisation
- para_x: all extra parameter needed to perform a time-step 

#### Pre-implemented

### Potential

All functions have to be of the form
```Julia
f(V, x, t, xarray, para_V...)
```


- V::Array{<:Array{Float64}} current potential
- x::Array current colloid position
- t::Float64 current time
- xarray::Array{Float64,1} space array (in any dimension we assume a square grid)
- para_V all extra parameter needed to perform a time-step 

#### Pre-implemented
**Gaussian**

Gaussian interaction potential; resets the size of the colloid.

para_V = [re::Float64, L::Float64]