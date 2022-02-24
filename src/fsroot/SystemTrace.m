function [R,S] = SystemTrace(LensMatrix,MaterialArray,ObjectMatrix,...
    RayVector,WaveVector,Aperture,SystemView,TraceType)

    % Traces rays defined by 
    % RayVector = [N1 N2 N3 ...]' (rays per layer) and
    % WaveVector [lambda1 lambda2 ...]', from points in
    % ObjectMatrix = [Object1 Object2 ...] through lens system defined by 
    % LensMatrix = [Lens1 Lens2 ...], 
    % MaterialArray = {'Material1', 'Material2',...},
    % Aperture (diameter) and
    % SystemView = [x1 x2; y1 y2; z1 z2].
    % Returns 5D arrays containing coordinates and directional cosines for
    % every ray. Tracetypes are 'Normal' and 'Reverse' (image at infinity).
    
    if strcmp(TraceType,'Reverse')
        % Mirror lens system in x
        LensMatrix(5,:) = -1*LensMatrix(5,:) - LensMatrix(4,:);
        LensMatrix(1:2,:) = -1*flip(LensMatrix(1:2,:),1);
        MaterialArray = flip(MaterialArray);
        % Sort Lenses by position
        LensMatrix = sortrows(LensMatrix',5)';
        % Set single object point at -Inf
        ObjectMatrix = [-1e6 0 0]';
    end
    
    % Declaration:
    Lenses = size(LensMatrix,2);
    TotalRays = sum(RayVector);
    PtsPerRay = 2+2*Lenses; % Start + End + 2 per lens
    LayersPerWavelength = length(RayVector);
    Wavelengths = length(WaveVector);
    ObjectPoints = size(ObjectMatrix,2);
    
    % Allocation:
    % R = (coordinates per point) x (points per ray) x (number of rays) x
    % (number of wavelengths) x (number of object points)
    % S = (cosines per point) x (points per ray) x (number of rays) x
    % (number of wavelengths) x (number of object points)
    R = zeros(3,PtsPerRay,TotalRays,Wavelengths,ObjectPoints);
    S = R;
    
    % Compute ray data
    for w = 1:ObjectPoints % object point w
        
        ObjectPoint = ObjectMatrix(:,w);
        
        for q = 1:Wavelengths % wavelength q

            m = 1; % Array ray index

            for i = 1:LayersPerWavelength % layer i

                % Adjust aperture
                if LayersPerWavelength == 1
                    AdjAperture = 0;
                else
                    AdjAperture = (i-1)*Aperture/(LayersPerWavelength-1);
                end

                % Set number of rays in current layer
                RaysInLayer = RayVector(i);

                for j = 1:RaysInLayer % ray j

                    % Define intial ray parameters
                    theta = 2*pi*(1-j/RaysInLayer);
                    % Point where ray passes through aperture
                    p = [LensMatrix(5,1); .5*AdjAperture*sin(theta); ...
                        .5*AdjAperture*cos(theta)];
                    r = ObjectPoint;     % Initial position vector
                    s = (p-r)/norm(p-r); % Initial direction unit vector
                    
                    % Store in arrays
                    R(:,1,m,q,w) = r;
                    S(:,1,m,q,w) = s;

                    for k = 1:Lenses % lens k

                        % Trace ray through lens
                        [rtemp,stemp] = LensTrace(r,s,LensMatrix(:,k), ...
                            WaveVector(q),char(MaterialArray(k)));

                        % Store coordinates/cosines in arrays
                        R(:,2*k:2*k+1,m,q,w) = rtemp;
                        S(:,2*k:2*k+1,m,q,w) = stemp;

                        % Define initial conditions for next lens trace
                        r = rtemp(:,2);
                        s = stemp(:,2);

                    end

                    % Compute and add final position
                    if SystemView(1,2) > ...
                            LensMatrix(5,Lenses) + LensMatrix(4,Lenses)

                        xp0 = SystemView(1,2);
                    else
                        xp0 = LensMatrix(5,Lenses) + ...
                            40*LensMatrix(4,Lenses);
                    end

                    rx = R(1,2*k+1,m,q,w);
                    sx = S(1,2*k+1,m,q,w);
                    d = (xp0 - rx)/sx;

                    R(:,2*k+2,m,q,w) = ...
                        R(:,2*k+1,m,q,w) + d*S(:,2*k+1,m,q,w);

                    % Update array ray index
                    m = m+1;

                end
            end
        end
    end
    
    if strcmp(TraceType,'Reverse')
       % Mirror rays in x 
       R(1,:,:,:,:) = -1*R(1,:,:,:,:);
       S(2:3,:,:,:) = -1*S(2:3,:,:,:);
       % Reverse order of points
       R = flip(R,2); S = flip(S,2);
       S = circshift(S,-1,2);
    end
end
