function SphLens(LensVector)
    % Plots spherical lens as defined by Lens = [R1 R2 D T x0]'.

    % Extract parameters
    R1  = LensVector(1);
    R2  = LensVector(2);
    D   = LensVector(3);
    T   = LensVector(4);
    x0  = LensVector(5);
    
    alpha1 = asin(.5*D/R1);
    alpha2 = asin(.5*D/-R2);
    
    % Define points
    V1B1 = R1*(1 - cos(alpha1));
    V1B2 = T + R2*(1 - cos(alpha2));

    % Angle intervals
    phi     = linspace(0,2*pi,50);
    theta1  = linspace(-alpha1,alpha1,50);
    theta2  = linspace(-alpha2,alpha2,50);
    
    % Create lens surfaces
    [PHI1,THETA1] = meshgrid(phi,theta1);

    X1 = x0 + R1*(1-cos(THETA1));
    Y1 = R1*sin(THETA1).*cos(PHI1);
    Z1 = R1*sin(THETA1).*sin(PHI1);

    [PHI2,THETA2] = meshgrid(phi,theta2);

    X2 = x0 + T + R2*(1-cos(THETA2));
    Y2 = -R2*sin(THETA2).*cos(PHI2);
    Z2 = -R2*sin(THETA2).*sin(PHI2);
    
    X = [X1 X2]; Y = [Y1 Y2]; Z = [Z1 Z2];

    % Create rims
    thetar1 = alpha1*ones(size(phi));

    xr1 = x0 + R1*(1-cos(thetar1));
    yr1 = R1*sin(thetar1).*cos(phi);
    zr1 = R1*sin(thetar1).*sin(phi);

    thetar2 = alpha2*ones(size(theta2));

    xr2 = x0 + T + R2*(1-cos(thetar2));
    yr2 = -R2*sin(thetar2).*cos(phi);
    zr2 = -R2*sin(thetar2).*sin(phi);

    % Create cylinder
    xcyl = x0 + linspace(V1B1,V1B2,50);
    [XCYL,PHICYL] = meshgrid(xcyl,phi);

    YCYL = .5*D*cos(PHICYL);
    ZCYL = .5*D*sin(PHICYL);

    % Plot lens surfaces
    surf(X,Y,Z,'FaceColor',[.71 1 1],'FaceAlpha',0.5,'EdgeColor','none');
    surf(XCYL,YCYL,ZCYL, ...
        'FaceColor',[.71 1 1],'FaceAlpha',0.7,'EdgeColor','none');

    % Plot rims
    plot3(xr1,yr1,zr1,'Color',[.4 1 1]);
    plot3(xr2,yr2,zr2,'Color',[.4 1 1]);

end