function f = fsc_regularisation(x,x_min,x_max,lambda)

f = lambda * sqrt(sum([x - 0.5 * [x_min + x_max]].^2));
