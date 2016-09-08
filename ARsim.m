function X = ARsim(a, sigma, nSim, x0)
% simulate AR(1) process

% preallocate
X = zeros(nSim, 1);
epsilons = normrnd(0, sigma, nSim, 1);
X(1) = x0;

for ii=2:nSim
    X(ii) = a*X(ii-1) + epsilons(ii);
end

end