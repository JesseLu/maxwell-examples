function [params, A_dagger_post] = A_dagger_pre(params)

    s_prim = params{2};
    s_dual = params{3};
    
    [spx, spy, spz] = ndgrid(s_prim{1}, s_prim{2}, s_prim{3});
    [sdx, sdy, sdz] = ndgrid(s_dual{1}, s_dual{2}, s_dual{3});

    S = {sdx.*spy.*spz, spx.*sdy.*spz, spx.*spy.*sdz};


    for k = 1 : 3
        params{7}{k} = conj(S{k}.^-1) .* params{7}{k};
    end

    params{1} = conj(params{1});
    for j = 2 : 6
        for k = 1 : 3
            params{j}{k} = conj(params{j}{k});
        end
    end

    A_dagger_post = @(E) my_post_fun(S, E);



function [E] = my_post_fun(S, E)
    for k = 1 : 3
        E{k} = conj(S{k}) .* E{k};
    end
    
