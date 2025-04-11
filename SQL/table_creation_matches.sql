create table matches(
  id int PRIMARY KEY,
  season varchar(10),
  city varchar(50),
  date Date,
  match_type varchar(50),
  player_of_match varchar(100),
  venue varchar(100),
  team1 varchar(50),
  team2 varchar(50),
  toss_winner varchar(50),
  toss_decision varchar(20),
  winner varchar(50),
  results varchar(20),
  result_margin int,
  target_runs	int,
  target_overs	float,
  super_over varchar(10),
  methods varchar(10),
  umpire1 varchar(20),
  umpire2 varchar(20)
 )

 select * from matches

COPY matches (id, season, city, date, match_type, player_of_match, venue, team1, team2, toss_winner, 
		toss_decision, winner, results, result_margin, target_runs, target_overs, super_over, methods, umpire1, umpire2)
FROM 'F:/Data_Analytics project/IPL Anlytics/Data Sets/matches.csv'
WITH (FORMAT CSV, HEADER, NULL 'NA');