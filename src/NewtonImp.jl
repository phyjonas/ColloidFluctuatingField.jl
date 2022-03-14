#Newtonian eqn for impurity
function NewtonImp(Φ::Array, V::Array{<:Array{Float64}},  M::Float64, λ::Float64, Δx::Float64)
    d = length(V)-1
    ans = zeros(d)
    for i = 1:d
        ans[i] =1.0 / M *  λ * sum(V[i+1] .* conj(Φ) .* Φ) * Δx
    end
    return ans
end 

