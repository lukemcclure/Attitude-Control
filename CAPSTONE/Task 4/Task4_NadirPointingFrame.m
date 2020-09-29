function NadirRef = Task4_NadirPointingFrame(t)
% First, go from body frame to hill frame
RH_n = Euler1232C([0 0 pi]')*Euler1232C([-pi 0 0]'); 

theta_dot_lmo = 0.000884797; %Constant orbit rate of Lmo craft 

% Then from hill frame to inertial frame
H_lmo = [20 30 60]'*pi/180+[0 0 theta_dot_lmo*t]';
NH_lmo = Euler3132C(H_lmo)';

RN_n = RH_n*NH_lmo';

% Now to find angular velocity
omega_lmo_H= [0 0 0.000884797]'; %In hill frame

w_RN = NH_lmo*omega_lmo_H;

NadirRef.RN = RN_n;
NadirRef.omega = w_RN;

end