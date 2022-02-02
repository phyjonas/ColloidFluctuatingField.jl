#Newtonian eqn for impurity
function NewtonImp(Φ, V, x, ẋ, Δt, M, λ, Δx)
    for i = 1:length(x)
        ẋ[i] = ẋ[i] + real(Δt / M *  λ * sum(V[i+1] .* conj(Φ) .* Φ) * Δx)
        x[i] = x[i] + real(Δt * ẋ[i])
    end
end

