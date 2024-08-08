% https://www.qa1.net/tech-center/spring-rate-tech#:~:text=Springs%20should%20typically%20be%20compressed,rate%20spring%20(about%2025%25).

% world constants
g = 9.8;

% vehicle parameters
m = 90;

% torsion bar parameters
E_st = 200.0e9;
G_st = 76.6e9;
G_tst = 78e9;
G_al = 26.9e9;
G_ny = 3.9e9;
sigma_y_st = 220e6;
tau_y_st = sigma_y_st * 0.5;
sigma_y_tst = 351.63e6;
tau_y_tst = sigma_y_tst * 0.5;
epsilon_max_st = 0.2/100;
epsilon_max_tswt = tau_y_tst/G_tst;

N_wheels = 8;
alpha = pi/4;
r = 0.1;
l = 0.25;
l_b = l - 0.085;
l_f = (l + l_b)/2;
d = 6.35/1000;

I = d^4/12;
% J = (2 * d^4)/12;
J_k = 2.25 * (d/2)^4;
E = E_st;
G = G_st;
sigma_y = sigma_y_tst;
tau_y = tau_y_tst;
epsilon_max = epsilon_max_tswt;

F = (m * g)/N_wheels;
T = F * r * cos(alpha);
phi = (T * l)/(G * J_k);
k_r = (G * J_k)/l;
k_t = (G * J_k)/(r^2 * sin(alpha) * l);

y_0 = r * sin(alpha);
dy = r * sin(alpha) - r * sin(alpha - phi);
dy_y0_pct = dy/y_0 * 100;

% torsion bar torsion analysis
w_clamp = 6.01/1000;
h_clamp = w_clamp;
l_clamp = 12.7/1000;
A_clamp = w_clamp * l_clamp;
F_clamp = T/(4 * d/2);
sigma_clamp = F_clamp/A_clamp;

gamma_rot = (d/2 * phi)/l;
tau_rot = (d/2 * T)/J_k;

% torsion bar bending analysis

syms Ry_var Ri_var Ro_var Mz_var x % E I l l_b F
Fy_eqn = Ry_var + Ri_var + Ro_var + F;
Mz_wall_eqn = Ri_var * l_b + F * l_f + Ro_var * l - Mz_var;

V_bi_eqn = Ry_var;
M_bi_eqn = Mz_var + Ry_var * x;
theta_bi_eqn = 0 + 1/(E * I) * int(M_bi_eqn, [0 x]);
v_bi_eqn = 0 + int(theta_bi_eqn, [0 x]);
theta_bi = 0 + 1/(E * I) * int(M_bi_eqn, [0 l_b]);
v_bi = 0 + int(theta_bi_eqn, [0 l_b]);

V_f_eqn = Ry_var + Ri_var;
M_f_eqn = Mz_var + Ry_var * x + Ri_var * (x - l_b);
theta_f_eqn = theta_bi + 1/(E * I) * int(M_f_eqn, [l_b x]);
v_f_eqn = v_bi + int(theta_f_eqn, [l_b x]);
theta_f = theta_bi + 1/(E * I) * int(M_f_eqn, [l_b l_f]);
v_f = v_bi + int(theta_f_eqn, [l_b l_f]);

V_bo_eqn = Ry_var + Ri_var + F;
M_bo_eqn = Mz_var + Ry_var * x + Ri_var * (x - l_b) + F * (x - l_f);
theta_bo_eqn = theta_f + 1/(E * I) * int(M_bo_eqn, [l_f x]);
v_bo_eqn = v_f + int(theta_bo_eqn, [l_f x]);
theta_bo = theta_f + 1/(E * I) * int(M_bo_eqn, [l_f l]);
v_bo = v_f + int(theta_bo_eqn, [l_f l]);

sol = solve([Fy_eqn == 0, Mz_wall_eqn == 0, v_bi == 0, v_bo == 0], [Ry_var, Ri_var, Ro_var, Mz_var]);
Ry = vpa(sol.Ry_var);
Ri = vpa(sol.Ri_var);
Ro = vpa(sol.Ro_var);
Mz = vpa(sol.Mz_var);

V1_eqn = subs(V_bi_eqn, {Ry_var}, {Ry});
M1_eqn = subs(M_bi_eqn, {Ry_var, Mz_var}, {Ry, Mz});
theta1_eqn = subs(theta_bi_eqn, {Ry_var, Mz_var}, {Ry, Mz});
v1_eqn = subs(v_bi_eqn, {Ry_var, Mz_var}, {Ry, Mz});
tau1_avg_eqn = (3 * V1_eqn)/(2 * d^2);
sigma1_max_eqn = (M1_eqn * d/2)/I;

V2_eqn = subs(V_f_eqn, {Ry_var, Ri_var}, {Ry, Ri});
M2_eqn = subs(M_f_eqn, {Ry_var, Ri_var, Mz_var}, {Ry, Ri, Mz});
theta2_eqn = subs(theta_f_eqn, {Ry_var, Ri_var, Mz_var}, {Ry, Ri, Mz});
v2_eqn = subs(v_f_eqn, {Ry_var, Ri_var, Mz_var}, {Ry, Ri, Mz});
tau2_avg_eqn = (3 * V2_eqn)/(2 * d^2);
sigma2_max_eqn = (M2_eqn * d/2)/I;

V3_eqn = subs(V_bo_eqn, {Ry_var, Ri_var}, {Ry, Ri});
M3_eqn = subs(M_bo_eqn, {Ry_var, Ri_var, Mz_var}, {Ry, Ri, Mz});
theta3_eqn = subs(theta_bo_eqn, {Ry_var, Ri_var, Mz_var}, {Ry, Ri, Mz});
v3_eqn = subs(v_bo_eqn, {Ry_var, Ri_var, Mz_var}, {Ry, Ri, Mz});
tau3_avg_eqn = (3 * V3_eqn)/(2 * d^2);
sigma3_max_eqn = (M3_eqn * d/2)/I;

num_points = 100;
x1 = linspace(0, l_b, num_points * (l_b/l));
x2 = linspace(l_b, l_f, num_points * (l_f - l_b)/l);
x3 = linspace(l_f, l, num_points * (l - l_f)/l);
x_all = linspace(0, l, num_points);

close all;

figure;
subplot(2, 2, 1);
plot(x1, double(subs(V1_eqn, x, x1)), 'b', x2, double(subs(V2_eqn, x, x2)), 'g', x3, double(subs(V3_eqn, x, x3)), 'r');
grid on;
xlabel('x (m)');
ylabel('V(x) (N)');
title('Shear of Torsion Bar');

subplot(2, 2, 2);
plot(x1, double(subs(M1_eqn, x, x1)), 'b', x2, double(subs(M2_eqn, x, x2)), 'g', x3, double(subs(M3_eqn, x, x3)), 'r');
grid on;
xlabel('x (m)');
ylabel('M(x) (Nm)');
title('Moment of Torsion Bar');

subplot(2, 2, 3);
plot(x1, 180/pi() * double(subs(theta1_eqn, x, x1)), 'b', x2, 180/pi() * double(subs(theta2_eqn, x, x2)), 'g', x3, 180/pi() * double(subs(theta3_eqn, x, x3)), 'r');
grid on;
xlabel('x (m)');
ylabel('theta(x) (deg)');
title('Angle of Torsion Bar');

subplot(2, 2, 4 );
plot(x1, 1000 * double(subs(v1_eqn, x, x1)), 'b', x2, 1000 * double(subs(v2_eqn, x, x2)), 'g', x3, 1000 * double(subs(v3_eqn, x, x3)), 'r');
grid on;
xlabel('x (m)');
ylabel('v(x) (mm)');
title('Deflection of Torsion Bar');

figure;
subplot(2, 2, 1);
plot(x1, double(subs(tau1_avg_eqn, x, x1)), 'b', x2, double(subs(tau2_avg_eqn, x, x2)), 'g', x3, double(subs(tau3_avg_eqn, x, x3)), 'r', ...
    x_all, linspace(tau_y, tau_y, num_points), 'c', x_all, linspace(-tau_y, -tau_y, num_points), 'c');
grid on;
xlabel('x (m)');
ylabel('tau_{avg}(x) (Pa)');
title('Average Shear Stress of Torsion Bar');

subplot(2, 2, 2);
plot(x1, double(subs(sigma1_max_eqn, x, x1)), 'b', x2, double(subs(sigma2_max_eqn, x, x2)), 'g', x3, double(subs(sigma3_max_eqn, x, x3)), 'r', ...
    x_all, linspace(sigma_y, sigma_y, num_points), 'c', x_all, linspace(-sigma_y, -sigma_y, num_points), 'c');
grid on;
xlabel('x (m)');
ylabel('sigma_{max}(x) (Pa)');
title('Max Bending Stress of Torsion Bar');

subplot(2, 2, 3);
plot(x1, double(subs(tau1_avg_eqn/G, x, x1)), 'b', x2, double(subs(tau2_avg_eqn/G, x, x2)), 'g', x3, double(subs(tau3_avg_eqn/G, x, x3)), 'r', ...
    x_all, linspace(epsilon_max, epsilon_max, num_points), 'c', x_all, linspace(-epsilon_max, -epsilon_max, num_points), 'c');
grid on;
xlabel('x (m)');
ylabel('gamma_{avg}(x)');
title('Average Shear Strain of Torsion Bar');

subplot(2, 2, 4);
plot(x1, double(subs(sigma1_max_eqn/E, x, x1)), 'b', x2, double(subs(sigma2_max_eqn/E, x, x2)), 'g', x3, double(subs(sigma3_max_eqn/E, x, x3)), 'r', ...
    x_all, linspace(epsilon_max, epsilon_max, num_points), 'c', x_all, linspace(-epsilon_max, -epsilon_max, num_points), 'c');
grid on;
xlabel('x (m)');
ylabel('epsilon_{max}(x)');
title('Max Bending Strain of Torsion Bar');

k_t, phi * 180/pi(), dy, dy_y0_pct
gamma_rot, epsilon_max, tau_rot, tau_y
