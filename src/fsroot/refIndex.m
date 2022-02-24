function n = refIndex(lambda,material)

    % Computes refractive index of given material for given wavelength in
    % nm. If several wavelengths, computes the average value.

     lambda = lambda*1e-3; % Convert to um
    
    switch material
        case 'F.Silica'
            B1 = .6961663;
            B2 = .4079426;
            B3 = .8974794;
            C1 = .0684043;
            C2 = .1162414;
            C3 = 9.896161;
        case 'N-BK7 (SCHOTT)'
            B1 = 1.03961212;
            B2 = 0.231792344;
            B3 = 1.010469450;
            C1 = 0.00600069867;
            C2 = 0.0200179144;
            C3 = 103.5606530;
        case 'N-LASF9 (SCHOTT)'
            B1 = 2.00029547;
            B2 = .298926886;
            B3 = 1.80691843;
            C1 = .0121426017;
            C2 = .0538736236;
            C3 = 156.530829;
        case 'N-SF5 (SCHOTT)'
            B1 = 1.52481889;
            B2 = .187085527;
            B3 = 1.42729015;
            C1 = .011254756;
            C2 = .0588995392;
            C3 = 129.141675;
        otherwise
            disp('Unknown material(s).');
            n = 1;
            return;
    end
    
    N = 1 + B1*lambda.^2 ./ (lambda.^2 - C1) + ...
            B2*lambda.^2 ./ (lambda.^2 - C2) + ...
            B3*lambda.^2 ./ (lambda.^2 - C3);
    N = sqrt(N);
    
    n = mean(N);

end