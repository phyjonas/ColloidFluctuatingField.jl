#Newtonian eqn for impurity
function NewtonImp(Φ, V, x, ẋ, Δt, M, λ, Δx)
    for i = 1:length(x)
        ẋ[i] = ẋ[i] + real(Δt / M *  λ * sum(V[i+1] .* conj(Φ) .* Φ) * Δx)
        x[i] = x[i] + real(Δt * ẋ[i])
    end
end


#if abspath(PROGRAM_FILE) == @__FILE__
#    include("helper.jl")
#    using BenchmarkTools
#    Φ = ones(100,100)+0im*ones(100,100)
#    V = [ones(100,100)+0im*ones(100,100),ones(100,100)+0im*ones(100,100),
#    ones(100,100)+0im*ones(100,100)]
#    xarray = [i for i in range(-5 / 2.0, 5 / 2.0, length = 100)]
#    V = V_fct(V, [0,0], 0, xarray, 1)
#    x = [0.0 ,0.0]
#    ẋ = [0.0, 0.0]
#    @btime NewtonImp(Φ, V, x, ẋ, 0.0, 0.1, 1.0, 1.0, 1.0)
#end
