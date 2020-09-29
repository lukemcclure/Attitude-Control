function GmoRef = Task5_GmoPointingFrame(t)
r_lmo = 3796.19; %Actual radius of orbit in KM
r_gmo = 20424.2; %Radius of orbit of GMO
theta_dot_lmo = 0.000884797; %Constant orbit rate of Lmo craft 
theta_dot_gmo = 0.0000709003;

% Low martian orbit
H_lmo = [20 30 60]'*pi/180+[0 0 theta_dot_lmo*t]';
NH_lmo = Euler3132C(H_lmo)';
n_r_lmo = NH_lmo*[r_lmo 0 0]';

% Geosynchronous Martian orbit
H_gmo = [0 0 250]'*pi/180+[0 0 theta_dot_gmo*t]';
NH_gmo = Euler3132C(H_gmo)';
n_r_gmo = NH_gmo*[r_gmo 0 0]';

delta_r = n_r_gmo-n_r_lmo;
delta_s = cross(delta_r,[0 0 1]');

% Now the...basis vectors? 

c1 = -1*delta_r/norm(delta_r);
c2 = delta_s/norm(delta_s);
c3 = cross(c1,c2);

RcN = [c1 c2 c3]';

dt=0.01;

% Now let's find the angular velocity.
dRcN = (Rc(t+dt)-Rc(t))/dt;
omega_RcN_tilde = -Rc(t)'*dRcN;

omega_RcN = [-omega_RcN_tilde(2,3) omega_RcN_tilde(1,3) -omega_RcN_tilde(1,2)]';

GmoRef.RN = RcN;
GmoRef.omega = omega_RcN;
end 
function Rc = Rc(t)

r_lmo = 3796.19; %Actual radius of orbit in KM
r_gmo = 20424.2; %Radius of orbit of GMO
theta_dot_lmo = 0.000884797; %Constant orbit rate of Lmo craft 
theta_dot_gmo = 0.0000709003;

% Low martian orbit
H_lmo = [20 30 60]'*pi/180+[0 0 theta_dot_lmo*t]';
NH_lmo = Euler3132C(H_lmo)';
n_r_lmo = NH_lmo*[r_lmo 0 0]';

% Geosynchronous Martian orbit
H_gmo = [0 0 250]'*pi/180+[0 0 theta_dot_gmo*t]';
NH_gmo = Euler3132C(H_gmo)';
n_r_gmo = NH_gmo*[r_gmo 0 0]';

delta_r = n_r_gmo-n_r_lmo;
delta_s = cross(delta_r,[0 0 1]');

% Now the...basis vectors? 

c1 = -1*delta_r/norm(delta_r);
c2 = delta_s/norm(delta_s);
c3 = cross(c1,c2);

Rc = [c1 c2 c3]';

end
