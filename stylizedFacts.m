% specify begin and end date
dateBeg = '01011990';
dateEnd = '01092016';

% specify assets
tickSymbs = {'^GSPC', '^GDAXI', '^DJI', '^N225'};

data = getPrices(dateBeg, dateEnd, tickSymbs);

discRets = price2retWithHolidays(data, true);

%% calculate evolution with constant interest rates

% get time passed
yearsPassed = (data.Date(end) - data.Date(1))/365;

% get value for each year
i = 0.08;
endValue = 5000*(1 + i).^(1:yearsPassed);

%% visualize log-prices: linear for exponential growth

figure('Position', [50 50 1200 600])
subplot(1, 2, 1)
plot(data.Date, data{:, 2:end})
hold on
plot(data.Date(1) + 365*(1:yearsPassed), endValue)
hold off
datetick 'x'
grid on

subplot(1, 2, 2)
plot(data.Date, log(data{:, 2:end}))
hold on
plot(data.Date(1) + 365*(1:yearsPassed), log(endValue))
hold off
datetick 'x'
grid on

%% get log percentage returns


selectedAsset = 1;

figure('Position', [50 50 1200 800])
ax(1) = subplot(2, 1, 1);
plot(data.Date, data{:, selectedAsset + 1})
title('Historic index values')
datetick 'x'
xlabel('Time')
ylabel(tabnames(data(:, selectedAsset + 1)))
grid on


ax(2) = subplot(2, 1, 2);
plot(discRets.Date, discRets{:, selectedAsset + 1})
title('Historic returns')
datetick 'x'
grid on

linkaxes([ax(1) ax(2)], 'x')

%% create negative log-likel function

mu = 0.03;
sigma = 1.7;

nllhNorm = @(params)-sum(log(normpdf(rets, params(1), params(2))));

nllh = -sum(log(normpdf(rets, mu, sigma)));

%% fit normal distribution to data

parmasHat = fmincon(nllhNorm, [0 1], [], [], [], [], [-inf, 0], [inf, inf]);

%%

rets = discRets{:, selectedAsset + 1}*100;
rets = rets(~isnan(rets));
[~, centers] = hist(rets, 50);
hist(rets, 50)
grid on

% calculate area of bars
nObs = length(rets);

% width of bar
barWidth = centers(2) - centers(1);

totalArea = barWidth * nObs;

%% include estimated normal pdf

hold on

% calculate values of estimated normal distribution
yVals = normpdf(centers, parmasHat(1), parmasHat(2))*totalArea;

plot(centers, yVals, '-r')


%% simulate values from Student's t 

nu = 3.4;
nObs = 1000;

% generic way
U = rand(nObs, 1);
simVals = tinv(U, nu);

% estimate t-distribution
nllhT = @(nu)-sum(log(tpdf(simVals, nu)));

nuHat = fmincon(nllhT, 10000, [], [], [], [], 2.1, inf);

% get bars and width of bars
[~, centers] = hist(simVals, 50);
barWidth = centers(2) - centers(1);

% get total area for scaling
totalArea = barWidth * nObs;

%% plot histogram and pdf

hist(simVals, 50)
grid on

hold on

% calculate values of estimated normal distribution
yVals = tpdf(centers, nuHat)*totalArea;
plot(centers, yVals, '-r')

hold off


%% QQ-plot

% select percentage returns
selectedAsset = 1;
rets = discRets{:, selectedAsset + 1}*100;
rets = rets(~isnan(rets));

%%

% U = rand(6000, 1);
% rets = tinv(U, 4.5);

% fit normal distribution
[muHat, sigmaHat] = normfit(rets);

% estimate t-distribution
nllhT = @(nu)-sum(log(tpdf(rets, nu)));
nuHat = fmincon(nllhT, 4, [], [], [], [], 2.1, inf);

% sort data
sortedRets = sort(rets);

% 
nData = length(rets);
pVals = (1:nData)/(nData + 1);

% get associated normal quantiles
normRets = norminv(pVals, muHat, sigmaHat);
normRets = tinv(pVals, nuHat);

plot(sortedRets, normRets)
hold on
yLimits = get(gca, 'YLim');
plot(yLimits, yLimits, '-r')
hold off
grid on









