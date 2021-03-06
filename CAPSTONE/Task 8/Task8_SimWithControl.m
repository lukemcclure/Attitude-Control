clear all
close all
format long

% WELCOME TO THE SIM BABeY
t_end = 4000;
%Define target time above
%Define orbit frame and body inertia of satellite
s_BN = [0.3 -0.4 0.5]';
b_w_BN = [1 1.75 -2.2]'*pi/180;
I=diag([10;5;7.5]);
P=1/6 * eye(3);
K=1/180;

%% Integrator
dt=0.01;
span_t = 0:dt:t_end;

% All the data
BN.s   = zeros(3, numel(span_t));
BN.B_w = zeros(3, numel(span_t));
RN.s   = zeros(3, numel(span_t));
RN.B_w = zeros(3, numel(span_t));
BR.s   = zeros(3, numel(span_t));
BR.B_w = zeros(3, numel(span_t));
i=1;
du = 0;

%Define initial state of satellite
X = [s_BN; b_w_BN];

%Integrator loop
for t = span_t
    
    s_BN = X(1:3); % Current attitude DCM    
    s_RN = C2MRP(Ref(t).RN); % Required attitude DCM
    s_BR = C2MRP(MRP2C(s_BN)*MRP2C(s_RN)'); % Attitude error

    b_w_BN = X(4:6); %Current omega
    b_w_RN = MRP2C(s_BN)*Ref(t).omega; %Required omega
    b_w_BR = b_w_BN-b_w_RN; %Omega error
    
    % With the errors established, we can define u 
%     u = 0;
    if(t==0 | du==1/dt)
        u = - K*s_BR - P*eye(3)*b_w_BR;
        du=0;
    end
    % Store attitude
    BN.s(:,i)   = X(1:3);
    BN.B_w(:,i) = X(4:6);
    
    % Store attitude error
    BR.s(:,i)   = s_BR;
    BR.B_w(:,i) = b_w_BR;
    
    % Store commanded values for validation
    RN.s(:,i)   = s_RN;
    RN.B_w(:,i) = b_w_RN;
    
    %RK4 time
    K1=dotx(X,u);
    K2=dotx(X+0.5*dt*K1,u);
    K3=dotx(X+0.5*dt*K2,u);
    K4=dotx(X+dt*K3,u);
    X=X+dt/6*(K1+2*K2+2*K3+K4);

    % Check for shadow set
    if norm(X(1:3))>1
        X(1:3)=-X(1:3)/norm(X(1:3))^2;
    end
    i=i+1;
    du=du+1;
end

%% Data processing and display

Graph(BN,BR,RN);
% H = I*b_w_BN
% T = 0.5*b_w_BN'*I*b_w_BN
% n_H = MRP2C(s_BN)'*H
Final_MRP = s_BN


%% Extra functions 
%tilde
function tilde = tilde(x)
    tilde = [0 -x(3) x(2);x(3) 0 -x(1);-x(2) x(1) 0];
end

%Mechanics Equations
function y=dotx(x,u)
sigma=x(1:3);
omega=x(4:6);
I=diag([10;5;7.5]);
B=(1-norm(sigma)^2)*eye(3)+2*tilde(sigma)+2*sigma*sigma';
sigmadot=0.25*B*omega;
omegadot=inv(I)*(-tilde(omega)*I*omega+u);
y=[sigmadot;omegadot];
end

%Define reference frame
function Ref = Ref(t)
Target_Reference_Frame = 3; % 1=Sun 2=Nadir 3=GMO
if(Target_Reference_Frame == 3)
    Ref = Task5_GmoPointingFrame(t);
elseif(Target_Reference_Frame == 2)
    Ref = Task4_NadirPointingFrame(t);
else
    Ref = Task3_SunPointingFrame;
end
end

%Plotting graphs
function Graph = Graph(BN,BR,RN)
    figure
    hold on
    plot(BN.s(1,:))
    plot(BN.s(2,:))
    plot(BN.s(3,:))
    legend('\sigma_1', '\sigma_2','\sigma_3');
    title('Attitude Coordinates');

    figure
    hold on
    plot(BN.B_w(1,:))
    plot(BN.B_w(2,:))
    plot(BN.B_w(3,:))
    legend('\omega_1', '\omega_2','\omega_3');
    title('Attitude rates');
    
    figure
    hold on
    plot(BR.s(1,:))
    plot(BR.s(2,:))
    plot(BR.s(3,:))
    legend('\sigma_1', '\sigma_2','\sigma_3');
    title('Attitude Errors');
    
end