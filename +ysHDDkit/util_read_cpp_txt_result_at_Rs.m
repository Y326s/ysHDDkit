function [data_struct] = util_read_cpp_txt_result_at_Rs(dir, filename)


    % =========================================================
    % User input
    % =========================================================
    % file = [dir filename];   % <-- replace with your file name
    file = fullfile(dir, filename);
    % =========================================================
    % 1. Open file and read header
    % =========================================================
    fid = fopen(file, 'r');
    if fid == -1
        error('Cannot open file.');
    end
    
    header_line = fgetl(fid);   % read header line
    
    % =========================================================
    % 2. Process header into valid MATLAB variable names
    % =========================================================
    % Split by whitespace
    headers = strsplit(strtrim(header_line));
    
    % Replace parentheses with underscore and remove ')'
    headers = strrep(headers, '(', '_');
    headers = strrep(headers, ')', '');
    
    % Ensure valid MATLAB variable names
    headers = matlab.lang.makeValidName(headers);
    
    % =========================================================
    % 3. Read numeric data
    % =========================================================
    % Read remaining numeric data
    data = fscanf(fid, '%f', [numel(headers), Inf]);
    
    fclose(fid);
    
    % Transpose to get rows = observations
    data = data';
    
    % =========================================================
    % 4. Assign each column to workspace variables (1×N)
    % =========================================================
    for i = 1:numel(headers)
        var_name = headers{i};
        assignin('base', var_name, data(:, i)');  % make 1×N row vector
    end
    
    % =========================================================
    % 5. Optional: store everything in a struct as well
    % =========================================================
    data_struct = struct();
    for i = 1:numel(headers)
        data_struct.(headers{i}) = data(:, i)';  % 1×N
    end
    
    disp('Data successfully loaded into workspace variables.');





end