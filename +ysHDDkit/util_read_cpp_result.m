function [G_cpp, F_cpp] = util_read_cpp_result(dir, filename)


% =========================================================
% 1. Load the .mat file
% =========================================================
% dir = './field_mat/';
cppout = load(fullfile(dir, filename));

% =========================================================
% 2. Read grid coordinates
% =========================================================
X = squeeze(cppout.X);   % size: (nx, ny)
Z = squeeze(cppout.Z);   % size: (nx, ny)


%%
% =========================================================
% 3. Choose a field and one component
%    Example: E_field_real(:,:,:,1) = Ex
% =========================================================

load_Ereal = cppout.E_field_real_reshaped;   % size: (nx, ny, 1, 3)
load_Eimag = cppout.E_field_imag_reshaped;
load_Eabs = sqrt(load_Ereal.^2 + load_Eimag.^2);

load_Hreal = cppout.H_field_real_reshaped;   % size: (nx, ny, 1, 3)
load_Himag = cppout.H_field_imag_reshaped;
load_Habs = sqrt(load_Hreal.^2 + load_Himag.^2);

% permute(squeeze(load_Ereal(:, :, 1, :)), [2 1 3]);

F_cpp.Ereal = permute(squeeze(load_Ereal(:, :, 1, :)), [2 1 3]);
F_cpp.Eimag = permute(squeeze(load_Eimag(:, :, 1, :)), [2 1 3]);
F_cpp.Eabs = permute(squeeze(load_Eabs(:, :, 1, :)), [2 1 3]);
F_cpp.Hreal = permute(squeeze(load_Hreal(:, :, 1, :)), [2 1 3]);
F_cpp.Himag = permute(squeeze(load_Himag(:, :, 1, :)), [2 1 3]);
F_cpp.Habs = permute(squeeze(load_Habs(:, :, 1, :)), [2 1 3]);


G_cpp.dim1 = X.';
G_cpp.dim2 = Z.';


end
