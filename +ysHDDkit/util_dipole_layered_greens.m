function [EMout] = util_dipole_layered_greens(Tx_info,model_info,quiry_pts,use_parallel)

    % Optional use_parallel defaults to false and is passed to the query helper.
    if nargin < 4
        use_parallel = false;
    end

    % Tx_info.freq
    % Tx_info.Tx
    % Tx_info.Tx_loc
    % 
    % model.zbed
    % model.ep
    % model.mu
    % model.sigma
    
    src = struct( ...
        'freq', Tx_info.freq, ... % frequency in Hz
        'type', 'M', ... %J or M
        'mag', Tx_info.Tx, ...  %  1j*omega*mu0 for M dipole
        'loc', Tx_info.Tx_loc ); % Dipole loction in feet
    
    % In EMPACK, artifical top and bottom interfaces should be added to avoid
    % error 
    model = struct( ...
        'zbed', model_info.zbed(:), ... % z axis of interfaces of layers from bottom to top
        'ep', model_info.ep(:), ...
        'mu', model_info.mu(:), ...
        'sigma', model_info.sigma(:),...
        'nNodes', 2, ...
        'anis_ratio', 1.0 );
    

    %% Calculate analytical EH soultion using Green's function on quiry points
    [EMout.Ex, EMout.Ey, EMout.Ez, EMout.E_magnitudes, EMout.Hx, EMout.Hy, EMout.Hz, EMout.H_magnitudes] = ...
        ysHDDkit.util_dipole_greens_quiry(quiry_pts,src,model,use_parallel);
    


end



