T = table(out.y_data.time, out.y_data.signals.values, out.theta_data.signals.values);
writetable(T, 'data.csv');