function DisplaySystem(LensMatrix,ObjectMatrix,R,WaveVector,SystemView,h)

    % Plots system defined by LensMatrix = [Lens1' Lens2' ...] and 
    % SystemView = [x1 x2; y1 y2; z1 z2], along with rays with wavelengths
    % in WaveVector = [lambda1 lambda2 ...]' from  object points in 
    % ObjectMatrix, defined by their positions in array R. Plots in figure
    % with handle h.
    
    RaysPerWavelength = size(R,3);
    Wavelengths = size(R,4);
    Objects = size(R,5);
    
    figure(h); hold on

    % Plot lenses
    for i = 1:size(LensMatrix,2)
        SphLens(LensMatrix(:,i));
    end
    
    % Plot optical axis
    plot3([SystemView(1,1) SystemView(1,2)], [0 0], [0 0],'k');

    for w = 1:Objects % object w
        
        Object = ObjectMatrix(:,w);
        
        % Plot object points
        plot3(Object(1),Object(2),Object(3), ...
        'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
        
        for q = 1:Wavelengths % wavelength q

            % Specify color from wavelength
            switch WaveVector(q)
                case 450
                    RayColor = [0 70 255]/255;
                case 530
                    RayColor = [94 255 0]/255;
                case 656
                    RayColor = [255 0 0]/255;
            end


            for k = 1:RaysPerWavelength % ray k
                X = R(1,:,k,q,w); Y = R(2,:,k,q,w); Z = R(3,:,k,q,w);
                plot3(X,Y,Z,'Color',RayColor,'LineWidth',1.5); % Ray plot
            end
        end
    end
    
    % Adjust plot
    xlabel('x [mm]'); ylabel('y [mm]'); zlabel('z [mm]');
    axis equal; axis tight; axis vis3d;
    xlim([SystemView(1,1) SystemView(1,2)]);
    ylim([SystemView(2,1) SystemView(2,2)]);
    zlim([SystemView(3,1) SystemView(3,2)]);
    grid on; box on;
    set(h,'color','w');
    view([37.5 30]);
    InSet = get(gca, 'TightInset');
    set(gca, 'InnerPosition', ... 
        [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)]);
    
    hold off;

end