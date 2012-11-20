function [A_dagger] = A_dagger_check(params, E);
    omega = params{1};
    [A1, A2, mu, epsilon, b] = fds_matrices(params{1:5}, params{7});

    my_diag = @(z) spdiags(z(:), 0, numel(z), numel(z));
    A = A1 * my_diag(mu.^-1) * A2 - omega^2 * my_diag(epsilon);


    x = [E{1}(:); E{2}(:); E{3}(:)];

    A_dagger = A';

    norm(A_dagger * x - b)
