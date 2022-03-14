function Φ_galerk_modelA(Φ::Array{ComplexF64}, V::Array{Float64},
    t::Float64, Δt::Float64, λ::Float64, r::ComplexF64, g::Float64, 
    k::Array{Float64,1}, Δx::Float64, T::Float64)
   ξ = sqrt(T * Δt / Δx) * 1.0/sqrt(2.0) * (sampler(size(Φ))+1im*sampler(size(Φ)))
   d = length(size(Φ))
   R = CartesianIndices(Φ)
   out = Array{Complex{Float64}}(undef, size(Φ))
   @. out = (Φ - 1im * Δt * (g * abs(Φ)^2 + r + λ * V) * Φ + ξ)
   out = fft(out)
   for I in R
       out[I] = 1.0 / (1.0 + Δt * 1im * sum([k[I[i]]^2 for i = 1:d])) * out[I]
   end
   out = ifft(out)
   @. Φ = out
end

