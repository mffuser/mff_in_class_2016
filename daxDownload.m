% download DAX

% specify begin and end date
dateBeg = '01011990';
dateEnd = '01092016';

% specify assets
tickSymbs = {'^GSPC', '^GDAXI', '^DJI', '^N225'};

data = getPrices(dateBeg, dateEnd, tickSymbs);

%%

plot(data.Date, data{:, 2:end})
datetick 'x'
grid on
legend(data.Properties.VariableNames(2:end))












