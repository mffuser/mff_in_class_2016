% download DAX

% specify begin and end date
dateBeg = '01011990';
dateEnd = '01092016';

% specify assets
tickSymb1 = '^GDAXI';
tickSymb2 = '^GSPC';
tickSymbs = {tickSymb1; tickSymb2};

data = getPrices(dateBeg, dateEnd, tickSymbs);







