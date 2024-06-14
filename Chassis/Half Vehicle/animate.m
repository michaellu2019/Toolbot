plot_size = L * 3;
x = [-plot_size * 0.5 plot_size * 0.5];
y = [0 0];
axis_limits = [-plot_size * 0.5 plot_size * 0.5 -plot_size * 0.5 plot_size * 0.5];

axis equal;
hold on;

time = out.y_data.time;
ground_values = out.y_data.signals(1).values;
y_values = out.y_data.signals(2).values;
theta_values = out.theta_data.signals(2).values;
N = size(time, 1);
last_time = 0;

bump_x = t_offset * v + l1;

close all;
for ii = 1:N * 0.7
    time_value = time(ii);
    dt = time_value - last_time;
    last_time = time_value;

    scale = 1;
    scaled_ground_value = ground_values(ii) * scale;
    scaled_y_value = y_values(ii) * scale;
    scaled_theta_value  = pi/180 * theta_values(ii) * scale;

    x1 = -L/2 * cos(scaled_theta_value);
    y1 = -L/2 * sin(scaled_theta_value) + scaled_y_value;
    x2 = L/2 * cos(scaled_theta_value);
    y2 = L/2 * sin(scaled_theta_value) + scaled_y_value;
    
    bump_x = bump_x - dt * v;
    bump_y = -plot_size * 0.05;

    axis equal;
    plot([x1, x2], [y1, y2], 'k', 'LineWidth', 10);
    hold on;
    rectangle('Position', [bump_x bump_y w_bump h_bump], 'Curvature', 0.2, 'FaceColor', [0 0.25 0.5]);
    plot(x, y + bump_y, 'k');
    axis(axis_limits);
    hold off;

    pause(dt);
end