CREATE TYPE enum_result AS ENUM ('yes','no','void', 'all_no', 'all_yes');
CREATE TYPE enum_strike_type AS ENUM ('unknown', 'greater', 'less', 'greater_or_equal', 'less_or_equal', 'between', 'custom');
CREATE TYPE enum_taker_side AS ENUM ('yes', 'no');

CREATE TABLE event (
	id SERIAL PRIMARY KEY,
	event_ticker TEXT, -- Unique identifier for events.
	category TEXT -- Event category.
);

CREATE TABLE markets_history (
	id SERIAL PRIMARY KEY,
	ticker TEXT, -- Ticker of the target market.
	yes_price SMALLINT, -- Price for the last traded yes contract on the market by the timestamp in the request (ts).
	yes_bid	SMALLINT, -- Price for the highest YES buy offer on the market by the timestamp in the request (ts).
	yes_ask SMALLINT, -- Price for the lowest YES sell offer on the market by the timestamp in the request (ts).
	no_bid SMALLINT, -- Price for the highest NO buy offer on the market by the timestamp in the request (ts).
	no_ask SMALLINT, -- Price for the lowest NO sell offer on the market by the timestamp in the request (ts).
	volume INTEGER, -- Number of contracts bought on the market by the timestamp in the request (ts).
	open_interest INTEGER, -- Number of contracts bought on the market by the timestamp in the request (ts) disconsidering netting.
	ts INTEGER -- Unix timestamp for the current statistics entry.
);

CREATE TABLE markets (
	ticker TEXT PRIMARY KEY,
	can_close_early BOOLEAN, -- If true then this market can close earlier then the time provided on close_time.
	cap_strike INTEGER,
	category TEXT, -- Category for this market.
	close_time INTEGER, -- ISO 8601 spec datetime (ex: 2022-11-30T15:00:00Z)
	event_ticker TEXT, -- Unique identifier for events.
	expiration_time INTEGER, -- ISO 8601 spec datetime (ex: 2022-11-30T15:00:00Z)
	expiration_value TEXT, -- The value that was considered for the settlement.
	floor_strike DECIMAL,
	last_price SMALLINT, -- Price for the last traded yes contract on this market.
	liquidity INTEGER, -- Value for current offers in this market in cents.
	no_ask SMALLINT, -- Price for the lowest NO sell offer on this market.
	no_bid SMALLINT, -- Price for the highest NO buy offer on this market.
	open_interest INTEGER, -- Number of contracts bought on this market disconsidering netting.
	open_time INTEGER, -- ISO 8601 spec datetime (ex: 2022-11-30T15:00:00Z)
	previous_price SMALLINT, -- Price for the last traded yes contract on this market a day ago.
	previous_yes_ask SMALLINT, -- Price for the lowest YES sell offer on this market a day ago.
	previous_yes_bid SMALLINT, -- Price for the highest YES buy offer on this market a day ago.
	result enum_result, -- Settlement result for this market. (yes, no, void, all_no, all_yes)
	risk_limit_cents SMALLINT, -- Risk limit for this market in cents.
	status TEXT, -- Represents the current status of a market.
	strike_type enum_strike_type, -- Strike type defines how the market strike (expiration value) is defined and evaluated.
	subtitle TEXT, -- Shortened title for this market.
	title TEXT, -- Full title describing this market.
	volume INTEGER, -- Number of contracts bought on this market.
	volume_24h INTEGER, -- Number of contracts bought on this market in the past day.
	yes_ask SMALLINT, -- Price for the lowest YES sell offer on this market.
	yes_bid SMALLINT -- Price for the highest YES buy offer on this market.
);
CREATE TABLE series ( -- Represents a group of events that have the same underlying source.
	id SERIAL PRIMARY KEY,
	series_ticker TEXT, -- Ticker that identifies this series.
	strike_date INTEGER, 
	strike_period TEXT,
	sub_title TEXT,
	title TEXT, -- Title describing the series. For full context use you should use this field with the title field of the events belonging to this series.
	frequency TEXT -- Frequency of the series. There is no fixed value set here, but will be something human-readable like: weekly, daily, one-off.
);

CREATE TABLE trades (
	trade_id TEXT PRIMARY KEY, -- Unique identifier for this trade.
	foreign_ticker TEXT,
	FOREIGN KEY (foreign_ticker) REFERENCES markets (ticker), -- Unique identifier for markets.
	count SMALLINT, -- Number of contracts to be bought or sold.
	created_time TEXT, -- ISO 8601 spec datetime (ex: 2022-11-30T15:00:00Z)
	yes_price SMALLINT, -- Yes price for this trade in cents.
	no_price SMALLINT, -- No price for this trade in cents.
	taker_side enum_taker_side -- Side for the taker of this trade. (yes, no)
);
