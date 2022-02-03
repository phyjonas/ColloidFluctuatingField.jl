# ColloidFluctuatingField

[![Build Status](https://github.com/phyjonas/ColloidFluctuatingField.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/phyjonas/ColloidFluctuatingField.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/phyjonas/ColloidFluctuatingField.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/phyjonas/ColloidFluctuatingField.jl)


## Simulating the dynamics of a colloide (impurity) inserted in a fluctuating field

The goal of this package is to simulate the dynamics of a colloide in a fluctuating field. The package is designed to work in any dimension. For now the only provided methods are a Newtonian colloide and Model A for the fluctuating field. Over time more field theories and potentially different colloide dynamics will be added.

It is possible to provide costume functions for the colloid, the field and the impurity which will then be used to perform the time propagation.

### Functionality
The main function is

```julia
time_propagation(p, method_Φ, method_x, method_V, costum_Φ, costum_x,costum_V)
