function [X, sigmas] = GARCHsim(params, nSim, sigma0)
% simulate GARCH(1, 1) process

kappa = params(1);
alpha = params(2);
beta = params(3);

% preallocate
X = zeros(nSim, 1);
sigmas = zeros(nSim, 1);
epsilons = normrnd(0, 1, nSim, 1);

sigmas(1) = sigma0;
X(1) = epsilons(1) * sigmas(1);
for ii=2:nSim
    sigmas(ii) = sqrt(kappa + alpha*X(ii-1)^2 + beta*sigmas(ii-1)^2);
    X(ii) = sigmas(ii)*epsilons(ii);
end

end