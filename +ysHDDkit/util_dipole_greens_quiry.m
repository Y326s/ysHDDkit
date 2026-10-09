function [Ex,Ey,Ez,E_magnitudes,Hx,Hy,Hz,H_magnitudes] = util_dipole_greens_quiry(quiry,src_info,model,use_parallel)
% Evaluate dipole fields at the columns of a 3-by-N observation matrix.
% use_parallel: optional logical scalar (default false). True requires
% Parallel Computing Toolbox and uses a process pool for MEX isolation.
% Existing process pools are reused and left open for subsequent calls.

    if nargin < 4
        use_parallel = false;
    end
    validateattributes(use_parallel, {'logical'}, {'scalar'}, mfilename, 'use_parallel');
if use_parallel
    if ~license('test', 'Distrib_Computing_Toolbox') || isempty(ver('parallel'))
        error('ysHDDkit:ParallelToolboxRequired', ...
            'use_parallel=true requires Parallel Computing Toolbox.');
    end

    pool = gcp('nocreate');
    if isempty(pool)
        pool = parpool('Processes');
    end

    if ~isa(pool, 'parallel.ProcessPool')
        error('ysHDDkit:ProcessPoolRequired', ...
            'Close the existing thread pool and use a process-based pool.');
    end

    % Locate the parent directory containing +ysHDDkit.
    package_dir = fileparts(mfilename('fullpath'));
    toolkit_dir = fileparts(package_dir);

    % Each worker needs its own folder for MEX-generated log files.
    worker_root = fullfile(tempdir, 'ysHDDkit_workers');
    if ~isfolder(worker_root)
        mkdir(worker_root);
    end

    setup_job = parfevalOnAll(pool, @setup_green_worker, 0, ...
        worker_root, toolkit_dir);

    % Wait for every worker and propagate any setup error.
    fetchOutputs(setup_job);
end

    numAll = size(quiry, 2);
    if size(src_info.loc, 1) == 1
        source_points = repmat(src_info.loc(:), 1, numAll);
    else
        source_points = src_info.loc;
    end
    assert(isequal(size(source_points), [3 numAll]), ...
        'Source locations must be a 1-by-3 row or a 3-by-N matrix.');
    beds = numel(model.zbed);
    source_vector = src_info.mag.'; % Nonconjugating transpose
    if src_info.type == 'M'
        source_vector = source_vector .* (-1j*2*pi*src_info.freq*4*pi*1e-7);
    elseif src_info.type ~= 'J'
        error('ysHDDkit:InvalidSourceType', 'Source type must be J or M.');
    end

    fields = complex(zeros(6, numAll));
    if use_parallel
        parfor idx = 1:numAll
            fields(:,idx) = evaluate_point(quiry(:,idx), source_points(:,idx), ...
                src_info, model, beds, source_vector);
        end
    else
        for idx = 1:numAll
            fields(:,idx) = evaluate_point(quiry(:,idx), source_points(:,idx), ...
                src_info, model, beds, source_vector);
        end
    end
    Ex = fields(1,:); Ey = fields(2,:); Ez = fields(3,:);
    Hx = fields(4,:); Hy = fields(5,:); Hz = fields(6,:);
    E_magnitudes = sqrt(sum(abs(fields(1:3,:)).^2, 1));
    H_magnitudes = sqrt(sum(abs(fields(4:6,:)).^2, 1));
end

function field = evaluate_point(obsPoint, srcPoint, src_info, model, beds, source_vector)
    Nodes = [srcPoint.'; obsPoint.'];
    [~, ~, ~, ~, ~, ~, GEJ, GHJ, GEM, GHM] = ...
        ysHDDkit.mexLMGFCalculation_uni_with_subtraction(src_info.freq, srcPoint, obsPoint, ...
            beds, model.zbed, model.ep, model.mu, model.sigma, ...
            model.anis_ratio, model.nNodes, Nodes);
    if src_info.type == 'J'
        E_field = GEJ.' * source_vector;
        H_field = -GEM.' * source_vector;
    else
        % Preserve the existing Green-matrix signs and COMSOL M-dipole scaling.
        E_field = -GHJ.' * source_vector;
        H_field = GHM.' * source_vector;
    end
    field = [E_field; H_field];
end



function setup_green_worker(worker_root, toolkit_dir)
    % Persistent variables are private to each worker process.
    % Reuse the same folder on subsequent solver calls.
    persistent worker_dir

    addpath(toolkit_dir);

    if isempty(worker_dir) || ~isfolder(worker_dir)
        worker_dir = tempname(worker_root);
        [ok, message] = mkdir(worker_dir);
        if ~ok
            error('ysHDDkit:WorkerDirectoryFailed', ...
                'Cannot create worker directory: %s', message);
        end
    end

    cd(worker_dir);
end

