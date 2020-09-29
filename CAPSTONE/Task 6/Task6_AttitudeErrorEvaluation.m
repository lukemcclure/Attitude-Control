clear all
close all

t=0; % set simulation time

%Define orbit frame 
s_BN = [0.3 -0.4 0.5]';
BN = MRP2C(s_BN);
b_w_BN = [1 1.75 -2.2]'*pi/180;

%Define reference frame
Ref_select = 2; % 1=Sun 2=Nadir 3=GMO
if(Ref_select == 3)
    Ref = Task5_GmoPointingFrame(t);
elseif(Ref_select == 2)
    Ref = Task4_NadirPointingFrame(t);
else
    Ref = Task3_SunPointingFrame;
end
RN = Ref.RN;
b_w_RN = BN*Ref.omega; 

%Find difference between body frame & reference frame
BR = BN*RN';
s_BR = C2MRP(BR);
w_BR = b_w_BN-b_w_RN;

