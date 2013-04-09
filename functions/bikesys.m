function H = bikesys(v,datapath)
% function H = bikesys(v,datapath)
%
% Outputs state space models of the bicycle equations for a set of speeds.
%
% Inputs:
% - v; forward speed(s) [double, n x 1]
% - datapath; path to bicycle .mat file [string]
%
% Outputs:
% - H; state space respresentation of the bicycle equations [structure array of
% ss-objects, n x 1]

    load(datapath);

    M = roundn(M0,-12);
    H = struct([]);
    g = 9.81;

    for i = 1:length(v);

        C = roundn((C1*v(i)),-12);
        K = roundn((K0*g + K2*v(i)^2),-12);

        sys.A = [-M\C -M\K; eye(3) zeros(3);];
        sys.B = [ M\eye(3); zeros(3)];
        sys.C = eye(6);
        sys.D = zeros(6,3);

        H(i).v = v(i);
        H(i).G = minreal(ss(sys.A,sys.B,sys.C,sys.D));

    end
