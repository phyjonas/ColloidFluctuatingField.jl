#Newtonian eqn for impurity
function NewtonImp(Φ::Array, V::Array{<:Array{Float64}}, x::Float64, ẋ::Float64, 
    Δt::Float64, M::Float64, λ::Float64, Δx::Float64)
    for i = 1:length(x)
        ẋ[i] = ẋ[i] + real(Δt / M *  λ * sum(V[i+1] .* conj(Φ) .* Φ) * Δx)
        x[i] = x[i] + real(Δt * ẋ[i])
    end
end

