% download data

% specify begin and end date
dateBeg = '01011990';
dateEnd = '01092016';

% specify assets
tickSymbs = {'^GSPC'};

data = getPrices(dateBeg, dateEnd, tickSymbs);

logRets = price2retWithHolidays(data, true);

%%

% make percentage returns
logRets{:, 2} = logRets{:, 2} * 100;

%% estimate GARCH

garchMod = garch(1, 1);
garchHat = estimate(garchMod, logRets{:, 2});

%% simulate values

nSim = 100000;

[simSigmas, simValues] = simulate(garchHat, nSim);

%%

subplot(1, 2, 1)
plot(simValues)

subplot(1, 2, 2)
plot(simSigmas)

%% fit normal distribution

[muHat, sigmaHat] = normfit(simValues);


%% show histogram

histfit(simValues, 300)

%%

hist(simSigmas, 100)


%% return series

subplot(1, 2 ,1)
plot(logRets{:, 2})
subplot(1, 2, 2)
plot(simValues(1:size(logRets, 1)))


%% plot sigma series

derivedSigmas = sqrt(infer(garchHat, logRets{:, 2}));

subplot(1, 2 ,1)
plot(derivedSigmas)
subplot(1, 2, 2)
plot(simSigmas(1:size(logRets, 1)))


%% 

windowSize = 400;
nObs = size(logRets, 1);

movingSigmas = zeros(nObs - windowSize + 1, 1);

for ii=1:(nObs - windowSize + 1)
    movingSigmas(ii) = std(logRets{ii:(windowSize+ii-1), 2});
end

%%

plot(movingSigmas)

%% create associated returns

X = movingSigmas .* randn(size(movingSigmas, 1), 1);

plot(X)

%% estimate simulate data with GARCH

modelSpec = garch(1, 1);
garchFakeHat = estimate(modelSpec, X);

fakeInferredSigmas = sqrt(infer(garchFakeHat, X));

%%

plot(movingSigmas)
hold on
plot(fakeInferredSigmas, '-r')

%%


[garchSimSigmas, garchSimReturns] = simulate(garchFakeHat, 20000);

%%

subplot(1, 2, 1)
plot(movingSigmas)
hold on
plot(fakeInferredSigmas, '-r')

subplot(1, 2, 2)
plot(sqrt(garchSimSigmas))


%%

plot(garchHat.ARCH{1}*(logRets{:, 2}.^2))






