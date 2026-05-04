function [Xr, Yr, Zr] = util_rotateX2Y_aboutZ(X, Y, Z, theta_deg, center)
% Rotate points clockwise about z-axis
% Coordinate convention:
% x -> right, y -> down, z -> into screen
%
% Inputs:
%   X, Y, Z   : 1 x n or n x 1 arrays
%   theta_deg    : clockwise rotation angle in degrees
%
% Outputs:
%   Xr, Yr, Zr : rotated coordinates


    % Rotation center
    C = [center(1); center(2); center(3)];


    % Force row vectors
    X = X(:).';
    Y = Y(:).';
    Z = Z(:).';

    theta = deg2rad(theta_deg);

    Rz_cw = [cos(theta), -sin(theta), 0;
             sin(theta),  cos(theta), 0;
             0         ,  0         , 1];

    P = [X; Y; Z];
    P_shift = P - C;  % Translate points so center becomes origin
    P_shift_rot = Rz_cw * P_shift;
    P_rot = P_shift_rot + C; % Translate back


    Xr = P_rot(1, :);
    Yr = P_rot(2, :);
    Zr = P_rot(3, :);
end