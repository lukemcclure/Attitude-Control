function OrbitOrientation = Task2_OrbitFrameOrientation(t)
theta_dot_lmo = 0.000884797; %Constant orbit rate of Lmo craft 
H_lmo = [20 30 60]'*pi/180+[0 0 theta_dot_lmo*t]';
HN_lmo = Euler3132C(H_lmo);
OrbitOrientation = HN_lmo;
end
