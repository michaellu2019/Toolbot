% world constants
g = 9.8;

% vehicle parameters
m = 100;

% chassis parameters
E_al = 69.0e9;
G_al = 26.9e9;
sigma_y_al = 240e6;
tau_y_al = sigma_y_al * 0.5;
epsilon_max_al = sigma_y_al/E_al;

N_beams = 5;
L_beam = 0.5;
w_beam = 20/1000;
h_beam = 40/1000;
Ix_beam = 1.358e-8;
Iy_beam = 5.13e-8;

E = E_al;
G = G_al;
I = Iy_beam;
sigma_y = sigma_y_al;
tau_y = tau_y_al;
epsilon_max = epsilon_max_al;

W = (m * g)/N_beams;

M_max = (W * L_beam)/4;
d_max = (W * L_beam^3)/(48 * E * I);

syms Ry_L_var Ry_R_var theta_L_var x
Fy_eqn = Ry_L_var + Ry_R_var - W;
Mz_L_eqn = -W * L_beam/2 + Ry_R_var * L_beam;

V_L_eqn = Ry_L_var;
M_L_eqn = Ry_L_var * x;
theta_L_eqn = theta_L_var + 1/(E * I) * int(M_L_eqn, [0 x]);
v_L_eqn = 0 + int(theta_L_eqn, [0 x]);
theta_L = theta_L_var + 1/(E * I) * int(M_L_eqn, [0 L_beam/2]);
v_L = 0 + int(theta_L_eqn, [0 L_beam/2]);

V_R_eqn = Ry_L_var - W;
M_R_eqn = Ry_L_var * x - W * (x - L_beam/2);
theta_R_eqn = theta_L + 1/(E * I) * int(M_R_eqn, [L_beam/2 x]);
v_R_eqn = v_L + int(theta_R_eqn, [L_beam/2 x]);
theta_R = theta_L + 1/(E * I) * int(M_R_eqn, [L_beam/2 L_beam]);
v_R = v_L + int(theta_R_eqn, [L_beam/2 L_beam]);

sol = solve([Fy_eqn == 0, Mz_L_eqn == 0, v_R == 0], [Ry_L_var, Ry_R_var, theta_L_var]);
Ry_L = vpa(sol.Ry_L_var);
Ry_R = vpa(sol.Ry_R_var);
theta_L = vpa(sol.theta_L_var);

V1_eqn = subs(V_L_eqn, {Ry_L_var}, {Ry_L});
M1_eqn = subs(M_L_eqn, {Ry_L_var}, {Ry_L});
theta1_eqn = subs(theta_L_eqn, {Ry_L_var, theta_L_var}, {Ry_L, theta_L});
v1_eqn = subs(v_L_eqn, {Ry_L_var, theta_L_var}, {Ry_L, theta_L});
tau1_avg_eqn = (3 * V1_eqn)/(2 * w_beam * h_beam);
sigma1_max_eqn = (M1_eqn * h_beam/2)/I;

V2_eqn = subs(V_R_eqn, {Ry_L_var}, {Ry_L});
M2_eqn = subs(M_R_eqn, {Ry_L_var}, {Ry_L});
theta2_eqn = subs(theta_R_eqn, {Ry_L_var, theta_L_var}, {Ry_L, theta_L});
v2_eqn = subs(v_R_eqn, {Ry_L_var, theta_L_var}, {Ry_L, theta_L});
tau2_avg_eqn = (3 * V2_eqn)/(2 * w_beam * h_beam);
sigma2_max_eqn = (M2_eqn * h_beam/2)/I;

num_points = 100;
x1 = linspace(0, L_beam/2, num_points * ((L_beam/2)/L_beam));
x2 = linspace(L_beam/2, L_beam, num_points * ((L_beam - L_beam/2)/L_beam));
x_all = linspace(0, L_beam, num_points);

close all;

figure;
subplot(2, 2, 1);
plot(x1, double(subs(V1_eqn, x, x1)), 'b', x2, double(subs(V2_eqn, x, x2)), 'g');
xlabel('x (m)');
ylabel('V(x) (N)');
title('Shear of Chassis Cross Beam');

subplot(2, 2, 2);
plot(x1, double(subs(M1_eqn, x, x1)), 'b', x2, double(subs(M2_eqn, x, x2)), 'g');
grid on;
xlabel('x (m)');
ylabel('M(x) (Nm)');
title('Moment of Chassis Cross Beam');

subplot(2, 2, 3);
plot(x1, 180/pi() * double(subs(theta1_eqn, x, x1)), 'b', x2, 180/pi() * double(subs(theta2_eqn, x, x2)), 'g');
grid on;
xlabel('x (m)');
ylabel('theta(x) (deg)');
title('Angle of Chassis Cross Beam');

subplot(2, 2, 4 );
plot(x1, 1000 * double(subs(v1_eqn, x, x1)), 'b', x2, 1000 * double(subs(v2_eqn, x, x2)), 'g');
grid on;
xlabel('x (m)');
ylabel('v(x) (mm)');
title('Deflection of Chassis Cross Beam');

figure;
subplot(2, 2, 1);
plot(x1, double(subs(tau1_avg_eqn, x, x1)), 'b', x2, double(subs(tau2_avg_eqn, x, x2)), 'g', ...
    x_all, linspace(tau_y, tau_y, num_points), 'c', x_all, linspace(-tau_y, -tau_y, num_points), 'c');
grid on;
xlabel('x (m)');
ylabel('tau_{avg}(x) (Pa)');
title('Average Shear Stress of Chassis Cross Beam');

subplot(2, 2, 2);
plot(x1, double(subs(sigma1_max_eqn, x, x1)), 'b', x2, double(subs(sigma2_max_eqn, x, x2)), 'g', ...
    x_all, linspace(sigma_y, sigma_y, num_points), 'c', x_all, linspace(-sigma_y, -sigma_y, num_points), 'c');
grid on;
xlabel('x (m)');
ylabel('sigma_{max}(x) (Pa)');
title('Max Bending Stress of Chassis Cross Beam');

subplot(2, 2, 3);
plot(x1, double(subs(tau1_avg_eqn/G, x, x1)), 'b', x2, double(subs(tau2_avg_eqn/G, x, x2)), 'g', ...
    x_all, linspace(epsilon_max, epsilon_max, num_points), 'c', x_all, linspace(-epsilon_max, -epsilon_max, num_points), 'c');
grid on;
xlabel('x (m)');
ylabel('gamma_{avg}(x)');
title('Average Shear Strain of Chassis Cross Beam');

subplot(2, 2, 4);
plot(x1, double(subs(sigma1_max_eqn/E, x, x1)), 'b', x2, double(subs(sigma2_max_eqn/E, x, x2)), 'g', ...
    x_all, linspace(epsilon_max, epsilon_max, num_points), 'c', x_all, linspace(-epsilon_max, -epsilon_max, num_points), 'c');
grid on;
xlabel('x (m)');
ylabel('epsilon_{max}(x)');
title('Max Bending Strain of Chassis Cross Beam');