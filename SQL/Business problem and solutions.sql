select * from matches
select * from deliveries

-- Basic Business Problems And Solutions

-- How many matches were played in each IPL season?
	select season,count(*) as total_matches
	from matches
	group by season
	order by season

-- list of teams win overall matches?
	select winner,count(*) as total_win
	from matches
	group by winner
	order by winner

-- Which team won the most matches overall?
	select winner, count(*) as total_win
	from matches
	where winner is not null
	group by winner
	order by total_win desc
	limit 3

-- How many matches were decided by a Super Over?
	SELECT COUNT(*) AS super_over_matches
	FROM matches
	WHERE results = 'tie';

 -- Most "Player of the Match" Awards
 	SELECT player_of_match, COUNT(*) AS awards 
	FROM matches 
	GROUP BY player_of_match 
	ORDER BY awards DESC 
	LIMIT 3;

 -- How many matches did a specific team play in total?
	SELECT COUNT(*) AS total_matches
	FROM matches
	WHERE 'Royal Challengers Bangalore' IN (team1, team2);

-- To find list of all batter	
	SELECT DISTINCT batter
	FROM deliveries
	ORDER BY batter;

-- Most player_of_match award
	SELECT player_of_match, COUNT(*) AS awards_count
	FROM matches
	GROUP BY player_of_match
	ORDER BY awards_count DESC
	LIMIT 5;