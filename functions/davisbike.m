function sys = davisbike(v)
% sys = davisbike(v)
%
% input v: forward velocity of the bicycle.
% output sys: state space model of the bicycle.
%

    % Coefficient matrices;

    M0 = [ 133.31668525,    2.43885691;  2.43885691,   0.22419262];
    C1 = [   0.0       ,   44.65783277; -0.31500940,   1.46189246];
    K0 = [-116.73261635,   -2.48042260; -2.48042260,  -0.77434358];
    K2 = [   0.0       ,  104.85805076;  0.00000000,   2.29688720];

    Hfw = [0.91; 0.014408]; % dfx/dTq

    % External parameter;
    g = 9.81;

    O = zeros(2); I = eye(2); % Some easy notations

    % State Space description of uncontrolled bicycle
    A = [-M0\C1*v -M0\(K0*g + K2*v^2); I O];
    B = [ M0\[I Hfw]; zeros(2,3)];
    C = eye(4);
    D = zeros(4,3);

    % Combine A,B,C and D matrices into a state space object.
    sys = ss(A,B,C,D);

end
