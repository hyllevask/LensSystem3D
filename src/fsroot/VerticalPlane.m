function VerticalPlane(xp0,name,SystemView,h)

    % Plots a vertical plane of certain type in 3D in figure h
    
    if xp0 < SystemView(1,1) || xp0 > SystemView(1,2)
        return;
    end
    
    figure(h); hold on;
    
    X = xp0*ones(2,2);
    
    if strcmp(name,'PP1') || strcmp(name,'PP2') % PP
            FaceColor = [0 1 0];
            FaceAlpha = .3;
            y = [SystemView(2,1) SystemView(2,2)];
            z = [SystemView(3,1) SystemView(3,2)];
    else % FP
            FaceColor = [0 0 1];
            FaceAlpha = .3;
            y = [SystemView(2,1) SystemView(2,2)];
            z = [SystemView(3,1) SystemView(3,2)];
    end
    
    [Y,Z] = meshgrid(y,z);

    surf(X,Y,Z, ...
        'FaceColor',FaceColor,'FaceAlpha',FaceAlpha,'EdgeColor','none');
    text(xp0,0,z(2),name);
    hold off;

end