function CP = CardinalPts(LensMatrix,Materials,WaveVector)

    % Sort Lenses by position
    LensMatrix = sortrows(LensMatrix',5)';

    TotalLenses = size(LensMatrix,2); % Total number of lenses
    
    % Compute system matrix
    
    SystemMatrix = eye(2); % Identity matrix
    
    i = 1;
    
    while i < TotalLenses % lens i
       
        M = ThickLensMatrix(LensMatrix(:,i),char(Materials(i)),WaveVector);
        
        d = LensMatrix(5,i+1) - LensMatrix(5,i) - LensMatrix(4,i);
        D = [1 d; 0 1];
        
        SystemMatrix = D*M*SystemMatrix;
        
        i = i+1;
    end
    
    M = ThickLensMatrix(LensMatrix(:,i),char(Materials(i)),WaveVector);
    SystemMatrix = M*SystemMatrix;
    
    % Compute Cardinal pts
    
    A = SystemMatrix(1,1);
    C = SystemMatrix(2,1);
    D = SystemMatrix(2,2);
    
    r = (D-1)/C;
    s = (1-A)/C;
    v = r;
    w = s;
    f1 = 1/C;
    f2 = -f1;
    
    PP1x = LensMatrix(5,1) + r;
    PP2x = LensMatrix(5,i) + LensMatrix(4,i) + s;
    
    F1x = PP1x + f1;
    F2x = PP2x + f2;
    
    N1x = LensMatrix(5,1) + v;
    N2x = LensMatrix(5,i) + LensMatrix(4,i) + w;
    
    CP = [PP1x PP2x; F1x F2x; N1x N2x; f1 f2];
    
end

function M = ThickLensMatrix(LensVector,material,WaveVector)

    % Computes the system matrix for a thick lens

    R1 = LensVector(1);
    R2 = LensVector(2);
    T = LensVector(4);
    n = refIndex(WaveVector,material);

    M1 = [1 0; -(n-1)/(n*R1) 1/n];
    M2 = [1 T; 0 1];
    M3 = [1 0; -(1-n)/R2 n];
    
    M = M3*M2*M1;

end