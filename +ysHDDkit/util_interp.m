function [F_query] = util_interp(G_query, G_ori, F_ori)



    dim1 = G_ori.dim1;   % horizontal axis, length 139
    dim2 = G_ori.dim2;   % vertical axis,   length 161

    F_query = interp2( ...
        dim1,dim2,...
        F_ori,...
        G_query.dim1,G_query.dim2);
    
end