function phi_step_modelA(phi, V, t, dt, lambda, r, g, stencil_bc, xstep, T, D)
    noise = sqrt(T * dt / xstep) * sampler(size(phi))
    d = length(size(phi))
    out = similar(phi)
    for x in stencil_bc
        out[x[1]] = (
            phi[x[1]] -
            D *
            dt *
            (
                -1.0 / (xstep^2) * (sum(phi[i] for i in x[2]) - 2 * d * phi[x[1]]) +
                g * phi[x[1]]^2 +
                r +
                lambda * V[1][x[1]]
            ) *
            phi[x[1]] + noise[x[1]]
        )
    end
    @. phi = out
end
