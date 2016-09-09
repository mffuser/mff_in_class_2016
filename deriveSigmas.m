function sigmasHat = deriveSigmas(rets, params, sigma0)
% derive latent sigmas from return series with GARCH equation
%
% Input:
%   rets        nx1 vector of returns (log. returns hopefully)
%   params      1x3 vector of GARCH parameters: kappa, alpha, beta
%   sigma0      scalar; initial volatility
%
% Output:
%   sigmasHat   nx1 vector of estimated sigmas

kappa = params(1);
alpha = params(2);
beta = params(3);

sigmasHat = zeros(size(rets));
sigmasHat(1) = sigma0;

for ii=2:size(rets, 1)
    sigmasHat(ii) = sqrt(kappa + alpha*rets(ii-1)^2 + beta*sigmasHat(ii-1)^2);
end




end