function s = util_num2str_for_filename(x)
%NUM2STR_FOR_FILENAME Safer numeric string for filenames.
% Example: -1.25e-3 -> m1p25e-03

    s = sprintf('%.6g', x);
    s = strrep(s, '-', 'm');
    s = strrep(s, '.', 'p');
    s = strrep(s, '+', '');
end