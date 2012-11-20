function [params, dagger_params] = sim_params(omega, epsilon)

    dims = size(epsilon{1});
    c = round(dims/2); % Center of the simulation.

    % PML factors.
    [d_prim, d_dual] = make_scpml(omega, dims, 10);

    % Create current source
    J = {zeros(dims), zeros(dims), zeros(dims)};
    % J{J_comp}(:,:,round(dims(3)/2)) = reshape(rand(dims(1), dims(2)), [dims(1), dims(2), 1]);
    J{2}(:,:,13) = 1;

    mu = {ones(dims), ones(dims), ones(dims)};
    E = {ones(dims), ones(dims), ones(dims)};

    params = {omega, d_prim, d_dual, mu, epsilon, E, J, 1e5, 1e-6};

    for k = 1 : 3
        d_prim{k} = conj(d_prim{k});
        d_dual{k} = conj(d_dual{k});
    end

    dagger_params = {omega, d_prim, d_dual, mu, epsilon, E, J, 1e5, 1e-6};
