clc; clear; format long;

%LMO Attitude States
sigma_BN_0 = [0.3;-0.4;0.5];
B_omega_BN_0 = [1;1.75;-2.2];
B_omega_BN_0 = deg2rad(B_omega_BN_0);
I_LMO = diag([10;5;7.5]);

%Satellite Initial Params
NS_init_orient = [20;30;60]; %Degrees
MS_inti_orient = [0;0;250]; %Degrees
NS_init_orient = deg2rad(NS_init_orient);
MS_init_orient = deg2rad(MS_inti_orient);

%Planet Params
r_mars = 3396.19; %kilometers
gravity_const_mars = 42828.3; %km3/s2
h_NS = 400; %kilometers
r_NS = r_mars+h_NS; %kilometers
theta_dot_NS = sqrt(gravity_const_mars/(r_NS^3)); %rad/s
r_MS = 20424.2; %kilometers
theta_dot_MS = sqrt(gravity_const_mars/(r_MS^3)); %rad/s

%NanoSatellite
pos_NS = [r_NS;0;0];
omega_dot_NS = [0;0;theta_dot_NS];

%MotherSatellite
pos_MS = [r_MS;0;0];
omega_dot_MS = [0;0;theta_dot_MS];

%Time Params
dt = 1;
t_initial = 0;
t_final = 6500;
time = t_initial:dt:t_final;

%Allocation and Initialization
sigmas_BN = zeros(3,length(time));
B_omegas_BN = zeros(3,length(time));
sigmas_BN(:,1) = sigma_BN_0;
B_omegas_BN(:,1) = B_omega_BN_0;

%Control Params
time_decay = 120;
epsilon = 1;
P = max(diag(2*I_LMO/time_decay))*eye(3);
K = max(diag((P^2)/(epsilon*I_LMO)));

for i = 1:length(time)-1

    sigma_BN = sigmas_BN(:,i);
    omega_BN = B_omegas_BN(:,i);

    [N_r_LMO,N_r_dot_LMO] = Inertial_pos_vel(pos_NS,NS_init_orient,omega_dot_NS,time(i));
    [N_r_GMO,N_r_dot_GMO] = Inertial_pos_vel(pos_MS,MS_init_orient,omega_dot_MS,time(i));
    communication_angle = rad2deg(acos(sum((N_r_LMO./norm(N_r_LMO)).*(N_r_GMO./norm(N_r_GMO)))));

    %Conditions for Switching Modes
    if N_r_LMO(2) > 0
        pointing_control = 'sun';
    elseif communication_angle > -35 && communication_angle < 35
        pointing_control = 'gmo';
    else
        pointing_control = 'nadir';
    end

    %DCMs and Omegas for Corresponding Modes
    switch pointing_control
        case 'sun'
            [Ref_DCM,Ref_omega] = sun_pointing_frame();
        case 'nadir'
            [Ref_DCM,Ref_omega] = nadir_pointing_frame(NS_init_orient,omega_dot_NS,time(i));
        case 'gmo'
            [Ref_DCM,Ref_omega] = GMO_pointing_frame(pos_NS,pos_MS,NS_init_orient,MS_init_orient,omega_dot_NS,omega_dot_MS,time(i));
    end

    %Attitude Error Evaluation
    [sigma_BR,B_omega_BR] = attitude_error_evaluation(sigma_BN,omega_BN,Ref_DCM,Ref_omega);
    %Control Law
    u = -K*sigma_BR -P*B_omega_BR;

    w1 = I_LMO \ (-tilde(omega_BN) * I_LMO * omega_BN + u);
    w2 = I_LMO \ (-tilde(omega_BN + 0.5*dt*w1) * I_LMO * (omega_BN + 0.5*dt*w1) + u);
    w3 = I_LMO \ (-tilde(omega_BN + 0.5*dt*w2) * I_LMO * (omega_BN + 0.5*dt*w2) + u);
    w4 = I_LMO \ (-tilde(omega_BN + dt*w3) * I_LMO * (omega_BN + dt*w3) + u);
    B_omegas_BN(:,i+1) = omega_BN + dt*(w1 + 2*w2 + 2*w3 + w4) / 6;

    s1 = 0.25 * ((1 - sigma_BN' * sigma_BN) * eye(3) + 2 * tilde(sigma_BN) + 2 * (sigma_BN * sigma_BN')) * omega_BN;
    s2 = 0.25 * ((1 - (sigma_BN + 0.5*dt*s1)' * (sigma_BN + 0.5*dt*s1)) * eye(3) + 2 * tilde(sigma_BN + 0.5*dt*s1) + 2 * ((sigma_BN + 0.5*dt*s1) * (sigma_BN + 0.5*dt*s1)')) * omega_BN;
    s3 = 0.25 * ((1 - (sigma_BN + 0.5*dt*s2)' * (sigma_BN + 0.5*dt*s2)) * eye(3) + 2 * tilde(sigma_BN + 0.5*dt*s2) + 2 * ((sigma_BN + 0.5*dt*s2) * (sigma_BN + 0.5*dt*s2)')) * omega_BN;
    s4 = 0.25 * ((1 - (sigma_BN + dt*s3)' * (sigma_BN + dt*s3)) * eye(3) + 2 * tilde(sigma_BN + dt*s3) + 2 * ((sigma_BN + dt*s3) * (sigma_BN + dt*s3)')) * omega_BN;
    sigmas_BN(:,i+1) = sigma_BN + dt*(s1 + 2*s2 + 2*s3 + s4) / 6;
    sigmas_BN(:,i+1) = MRPswitch(sigmas_BN(:,i+1),1);

end

figure(1)
plot(time, sigmas_BN(1,:), time, sigmas_BN(2,:), time, sigmas_BN(3,:), 'LineWidth', 1);
legend('\sigma_1', '\sigma_2', '\sigma_3');

figure(2)
plot(time, B_omegas_BN(1,:), time, B_omegas_BN(2,:), time, B_omegas_BN(3,:), 'LineWidth', 1);
legend('\omega_1', '\omega_2', '\omega_3');

save('sigmas_BN.mat', 'sigmas_BN');
save('B_omegas_BN.mat', 'B_omegas_BN');
save('time.mat', 'time');