function Φ_galerk_modelA(Φ::Array{Float64}, V::Array{Float64},
     t::Float64, Δt::Float64, λ::Float64, r::Float64, g::Float64, 
     k::Array{Float64,1}, Δx::Float64, T::Float64)
    ξ = sqrt(2 * T * Δt / Δx) * sampler(size(Φ))
    d = length(size(Φ))
    R = CartesianIndices(Φ)
    out = Array{Complex{Float64}}(undef, size(Φ))
    @. out = (Φ - Δt * (g * Φ^2 + r + 2 * λ * V) * Φ + ξ)
    out = fft(out)
    for I in R
        out[I] = 1.0 / (1.0 + Δt * sum([k[I[i]]^2 for i = 1:d])) * out[I]
    end
    #@. out = 1.0 / (1.0 + Δt * k^2) * out
    out = ifft(out)
    @. Φ = real(out)
end

