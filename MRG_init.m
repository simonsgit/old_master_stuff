function [U_y_init,U_ordering,U_params,activ_params,flux_params] = MRG_init(t,naxons)
    [U_axon, U_ordering, U_params] = AxonNode_Compart_init(t);
    
    if naxons > 1
        add_axon = horzcat(repmat([0;-80;0;0;0;0],1,10),U_axon);
        U_y_init = horzcat(U_axon,repmat(add_axon,1,naxons-1));
        
        % calculate flux parameters
        Ra_n = 7e5;
        Ra_m = 7e5 * (10/3.3)^2;
        Ra_f = 7e5 * (10/6.9)^2;
        Ra_s = 7e5 * (10/6.9)^2;
        Ra = [Ra_n;Ra_m;Ra_f;Ra_s;Ra_s;Ra_s;Ra_s;Ra_s;Ra_s;Ra_f;Ra_m;Ra_n;Ra_m];
        l_n = 1;
        l_m = 3;
        l_f = 46;
        l_s = (1150-1-(2*3)-(2*46))/6;
        l = [l_n;l_m;l_f;l_s;l_s;l_s;l_s;l_s;l_s;l_f;l_m;l_n;l_m];
        d_n = 3.3;
        d_i = 10;
        d = [d_n;d_i;d_i;d_i;d_i;d_i;d_i;d_i;d_i;d_i;d_i;d_n;d_i];
        c_n = 2e-8;
        c_m = 2e-8 * (3.3/10);
        c_f = 2e-8 * (6.9/10);
        c_s = 2e-8 * (6.9/10);
        de = d + [0.004;0.004;0.008;0.008;0.008;0.008;0.008;0.008;0.008;0.008;0.004;0.004;0.004]; 
        cm = [c_n;c_m;c_f;c_s;c_s;c_s;c_s;c_s;c_s;c_f;c_m;c_n;c_m];
        ce = 1e-9 .*[1;1;1;1;1;1;1;1;1;1;1;1;1]./240;
        itaus = 1e-3.*(2*l).^2 .*Ra .*cm./d;
        itaus = vertcat(itaus, repmat(itaus(3:end),naxons-2,1));
        %itaus = repmat((1e-3.*(2*l).^2 .*Ra .*de .* ce.*cm)./(d.*(d.*cm+de.*ce)),naxons-1,1);
        etaus = (1e-3.*(2*l).^2 .*Ra_n .*ce.*de)./(de.^2-d.^2);
        etaus = vertcat(etaus,repmat(etaus(3:end),naxons-2,1));
        flux_params = struct();
        flux_params.int_taus = itaus;
        flux_params.ext_taus = etaus;
        
    else
        U_y_init = U_axon;
        flux_params = 0;
    end
    % set activation parameters
    activ_params = struct();
    Cm = 2;
    activ_params.Cm = Cm;
    g_L = 20;
    activ_params.g_L = g_L;
    offset = 1;
    activ_params.offset = offset;
    bcl = 1000;
    activ_params.bcl = bcl;
    duration = 0.1;
    activ_params.duration = duration;
    strength = 2000;
    activ_params.strength = strength;
    
end