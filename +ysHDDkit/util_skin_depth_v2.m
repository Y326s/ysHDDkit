function [lambda, sd, induction] = util_skin_depth_v2(freq,epr,sig,r)
    in2m = 0.0254;
    mu0 = 4e-7*pi;
    ep0 = 8.8541878128e-12;
    omega = 2*pi*freq;
    sd = sqrt(2/(sig*omega*mu0));

    k = omega*sqrt(mu0*(ep0*epr-1j*sig/omega));
    beta = real(k);
    alpha = -1*imag(k);
    lambda = 2*pi/beta;

    induction = 2*pi*freq*mu0*(sig)*(r)^2;
    sig./(2*pi*freq*ep0*epr)

end