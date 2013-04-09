function dav = davisdat(filename)
% function dav = davisdat(filename)
%
% Reformats the .mat data file created from BicycleDataProcessor into a
% structure useful for further analyses.
%
% Parameters
% ----------
% filename : string
%   The path to the .mat file.
%
% Returns
% -------
% dav : structure
%   filename : string
%       The path to the original data file.
%   Tdelta : double, n x 1
%       The steer torque time history.
%   Fs : double, 1 x 1
%       The sample rate in hertz.
%   v : double, 1 x 1
%       The average speed over the duration of the run.
%   t : double, n x 1
%       The time vector.
%   y : double, n x 2
%       The output, roll angle and steer angle, time histories.
%   N : integer, 1 x 1
%       The number of time samples.
%   w : double, n x 1
%       The input, lateral force.

    dat = load(['data/measurements/' filename]);

    Fs = dat.NISampleRate; Fs = double(Fs);

    v = dat.ForwardSpeed;

    y(:,1) = dat.RollAngle;
    y(:,2) = dat.SteerAngle;
    f      = dat.PullForce;
    Tdelta = dat.SteerTorque;
    N = size(y,1);

    t = (0:N-1)'./Fs;
    % Output
    dav.filename = filename;
    dav.Tdelta = Tdelta;
    dav.Fs = Fs;
    dav.v = mean(v);
    dav.t = t;
    dav.y = y;
    dav.N = N;
    dav.w = f;

    switch filename;
        case '00184.mat';
            dav.w = -dav.w;
    end

end
