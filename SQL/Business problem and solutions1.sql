select * from matches
select * from deliveries

-- Intermediate Business Problems And Solutions

--	Top 10 run scorrer
	SELECT batter, SUM(batsman_runs) AS total_runs
	FROM deliveries
	GROUP BY batter
	ORDER BY total_runs DESC
	LIMIT 10;

--  Top best bolwers with most wickets
	select bowler, count(*) as wickets
	from deliveries
	where is_wicket = 1
	group by bowler
	order by wickets desc
	limit 5;

-- find the total runs scored by a specific batsman in all IPL matches.
	SELECT batter, SUM(batsman_runs) AS total_runs_scored
	FROM deliveries
	WHERE batter = 'SK Raina'
	GROUP BY batter;

-- For each team,find what was the total number of matches they played
		SELECT team, COUNT(*) AS total_matches_played
	FROM (
	    SELECT team1 AS team FROM matches
	    UNION ALL
	    SELECT team2 AS team FROM matches
	) AS all_teams
	GROUP BY team
	ORDER BY total_matches_played DESC;


-- For each team,find what was the total number of matches they played and the number of wins they had?
	SELECT team,COUNT(*) AS total_matches_played,
	    (SELECT COUNT(*) FROM matches 
	        WHERE winner = team	) AS won 
	FROM (
	    SELECT team1 AS team FROM matches
	    UNION ALL
	    SELECT team2 AS team FROM matches) AS teams
	GROUP BY team
	ORDER BY total_matches_played DESC;

-- Top 5 batsmen with most runs in death overs (16-20).
	SELECT batter, SUM(batsman_runs) AS death_over_runs
	FROM deliveries
	WHERE overs BETWEEN 16 AND 20
	GROUP BY batter
	ORDER BY death_over_runs DESC
	LIMIT 5;

-- Identify the top 3 venues that have hosted the most IPL matches.
	SELECT venue, COUNT(*) AS total_matches
	FROM matches
	GROUP BY venue
	ORDER BY total_matches DESC
	LIMIT 3;

-- Track Awards Over Seasons
	SELECT player_of_match,COUNT(*) AS total_awards,
	ARRAY_AGG(DISTINCT season ORDER BY season) AS seasons_won,
	MAX(season) AS latest_season
	FROM matches
	GROUP BY player_of_match
	ORDER BY total_awards DESC
	LIMIT 5;

-- List the player of the match winners for each season.
	SELECT
	    season,player_of_match,award_count
	FROM (
	    SELECT
	        season,player_of_match,COUNT(*) AS award_count,
	        MAX(COUNT(*)) OVER (PARTITION BY season) AS max_award_count
	    FROM matches
	    WHERE player_of_match IS NOT NULL
	    GROUP BY
	        season,player_of_match) AS player_season_awards
	WHERE award_count = max_award_count
	ORDER BY season

-- Season with Highest Total Runs Scored OverAll
	SELECT m.season, SUM(d.total_runs) AS season_runs
	FROM deliveries d
	JOIN matches m ON d.match_id = m.id
	GROUP BY m.season
	ORDER BY season_runs DESC;

-- Best Performance While Chasing in IPL
	SELECT
	    team2 AS chasing_team,
	    ROUND(SUM(CASE WHEN winner = team2 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS success_rate
	FROM matches
	WHERE target_runs IS NOT NULL
	GROUP BY team2
	ORDER BY success_rate DESC
	-- LIMIT 10;

-- Team which has the highest success rate in run chases?
	SELECT d.batting_team as team,
		COUNT(DISTINCT d.match_id) AS chases,
		COUNT(DISTINCT m.id) FILTER (WHERE d.batting_team = m.winner) AS successful_chases,
		ROUND(100.0 * COUNT(DISTINCT m.id) FILTER (WHERE d.batting_team = m.winner) /COUNT(DISTINCT d.match_id), 2) AS win_rate
		FROM deliveries d
		JOIN matches m ON d.match_id = m.id
		WHERE d.inning = 2
		GROUP BY d.batting_team
		HAVING COUNT(DISTINCT d.match_id) >= 20
		ORDER BY win_rate DESC
		LIMIT 5;

