__precompile__

module ColloidFluctuatingField
export time_propagation, para
using FFTW
using Random
using Parameters

include("helper.jl")
include("modelA_fourier_galerkin.jl")
include("NewtonImp.jl")
include("solver.jl")
include("driven_cond.jl")

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

function check_method(method::String, dic::Dict, st::String)
    if haskey(dic,method)
        ans = dic[method]
        if ans === nothing
            error("Please provide costum method for time propagation of" *st)
        end 
    else 
        error("Method not found for "*st)
    end
    return ans
end


function time_propagation(p::para, method_Φ::String, 
    method_x::String, method_V::String, custom_Φ = nothing, custom_x = nothing, 
    custom_V = nothing)
    Φ_methods = Dict("ModelA-Galerkin" =>Φ_galerk_modelA, 
                    "Driven-Condensate" => Φ_galerk_driven_cond, "custom" => custom_Φ)
    x_methods = Dict("Newton"=> NewtonImp, "custom" =>custom_x)
    V_methods = Dict("Gaussian" => V_gaussian, "custom" =>custom_V)
    ɸ_fct = check_method(method_Φ, Φ_methods,"Φ")
    V_fct = check_method(method_V, V_methods,"V")
    x_fct = check_method(method_x, x_methods, "x")
    @unpack Nt, Δt, L, N, Φ, x, ẋ, para_Φ, para_x, para_V, times_save = p 
    ɸ_r, x_r, ẋ_r, ẍ_r = solver(Nt, Δt, L, N, Φ, x, ẋ, para_Φ, para_x, para_V, ɸ_fct, x_fct, V_fct, times_save)    
    return ɸ_r, x_r, ẋ_r, ẍ_r, p
end


end
