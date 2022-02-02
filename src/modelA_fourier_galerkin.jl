function Φ_galerk_modelA(Φ, V, Δt, λ, r, g, k, Δx, T)
    ξ = sqrt(T * Δt / Δx) * sampler(size(Φ))
    d = length(size(Φ))
    R = CartesianIndices(Φ)
    out = similar(ɸ)
    @. out = (ɸ - Δt * (g * ɸ^2 + r + λ * V[1]) * ɸ + ξ)
    out = fft(out)
    for I in R
        out[I] = 1.0 / (1.0 + Δt * sum([k[I[i]]^2 for i = 1:d])) * out[I]
    end
    out = ifft(out)
    @. ɸ = real(out)
end

#t =0.0
#r = 0.1
#g = 0.0
#D = 1.0
#T = 1.0
#λ = 0.0
#@btime ɸ_galerk_modelA(ɸ, V, t, Δt, λ, r, g, k, Δx, T, D)
