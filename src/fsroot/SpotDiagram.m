function SpotDiagram (xp0,R,S,WaveVector,g,h,ObjectNames)

    % Plots three cross sections of ray spread perpendicular to the optical
    % axis and with central diagram at x = xp0. Diagram correspond to the 
    % first 9 object points (dim 5 in R and S) and all wavelengths included
    % in WaveVector. Plots spot diagrams (cross sections) in figure g and 
    % includes a 3D plane plot in figure h (if exists).
    
    % Declaration/Allocation:
    if size(R,5) <= 9
        ObjectPoints = size(R,5);
    else
        ObjectPoints = 9;
    end
    rows = ceil(ObjectPoints/3);
    if ObjectPoints <= 3
        cols = ObjectPoints;
    else
        cols = 3;
    end
    Wavelengths = size(R,4);
    RaysPerWavelength = size(R,3);
    Pts = zeros(2,RaysPerWavelength);
    
    scale = 1; % Scale of square diagram
    
    xSpot = xp0; % Spot x-location
    
    % Create 2D cross sections
    figure(g);
    
    for w = 1:ObjectPoints % object point w

        subplot(rows,cols,w); hold on;

        for q = 1:Wavelengths % wavelength q

            for k = 1:RaysPerWavelength % ray k

                % Find out from which initial position r to compute ray
                index = find(R(1,:,k,q,w) < xSpot,1,'last');

                if isempty(index)
                    % Spot location is behind object point
                    close(g);
                    return;
                elseif any(imag(R(:,index,k,q,w)),'all')
                    % Ray is outside system
                    close(g);
                    return;
                end

                % Retrieve initial position and direction
                r = R(:,index,k,q,w);
                s = S(:,index,k,q,w);

                % Determine length of ray segment
                d = (xSpot - r(1))/s(1);

                % Find coordinates of point of intersection with plane
                PInt = r + d*s;

                % Store point
                Pts(:,k) = PInt(2:3);
            end

            % Specify color from wavelength
            switch WaveVector(q)
                case 450
                    SpotColor = [0 70 255]/255;
                case 530
                    SpotColor = [94 255 0]/255;
                case 656
                    SpotColor = [255 0 0]/255;
                otherwise
                    SpotColor = [0 0 0];
            end

            % Plot in 2D figure
            plot(Pts(1,:),Pts(2,:),'o','MarkerSize',3, ...
              'MarkerFaceColor',SpotColor,'MarkerEdgeColor',SpotColor);

        end

        % Adjust plot
        xlim( [-scale scale] + mean(Pts(1,:)) );
        ylim( [-scale scale] + mean(Pts(2,:)) );
        xlabel('y [mm]'); ylabel('z [mm]');
        if length(WaveVector) == 1
            legend(sprintf('%.1f nm',WaveVector));
        elseif length(WaveVector) == 3
            legend( sprintf('%.1f nm',WaveVector(1)), ...
                    sprintf('%.1f nm',WaveVector(2)), ...
                    sprintf('%.1f nm',WaveVector(3)) );
        end
        title( ObjectNames(w) );
        grid on; axis square; box on;
        
        if isgraphics(h,'figure') % draw plane in 3D figure
            figure(h); hold on;
            X = xp0*ones(2,2);
            y = [-scale scale] + mean(Pts(1,:));
            z = [-scale scale] + mean(Pts(2,:));
            [Y,Z] = meshgrid(y,z);
            surf(X,Y,Z, ...
                'FaceColor',[.1 .1 .1],'FaceAlpha',.9,'EdgeColor','none');
            hold off;
            figure(g); % Bring spot to front
        end
        
    end
    
    set(g,'color','w');
    sgtitle(sprintf('Cross sections for rays at x = %.3f mm',xSpot));
    hold off;
    
end