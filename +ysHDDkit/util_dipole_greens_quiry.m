function [Ex,Ey,Ez,E_magnitudes,Hx,Hy,Hz,H_magnitudes] = util_dipole_greens_quiry(quiry,src_info,model)

    format compact;
    format shortEng;
    mu0 = 4*pi*1e-7;
    ep0 = 8.8542*1e-12;
    
    
    
    
    Rx_all = quiry(1,:);
    Ry_all = quiry(2,:);
    Rz_all = quiry(3,:);  % Caution! +y corresponds to -z in 2.5D forward mesh
    
    if size(src_info.loc,1) == 1
        Tx_all = ones(size(Rx_all)) * src_info.loc(1);
        Ty_all = ones(size(Rx_all)) * src_info.loc(2); % Transmitter should always on  striking plane (y=0)
        Tz_all = ones(size(Rx_all)) * src_info.loc(3);
    else
        Tx_all = src_info.loc(1,:);
        Ty_all = src_info.loc(2,:);
        Tz_all = src_info.loc(3,:);  % Caution! +y corresponds to -z in 2.5D forward mesh
    end
    numAll = max(size(Rx_all));
    
    
    
    Ex = zeros(size(Rx_all));
    Ey = zeros(size(Rx_all));
    Ez = zeros(size(Rx_all));
    E_magnitudes = zeros(size(Rx_all));
    Hx = zeros(size(Rx_all));
    Hy = zeros(size(Rx_all));
    Hz = zeros(size(Rx_all));
    H_magnitudes = zeros(size(Rx_all));
    
    
    
    for idx = 1:numAll
        if mod(idx,100)==1
            idx
        end
        beds = max(size(model.zbed));
        obsPoint = [Rx_all(idx); Ry_all(idx); Rz_all(idx)];
        srcPoint = [Tx_all(idx); Ty_all(idx); Tz_all(idx)];
        Nodes = [srcPoint.'; obsPoint.']; % global coordinate of the nodes on the geometry surface 
        % Recalculate fields for the new observation point
        [GA, Kphi, Pz, GF, Kpsi, Qz, GEJ, GHJ, GEM, GHM] = ...
            mexLMGFCalculation_uni_with_subtraction(src_info.freq, srcPoint, obsPoint, ...
                                beds, model.zbed, model.ep, model.mu, model.sigma, ...
                                model.anis_ratio, model.nNodes, Nodes);
    
        % Process results
        GEJ_true = GEJ.';
        GHM_true = GHM.';
        GEM_true = -GHJ.';
        GHJ_true = -GEM.';
        % Store magnitudes or other metrics
        if src_info.type == 'J'
            E_field = GEJ_true*src_info.mag.';
            H_field = GHJ_true*src_info.mag.';
        elseif src_info.type=='M'
            E_field = GEM_true*src_info.mag.' .* (-1j*2*pi*src_info.freq*mu0);  % Edited 07292024, in order to be consistent with COMSOL M dipole expression
            H_field = GHM_true*src_info.mag.' .* (-1j*2*pi*src_info.freq*mu0);  % emw.iomega*mu0_const*dipole_magnitude*(-test(emw.curlEx)-test(emw.curlEy)-test(emw.curlEz))/sqrt(3)
            % E_field = GEM_true*src_info.mag.';
            % H_field = GHM_true*src_info.mag.';
        end
    
        Ex(idx) = E_field(1);
        Ey(idx) = E_field(2);
        Ez(idx) = E_field(3);
        E_magnitudes(idx) = norm(E_field);
        Hx(idx) = H_field(1);
        Hy(idx) = H_field(2);
        Hz(idx) = H_field(3);
        H_magnitudes(idx) = norm(H_field);
    end




end