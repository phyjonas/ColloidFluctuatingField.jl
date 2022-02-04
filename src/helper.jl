function tuple_stencil(d::Int64)
    l = []
    for j = 1:d
        push!(l, CartesianIndex(tuple([i == j ? 1 : 0 for i = 1:d]...)))
        push!(l, CartesianIndex(tuple([i == j ? -1 : 0 for i = 1:d]...)))
    end
    return l
end

#assumes squre lattice
#non-periodic boundary
function laplacian(A::AbstractArray, d::Int64, stencil)
    out = zero(A)
    l = size(a)[1]
    @inbounds for I in R
        out[I] = (
            sum(all(x -> x > 0 && x < l, Tuple(I + s)) ? A[I+s] : 0 for s in stencil) -
            4 * A[I]
        )
    end
    return out
end

#square lattice
#PBC
function tuple_stencil_bc(A::AbstractArray)
    d = length(size(A))
    R = CartesianIndices(A)
    N = size(A)[1]
    stencil = []
    midpoint = []
    for I in R
        neighbours = []
        for j = 1:d
            push!(
                neighbours,
                CartesianIndex(tuple([
                    i == j ? (I[i] + 1 <= N ? I[i] + 1 : 1) : I[i] for i = 1:d
                ]...)),
            )
            push!(
                neighbours,
                CartesianIndex(tuple([
                    i == j ? (I[i] - 1 >= 1 ? I[i] - 1 : N) : I[i] for i = 1:d
                ]...)),
            )
        end
        push!(stencil, [n for n in neighbours]) #ugly list comprahension fixes type instability (fix this to be better code)
        push!(midpoint, I)
    end
    return zip([i for i in midpoint], [i for i in stencil])
    # fixes the type instability
    # rewrite this function
end

function sampler_complex(shape::Tuple)
    1 / sqrt(2.0) * (randn(shape) + 1im * randn(shape))
end

function sampler(shape::Tuple)
    randn(shape)
end

function V_gaussian(V::Array{<:Array{Float64}}, x::Array, t::Float64, xarray::Array{Float64,1}, 
                    re::Float64, L::Float64)
    R = CartesianIndices(V[1])
    d = length(size(V[1]))
    for I in R
        V[1][I] = exp(-sum((x[i] % L - xarray[I[i]])^2 / re^2 for i = 1:d)) / (re)^(d)
        for j = 2:length(V)
            V[j][I] =
                -2 * (xarray[I[j-1]] - x[j-1] % L) / re^(2+d) *
                exp(-sum((x[i] % L - xarray[I[i]])^2 / re for i = 1:d))
        end
    end
    return 1 / sqrt(pi) * V
end

function V_fct_pinned(V, x, t, xarray, re)
    R = CartesianIndices(V[1])
    d = length(size(V[1]))
    for I in R
        V[1][I] = (
            exp(-sum((x[i] - xarray[I[i]])^2 / (2*re^2) for i = 1:d)) / re +
            exp(-sum((-x[i] - xarray[I[i]])^2 / (2*re^2) for i = 1:d)) / re
        )
        for j = 2:length(V)
            V[j][I] = 0
        end
    end
    return 1 / sqrt(pi) * V
end

function observables(phi, x, xdot, t)
    []
end
