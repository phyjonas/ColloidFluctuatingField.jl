function solver(Nt::Int , Δt::Float64, L::Float64, N::Int, ɸ::Array, x::Array{Float64,1}, ẋ::Array{Float64,1}, 
    parameter_ɸ, para_x, para_V, ɸ_fct::Function, x_fct::Function, V_fct::Function, times_save=reverse([i for i = 1:Nt]))
    V = [zero(ɸ) for _ = 1:length(size(ɸ))+1]
    xarray = [i for i in range(-L / 2.0, L / 2.0, length = N)]
    update_V = ((V, x, t) -> V_fct(V, x, t, xarray, para_V...))
    ɸ_step = ((ɸ, V, t) -> ɸ_fct(ɸ, V, t, Δt, parameter_ɸ...))
    x_step = (
        (ɸ, V, x, xdot, t) ->
            x_fct(ɸ, V, x, xdot, t, Δt, para_x...)
    )
    ɸ_r = [zero(ɸ) for _ = 1:length(times_save)]
    x_r = [zero(x) for _ = 1:length(times_save)]
    ẋ_r = [zero(ẋ) for _ = 1:length(times_save)]
    j = 1
    for i = 1:Nt
        update_V(V, x, i * Δt)
        x_step(ɸ, V, x, ẋ, i * Δt)
        ɸ_step(ɸ, V[1], i * Δt)
        if i == times_save[-1] # O(1) 
            ɸ_r[j] = deepcopy(ɸ)
            x_r[j] = deepcopy(x)
            ẋ_r[j] = deepcopy(ẋ)
            j += 1
            pop!(times_save) # O(1) 
        end
    end
    return ɸ_r, x_r, ẋ_r
end


