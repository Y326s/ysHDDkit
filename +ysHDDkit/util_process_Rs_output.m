function [RsDataStrc_updated] = util_process_Rs_output(RsDataStrc)

    % Create H tensor in column-major order
    temp = [RsDataStrc.REAL_Hxx + 1i*RsDataStrc.IMAG_Hxx; RsDataStrc.REAL_Hxy + 1i*RsDataStrc.IMAG_Hxy; RsDataStrc.REAL_Hxz + 1i*RsDataStrc.IMAG_Hxz;...
            RsDataStrc.REAL_Hyx + 1i*RsDataStrc.IMAG_Hyx; RsDataStrc.REAL_Hyy + 1i*RsDataStrc.IMAG_Hyy; RsDataStrc.REAL_Hyz + 1i*RsDataStrc.IMAG_Hyz;...
            RsDataStrc.REAL_Hzx + 1i*RsDataStrc.IMAG_Hzx; RsDataStrc.REAL_Hzy + 1i*RsDataStrc.IMAG_Hzy; RsDataStrc.REAL_Hzz + 1i*RsDataStrc.IMAG_Hzz];
    
    % Transpose first two dimensions to create 'physical' H tensor:
    % Hxx Hxy Hxz
    % Hyx Hyy Hyz
    % Hzx Hzy Hzz
    H_tensor = permute( reshape(temp, 3, 3, []), [2,1,3] );

    % Save H tensor back to output struture
    RsDataStrc_updated = RsDataStrc;
    RsDataStrc_updated.H_tensor = H_tensor;

end