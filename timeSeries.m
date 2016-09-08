%% TODO:
% - load data of DAX (1.1.1990 - 1.9.2016; getPrices)
% - get percentage returns (price2retWithHolidays)
% - estimate normal distribution (normfit)
% - derive VaR from estimated distribution (95%, 99%, 99.9% confidence levels)
% - get respective exceedance frequencies
% - visualize (non-exceedances: blue; exceedances:, red dots)

% specify begin and end date
dateBeg = '01011990';
dateEnd = '01092016';

% specify assets
tickSymbs = {'^GDAXI'};

data = getPrices(dateBeg, dateEnd, tickSymbs);

% get returns
logRets = price2retWithHolidays(data, true);

%%

% make percentage returns
logRets{:, 2} = logRets{:, 2} * 100;

%% fit normal distribution

[muHat, sigmaHat] = normfit(logRets{:, 2});
params = mle(logRets{:, 2}, 'distribution', 'tLocationScale');

%% get quantiles

alphas = 1 - [0.95, 0.99, 0.999];
VaRs = norminv(alphas, muHat, sigmaHat);
VaRs = icdf('tLocationScale', alphas, params(1), params(2), params(3));

%% get exceedance frequencies

nObs = size(logRets, 1);
exceedanceInds = repmat(logRets{:, 2}, 1, 3) <= repmat(VaRs, nObs, 1);

%% plot exceedances

confLev = 1;

figure('Position', [50 50 1200 800])

for confLev=1:3
    subplot(3, 1, confLev)
    plot(logRets.Date, logRets.GDAXI, '.b')
    datetick 'x'
    grid on
    hold on
    xlimits = get(gca, 'XLim');
    plot(xlimits, [VaRs(confLev) VaRs(confLev)], '-r')
    plot(logRets.Date(exceedanceInds(:, confLev)), ...
        logRets.GDAXI(exceedanceInds(:, confLev)), '.r')
    hold off
end


%% get exceedance frequencies

[alphas; sum(exceedanceInds, 1)/nObs]

%%

figure('Position', [50 50 1200 600])
subplot(1, 2, 1)
simVals = ARsim(0, 1, 1000, 8);
plot(simVals)
subplot(1, 2, 2)
simVals = ARsim(1, 1, 1000, 8);
plot(simVals)


%% estimate AR(1)

trueCoeff = 0.8;
sigma = 1.5;
nObs = 1000;
x0 = 0;

simVals = ARsim(trueCoeff, sigma, nObs, x0);

plot(simVals(1:end-1), simVals(2:end), '.')

%%

sqDev = zeros(nObs, 1);
aGuess = 0.8;

lossFunc = @(aGuess)sum((simVals(2:end) - aGuess*simVals(1:end-1)).^2);

aHat = fminunc(lossFunc, 0);


epsilonHat = simVals(2:end) - aHat*simVals(1:end-1);
trueEpsilons = simVals(2:end) - trueCoeff*simVals(1:end-1);

sigmaHat = std(epsilonHat);

plot(trueEpsilons(1:14))
hold on
plot(epsilonHat(1:14), 'r-')
hold off

% 
% for ii=2:nObs
%    predictNextValue = aGuess*simVals(ii-1);
%    
%    % deviation
%    sqDev(ii) = (predictNextValue - simVals(ii))^2;
%     
% end
% 
% lossVal = sum(sqDev);


%% same exercise with maximum likelihood

lossFunc = @(params)...
    -sum(log(normpdf(simVals(2:end) - params(1)*simVals(1:end-1), 0, params(2))));

fmincon(lossFunc, [0, 1], [], [], [], [], [-inf, 0.01], [inf, inf])

%% linear model

nObs = 500;
sigma = 1.5;
c = 0.5;

% simulate components
X = icdf('Exponential', rand(500, 1), 2);
epsilons = normrnd(0, sigma, 500, 1);

% derive associated Y values
Y = c * X + epsilons;

plot(X, Y, '.')

%% estimate coefficient and standard deviation

lossFunc = @(cHat)sum(cHat*X - Y).^2;

cHat = fminunc(lossFunc, 0);


plot(X, Y, '.')
hold on
plot(X, cHat*X, '.r')
hold off


%% apply AR model to real data

plot(logRets{1:end-1, 2}, logRets{2:end, 2}, '.')

% estimate AR coefficient
retVals = logRets{:, 2};

lossFunc = @(params)...
    -sum(log(normpdf(retVals(2:end) - params(1)*retVals(1:end-1), 0, params(2))));

paramsHat = fmincon(lossFunc, [0, 1], [], [], [], [], [-inf, 0.01], [inf inf]);


%% 

nLags = 20;
autoCorrs = zeros(1, 20);

for ii=1:nLags
   autoCorrs(ii) = corr(retVals(1:end-ii), retVals((ii+1):end));
end

stem(1:nLags, autoCorrs)

%%

autocorr(retVals.^2)

%%

figure('Position', [50 50 1200 600])
subplot(1, 2, 1)
plot(retVals)
subplot(1, 2, 2)
plot(retVals.^2)

%%

nSim = 6000;
sigma0 = 0.5;

[simVals, simSigmas] = GARCHsim([0.1, 0.15, 0.84], nSim, sigma0);


figure('Position', [50 50 1200 600])
subplot(1, 2, 1)
plot(simVals)

subplot(1, 2, 2)
plot(simSigmas)

%% derive hidden sigmas

% assume just some parameters
paramsHat = [0.4, 0.1, 0.1];
%paramsHat = [0.1, 0.15, 0.84];
kappa = paramsHat(1);
alpha = paramsHat(2);
beta = paramsHat(3);

sigma0Hat = 1.5;
derivedSigmas = zeros(size(simVals));
derivedSigmas(1) = sigma0Hat;

for ii=2:size(simVals, 1)
    derivedSigmas(ii) = sqrt(kappa + alpha*simVals(ii-1)^2 + beta*derivedSigmas(ii-1)^2);
end

%%

plot(simSigmas, '-b')
hold on;
plot(derivedSigmas, '-r')

%%

hist(simVals ./ derivedSigmas, 40)





