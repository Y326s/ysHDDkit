function [G_COM, F_COM] = util_read_COMSOL_result(dir, filename,swp_idx1,swp_idx2)
    arguments
        dir
        filename
        swp_idx1 = 1
        swp_idx2 = 1
    end
   
ft2m = 0.3048;
% =========================================================
% 1. Load the .mat file
% =========================================================
% dir = './field_mat/';
comout = load([dir filename]);

% =========================================================
% 2. Read grid coordinates
% =========================================================
G_COM.dim1 = comout.RXXv * ft2m;   % size: (nx, ny)
G_COM.dim2 = comout.RZZv * ft2m;   % size: (nx, ny)


%%
% =========================================================
% 3. Choose a field and one component
%    Example: E_field_real(:,:,:,1) = Ex
% =========================================================


F_COM.Hx_pri1D = comout.results{swp_idx1*2-1,swp_idx2}(5,:);
F_COM.Hy_pri1D = comout.results{swp_idx1*2-1,swp_idx2}(6,:);
F_COM.Hz_pri1D = comout.results{swp_idx1*2-1,swp_idx2}(7,:);
F_COM.Hx_tot1D = comout.results{swp_idx1*2,swp_idx2}(5,:);
F_COM.Hy_tot1D = comout.results{swp_idx1*2,swp_idx2}(6,:);
F_COM.Hz_tot1D = comout.results{swp_idx1*2,swp_idx2}(7,:);
F_COM.Hx_sct1D = F_COM.Hx_tot1D - F_COM.Hx_pri1D;
F_COM.Hy_sct1D = F_COM.Hy_tot1D - F_COM.Hy_pri1D;
F_COM.Hz_sct1D = F_COM.Hz_tot1D - F_COM.Hz_pri1D;


F_COM.Hx_pri2D = reshape( comout.results2d_v{swp_idx1*2-1,swp_idx2}(5,:),  size(G_COM.dim1)).';
F_COM.Hy_pri2D = reshape( comout.results2d_v{swp_idx1*2-1,swp_idx2}(6,:),  size(G_COM.dim1)).';
F_COM.Hz_pri2D = reshape( comout.results2d_v{swp_idx1*2-1,swp_idx2}(7,:),  size(G_COM.dim1)).';
F_COM.Hx_tot2D = reshape( comout.results2d_v{swp_idx1*2,swp_idx2}(5,:),  size(G_COM.dim1)).';
F_COM.Hy_tot2D = reshape( comout.results2d_v{swp_idx1*2,swp_idx2}(6,:),  size(G_COM.dim1)).';
F_COM.Hz_tot2D = reshape( comout.results2d_v{swp_idx1*2,swp_idx2}(7,:),  size(G_COM.dim1)).';
F_COM.Hx_sct2D = F_COM.Hx_tot2D - F_COM.Hx_pri2D;
F_COM.Hy_sct2D = F_COM.Hy_tot2D - F_COM.Hy_pri2D;
F_COM.Hz_sct2D = F_COM.Hz_tot2D - F_COM.Hz_pri2D;



end