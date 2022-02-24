function [r,s] = LensTrace(r1,s1,LensVector,lambda,material)

    % Trace ray with given initial position r1 = [x y z], initial
    % directional unit vector s1 = [sx sy sz] and wavelength lambda,
    % through/past spherical lens defined by LensVector = [R1 R2 D T x0]
    % and material.
    
    R1  = LensVector(1);
    R2  = LensVector(2);
    D   = LensVector(3);
    T   = LensVector(4);
    x0  = LensVector(5);
    n   = refIndex(lambda,material);
    
    c1 = [x0+R1 0 0]';      % Center of left lens surface arc
    c2 = [x0+R2+T 0 0]';    % Center of right lens surface arc
    
    if R1 > 0   % First lens surface is convex
        % Length of first ray segment
        d1 = s1'*(c1-r1) - sqrt(R1^2 - (c1-r1)'*(c1-r1) + (s1'*(c1-r1))^2);
        % Position vector of first point of intersection
        r2 = r1+d1*s1;
        % Unit normal to lens surface at r2
        n1 = (c1-r2)/sqrt((c1-r2)'*(c1-r2));
    else        % First lens surface is concave
        % Length of first ray segment
        d1 = s1'*(c1-r1) + sqrt(R1^2 - (c1-r1)'*(c1-r1) + (s1'*(c1-r1))^2);
        % Position vector of first point of intersection
        r2 = r1+d1*s1;
        % Unit normal to lens surface at r2
        n1 = (r2-c1)/sqrt((r2-c1)'*(r2-c1));
    end
    
    if hitsLens(r2,D) == false % Ray does not hit first lens surface
        r = [r1 r1];
        s = [s1 s1];
        return;
    end 

    A = n1'*s1;
    % Unit vector in direction of second ray segment
    s2 = sqrt(1 - (1/n)^2*(1 - A^2))*n1 + (1/n)*(s1 - A*n1);
    
    if R2 > 0   % Second lens surface is convex
        % Length of second ray segment
        d2 = s2'*(c2-r2) - sqrt(R2^2 - (c2-r2)'*(c2-r2) + (s2'*(c2-r2))^2);
        % Position vector of second point of intersection
        r3 = r2+d2*s2;
        % Unit normal to lens surface at r3
        n2 = (c2-r3)/sqrt((c2-r3)'*(c2-r3));
    else        % Second lens surface is concave
        % Length of second ray segment
        d2 = s2'*(c2-r2) + sqrt(R2^2 - (c2-r2)'*(c2-r2) + (s2'*(c2-r2))^2);
        % Position vector of second point of intersection
        r3 = r2+d2*s2;
        % Unit normal to lens surface at r3
        n2 = (r3-c2)/sqrt((r3-c2)'*(r3-c2));
    end
    
    if hitsLens(r3,D) == false % Ray does not hit second lens surface
        r = [r2 r2];
        s = [s2 s2];
        return;
    end 

    B = n2'*s2;
    % Unit vector in direction of third ray segment
    s3 = sqrt(1 - (n/1)^2*(1 - B^2))*n2 + (n/1)*(s2 - B*n2);
    
    r = [r2 r3];
    s = [s2 s3];
    
end

function boolvar = hitsLens(r,D)

    % Checks if incoming ray actually intersects lens surface of lens with
    % diameter D at point r = [x y z]'. Returns 1 (true) or 0 (false).
    
    y = r(2);
    z = r(3);

    if abs(y)^2 + abs(z)^2 >= (.5*D)^2
        boolvar = 0;
    else
        boolvar = 1;
    end

end