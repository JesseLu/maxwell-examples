function [err] = check_A(params, E)

    % x = [E{1}(:); E{2}(:); E{3}(:)];
    omega = params{1};
    [A1, A2, mu, epsilon, b] = fds_matrices(params{1:5}, params{7});

    my_diag = @(z) spdiags(z(:), 0, numel(z), numel(z));
    A = A1 * my_diag(mu.^-1) * A2 - omega^2 * my_diag(epsilon);
    % norm(A1 * (mu.^-1 * (A2 * x)) - omega^2 * epsilon .* x - b)

    s_prim = params{2};
    s_dual = params{3};
   
    [spx, spy, spz] = ndgrid(s_prim{1}, s_prim{2}, s_prim{3});
    [sdx, sdy, sdz] = ndgrid(s_dual{1}, s_dual{2}, s_dual{3});

    s = [sdx(:).*spy(:).*spz(:); ...
        spx(:).*sdy(:).*spz(:); ...
        spx(:).*spy(:).*sdz(:)];

    S = my_diag(s);
 
    A_symm = S * A;

    z = S*A - (conj(S)*conj(A))';
    norm(z(:))

    
