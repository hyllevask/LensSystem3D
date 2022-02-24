function f = FocalLength(Lens)

    % Computes the effective focal length of Lens = [R1 R2 D T x0 n]
    
    R1 = Lens(1);
    R2 = Lens(2);
    T = Lens(4);
    n = Lens(6);
    
    f = ( (n-1) * ( 1/R1 - 1/R2 + (n-1)*T / (n*R1*R2) ) )^-1;
end