clear all
close all

% This function will input the radius r and euler agles of RAAN, inclination, and anomaly
% Outputs will be inertial position and velocity vectors
h = 400; %Orbital height of LMO in KM
r_lmo = h+3396.19; %Actual radius of orbit in KM
r_gmo = 20424.2; %Radius of orbit of GMO
mu = 42828.3; %Mars gravitational constant in km^3/s^2

theta_dot_lmo = 0.000884797; %Constant orbit rate of Lmo craft 
theta_dot_gmo = 0.0000709003;

v_lmo = [0 theta_dot_lmo*r_lmo 0]';
v_gmo = [0 theta_dot_gmo*r_gmo 0]';

% Low martian orbit calcs
t=450;
H_lmo = [20 30 60]'*pi/180+[0 0 theta_dot_lmo*t]';
NH_lmo = Euler3132C(H_lmo)';
lmo_pos = NH_lmo*[r_lmo 0 0]';
lmo_velocity = NH_lmo*v_lmo

% Geosynch orbit
t=1150;
H_gmo = [0 0 250]'*pi/180+[0 0 theta_dot_gmo*t]';
NH_gmo = Euler3132C(H_gmo)';
gmo_pos = NH_gmo*[r_gmo 0 0]';
gmo_velocity = NH_gmo*v_gmo


