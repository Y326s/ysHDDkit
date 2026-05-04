function util_write_TR_file(dir, filename, TRconfig)

    % ft2m = 0.3048;
    % in2m = ft2m/12;
    % m2ft = 1/ft2m;
    % [TRconfig.rx_x, TRconfig.rx_y, TRconfig.rx_z] = util_rotateX2Y_aboutZ(TRconfig.rx_x, TRconfig.rx_y, TRconfig.rx_z, 0, [TRconfig.tx_x(1),TRconfig.tx_y(1),TRconfig.tx_z(1)]);
  

    % =========================================================
    % Each column of TR file is stored as a 1D MATLAB vector
    % Check input sizes
    % =========================================================
    if ~(numel(TRconfig.tx_y)==TRconfig.nTx && numel(TRconfig.tx_z)==TRconfig.nTx && numel(TRconfig.tx_p)==TRconfig.nTx)
        error('Transmitter vectors must all have the same length.');
    end

    if ~(numel(TRconfig.rx_x)==TRconfig.nRx && numel(TRconfig.rx_y)==TRconfig.nRx && numel(TRconfig.rx_z)==TRconfig.nRx)
        error('Receiver vectors must all have the same length.');
    end

    % =========================================================
    % Open output file
    % =========================================================
    file = fullfile(dir, filename);
    fid = fopen(file, 'w');

    if fid == -1
        error('Cannot open file for writing: %s', filename);
    end

    % =========================================================
    % Write transmitters section
    % =========================================================
    fprintf(fid, '# transmitters\n');
    fprintf(fid, '%d\n', TRconfig.nTx);
    for i = 1:TRconfig.nTx
        fprintf(fid, '%.6g %.6g %.6g %.6g\n', TRconfig.tx_x(i), TRconfig.tx_y(i), TRconfig.tx_z(i), TRconfig.tx_p(i));
    end
    fprintf(fid, '\n');
    
    % =========================================================
    % Write receivers section
    % =========================================================
    fprintf(fid, '# receivers\n');
    fprintf(fid, '%d\n', TRconfig.nRx);
    for i = 1:TRconfig.nRx
        fprintf(fid, '%.6g %.6g %.6g\n', TRconfig.rx_x(i), TRconfig.rx_y(i), TRconfig.rx_z(i));
    end
    
    % =========================================================
    % Close file
    % =========================================================
    fclose(fid);
    
    disp(['File written: ', filename]);





end