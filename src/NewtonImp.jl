#Newtonian eqn for impurity
function NewtonImp(Φ::Array, V::Array{<:Array{Float64}}, x::Array{Float64,1}, ẋ::Array{Float64,1}, 
    Δt::Float64, M::Float64, λ::Float64, Δx::Float64)
    ans = zero(x)
    for i = 1:length(x)
        ans[i] =1.0 / M *  λ * sum(V[i+1] .* conj(Φ) .* Φ) * Δx
        ẋ[i] = ẋ[i] + real(Δt* ans[i])
        x[i] = x[i] + real(Δt * ẋ[i])
    end
    return ans
end 

