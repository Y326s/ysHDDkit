function s = util_num2yaml(x)
%NUM2YAML Convert number to YAML-friendly string.
% Keeps scientific notation when needed.

    if abs(x) >= 1e4 || (abs(x) > 0 && abs(x) < 1e-3)
        s = sprintf('%.12g', x);
    else
        s = sprintf('%.12f', x);
        s = regexprep(s, '0+$', '');
        s = regexprep(s, '\.$', '');
    end
end