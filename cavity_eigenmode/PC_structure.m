function [epsilon] = shifted_L3_structure (eps_slab, t_slab, lattice, radius, taper_params)
% Makes a cavity structure

    % Hard-coded constants.
    eps_air = 1.0;
    edge_len = 2.0;
    extra_pml_gap = 10;

    % Construct lattice parameters
    num_periods = taper_params(1);
    final_lattice = taper_params(2);
    a_taper = (final_lattice - lattice) / (num_periods^2); % Coefficient for parabolic taper.
    spacing = lattice + a_taper * ([-num_periods-1 : num_periods+1]).^2; % Parabolic spacing.


    % Position of holes.
    pos = cumsum(spacing) - sum(spacing)/2;
    pos = pos(1:end-1);

    % Make the slab.
    s{1} = [1 0 0 1e9 1e9 eps_slab];

    for xpos = pos(2:end-1)
        for ypos = pos(2:end-1)
            s{end+1} = [0 xpos ypos radius eps_air];
        end
    end

    % Obtain the 2D epsilon arrays.
    e = draw_structure(round(2*(pos(end) + extra_pml_gap)) * [1 1], s, edge_len);

    % === Now, make the 2D structure into a 3D structure. ===
    grid_size = [size(e{1}), 3*t_slab+2*extra_pml_gap];
    center = round(grid_size(3)/2);

    % Create the slab. Be careful of offsets in the Yee grid, and smoothing.
    offsets = [0 0 0.5];
    for k = 1 : 3
        z = offsets(k) + [1 : grid_size(3)];

        % Make the weighting function.
        w = (t_slab/2 - abs(z - center)) / edge_len;
        w = 1 * (w > 0.5) + (w+0.5) .* ((w>-0.5) & (w <= 0.5));
        % plot(w, '.-'); pause;

        % Apply the weighting function.
        epsilon{k} = zeros(grid_size);
        for m = 1 : grid_size(3)
            epsilon{k}(:,:,m) = (1-w(m)) * eps_air + w(m) * e{k};
        end
    end


%     % Use this to step through the slices of the structure, for verification.
%     for k = 1 : grid_size(3)
%         for cnt = 1 : 3
%             subplot (1, 3, cnt)
%             imagesc (epsilon{cnt}(:,:,k)', [1, 12.25]);
%             colormap('gray');
%             title(num2str(k));
%             set (gca, 'YDir', 'normal');
%             axis equal tight;
%         end
%         pause
%     end
