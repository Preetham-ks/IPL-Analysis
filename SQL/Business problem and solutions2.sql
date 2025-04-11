select * from matches
select * from deliveries

-- Advanced Business Problems And Solutions

-- Best Finishers (Highest Strike Rate in Last 5 Overs)
	SELECT batter,
	       ROUND(SUM(batsman_runs)*100.0 / COUNT(*), 2) AS strike_rate
	FROM deliveries
	WHERE overs >= 16
	GROUP BY batter
	HAVING COUNT(*) > 30
	ORDER BY strike_rate DESC
	LIMIT 5;

-- batsmen with most 50+ scores and their strike rates
	WITH batsman_stats AS (
	    SELECT 
	        batter,
	        match_id,
	        SUM(batsman_runs) AS runs,
	        COUNT(ball) AS balls_faced
	    FROM deliveries
	    GROUP BY batter, match_id
	    HAVING SUM(batsman_runs) >= 50
	)
	SELECT 
	    batter AS batsman,
	    COUNT(*) AS fifties,
	    ROUND(AVG(runs * 100.0 / balls_faced), 2) AS avg_strike_rate
	FROM batsman_stats
	GROUP BY batter
	ORDER BY fifties DESC
	LIMIT 10;

-- List bowlers who have bowled the most maiden overs
	WITH RunsPerOver AS (
	    SELECT
	        match_id,
	        inning,
	        overs,
	        bowler,
	        SUM(total_runs) AS runs_in_over
	    FROM deliveries
	    GROUP BY match_id, inning, overs, bowler
	)
	SELECT bowler, COUNT(*) AS maiden_overs
	FROM RunsPerOver
	WHERE runs_in_over = 0
	GROUP BY bowler
	ORDER BY maiden_overs DESC
	limit 10;

-- Find the best batter (highest strike rate) in each IPL season.
	SELECT season, batter, total_runs, total_balls, strike_rate
	FROM (
	  SELECT 
	    m.season,
	    d.batter,
	    SUM(d.batsman_runs) AS total_runs,
	    COUNT(*) AS total_balls,
	    ROUND(SUM(d.batsman_runs) * 100.0 / COUNT(*), 2) AS strike_rate,
	    ROW_NUMBER() OVER (PARTITION BY m.season ORDER BY SUM(d.batsman_runs) * 1.0 / COUNT(*) DESC) AS rnk
	  FROM deliveries d
	  JOIN matches m ON d.match_id = m.id
	  GROUP BY m.season, d.batter
	) ranked
	WHERE rnk = 1
	ORDER BY season;

-- Team with Best Performance While Chasing in each season
	WITH stats AS (
	  SELECT
	    season,
	    team2 AS team,
	    COUNT(*) AS chases,
	    COUNT(*) FILTER (WHERE winner = team2) AS wins,
	    ROUND(COUNT(*) FILTER (WHERE winner = team2) * 100.0 / COUNT(*), 2) AS rate,
	    RANK() OVER (PARTITION BY season ORDER BY COUNT(*) FILTER (WHERE winner = team2) * 1.0 / COUNT(*) DESC) AS rnk
	  FROM matches
	  WHERE target_runs IS NOT NULL
	  GROUP BY season, team2
	)
	SELECT season, team, chases, wins, rate
	FROM stats
	WHERE rnk = 1
	ORDER BY season;