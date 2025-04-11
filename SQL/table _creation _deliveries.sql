create table deliveries(
match_id int,
inning	int,
batting_team	varchar(100),
bowling_team	varchar(100),
overs	int,
ball	int,
batter	varchar(100),
bowler	varchar(100),
batsman_runs	int,
extra_runs	int,
total_runs	int,
extras_type	varchar(50),
is_wicket int,
foreign key (match_id) references matches(id)
)

select * from deliveries

COPY deliveries
FROM 'F:/Data_Analytics project/IPL Anlytics/Data Sets/deliveries.csv'
WITH (FORMAT CSV, HEADER);