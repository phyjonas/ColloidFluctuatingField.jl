function Φ_galerk_driven_cond(Φ::Array{ComplexF64}, V::Array{Float64},
    t::Float64, Δt::Float64, λ::Float64, r::ComplexF64, g::Float64, 
    k::Array{Float64,1}, Δx::Float64, T::Float64,K::ComplexF64)
   ξ = sqrt(T * Δt / (2 * Δx)) * (sampler(size(Φ))+1im*sampler(size(Φ)))
   d = length(size(Φ))
   R = CartesianIndices(Φ)
   out = Array{Complex{Float64}}(undef, size(Φ))
   @. out = (Φ -  Δt * (g * abs(Φ)^2 + r + λ * V) * Φ + ξ)
   out = fft(out)
   for I in R
       out[I] = 1.0 / (1.0 + Δt * sum([K*k[I[i]]^2 for i = 1:d])) * out[I]
   end
   out = ifft(out)
   @. Φ = out
end

