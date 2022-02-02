__precompile__

@everywhere module ColloidFluctuatingField

using FFTW
using Random

include("helper.jl")
include("modelA_fourier_galerkin.jl")
include("NewtonImp.jl")
include("solver.jl")

function time_propagation()
    # code
    return nothing
end


end
