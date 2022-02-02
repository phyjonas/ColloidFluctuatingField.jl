mutable struct parameters
    Nt
    Δt
    L
    ɸ
    x
    ẋ
    parameter_ɸ
    para_x
    para_V
end


function solver(Nt, Δt, L, N, ɸ, x, ẋ, parameter_ɸ, para_x, 
                    para_V, ɸ_fct, x_fct, V_fct, times_save=reverse([i for i = 1:Nt]))
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
        ɸ_step(ɸ, V, i * Δt)
        if i == times_save[-1] # O(1) 
            ɸ_r[j] = deepcopy(ɸ)
            x_r[j] = deepcopy(x)
            ẋ_r[j] = deepcopy(ẋ)
            j += 1
            pop!(times_save) # O(1) 
        end
    end
    return ɸ_r, x_r, ẋ_r, parameters(Nt,Δt, L, ɸ, x, ẋ, parameter_ɸ, para_x, para_V)
end

if abspath(PROGRAM_FILE) == @__FILE__
    include("helper.jl")
 #   include("SGPE.jl")
    include("NewtonImp.jl")
    using BenchmarkTools
    ɸ = ones(100, 100) + 0im * ones(100, 100)
    V = [
        ones(100, 100) + 0im * ones(100, 100),
        ones(100, 100) + 0im * ones(100, 100),
        ones(100, 100) + 0im * ones(100, 100),
    ]
    xarray = [i for i in range(-5 / 2.0, 5 / 2.0, length = 100)]
    stencil_bc = tuple_stencil_bc(ɸ)
    Δt = 0.1
    lambda = 10.0
    m_b = 1.0
    mu = 0.1
    g = 1.0
    xstep = xarray[2] - xarray[1]
    T = 0.0
    M = 1.0
    re = 1.0
    parameter_ɸ = [lambda, m_b, mu, g, stencil_bc, xstep, T]
    para_x = [M, lambda, xstep]
    para_V = [re]
    N = 100
    L = 5.0
    x = [0.0, 0.0]
    ẋ = [0.0, 0.0]
end
