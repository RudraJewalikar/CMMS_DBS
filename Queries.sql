USE CMMS;


-- 1. Create a table for players with fields such as player_id, player_name, player_age, player_position, and team_id.
CREATE TABLE Player (
  player_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  player_name VARCHAR(50) NOT NULL,
  player_age INT,
  player_position VARCHAR(50),
  team_id INT,
  FOREIGN KEY (team_id) REFERENCES Team(team_id)
);

-- 2. Create a table for teams with fields such as team_id, team_name, coach_name, and home_ground.
CREATE TABLE Team (
  team_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  coach_name VARCHAR(50),
  home_ground VARCHAR(50) UNIQUE
);
CREATE TABLE Team_Name (
  team_id INT,
  team_name VARCHAR(50) UNIQUE NOT NULL,
  PRIMARY KEY (team_id, team_name),
  FOREIGN KEY (team_id) REFERENCES Team(team_id)
);

-- 3. Create a table for matches with fields such as match_id, match_date, location, and winner_team_id.
CREATE TABLE Matches (
  match_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  match_date DATE NOT NULL,
  location VARCHAR(50) NOT NULL,
  team1_id INT NOT NULL,
  team2_id INT NOT NULL,
  result INT,
  FOREIGN KEY (team1_id) REFERENCES Team(team_id),
  FOREIGN KEY (team2_id) REFERENCES Team(team_id),
  FOREIGN KEY (result) REFERENCES Team(team_id)
);

-- 4. Create a table for scores with fields such as score_id, match_id, player_id, runs_scored, wickets_taken, and overs_bowled.
CREATE TABLE Match_Score (
  match_id INT NOT NULL,
  team_id INT NOT NULL,
  runs_scored INT NOT NULL,
  wickets_taken INT NOT NULL,
  overs_played FLOAT NOT NULL,
  PRIMARY KEY (match_id, team_id),
  FOREIGN KEY (match_id) REFERENCES Matches(match_id),
  FOREIGN KEY (team_id) REFERENCES Team(team_id)
);
CREATE TABLE Batting_Score (
  match_id INT NOT NULL,
  player_id INT NOT NULL,
  runs_scored INT NOT NULL,
  overs_played FLOAT NOT NULL,
  PRIMARY KEY (match_id, player_id),
  FOREIGN KEY (match_id) REFERENCES Matches(match_id),
  FOREIGN KEY (player_id) REFERENCES Player(player_id)
);
CREATE TABLE Bowling_Score (
  match_id INT NOT NULL,
  player_id INT NOT NULL,
  wickets_taken INT NOT NULL,
  overs_bowled FLOAT NOT NULL,
  PRIMARY KEY (match_id, player_id),
  FOREIGN KEY (match_id) REFERENCES Matches(match_id),
  FOREIGN KEY (player_id) REFERENCES Player(player_id)
);

-- 5. Add a foreign key constraint between the player and team tables, linking the team_id field in the player table to the team_id field in the team table.
ALTER TABLE Player ADD FOREIGN KEY (team_id) REFERENCES Team(team_id);

-- 6. Insert a new player record with player_name “Virat Kohli”, player_age 33, player_position “Batsman”, and team_id 1.
INSERT INTO Player (player_name, player_age, player_position, team_id) 
VALUES ('Virat Kohli', 33, 'Batsman', 1);

-- 7. Update the coach_name for team_id 1 to “Ravi Shastri”.
UPDATE Team SET coach_name = 'Ravi Shastri' WHERE team_id = 1;

-- 8. Delete all records from the scores table where runs_scored is less than 50.
DELETE FROM Match_Score WHERE runs_scored < 50;

-- 9. Insert a new match record with match_date “2022-03-15", location “Mumbai”, and competing team_ids 1 and 2.
INSERT INTO Matches (match_id, match_date, location, team1_id, team2_id) VALUES (13, '2022-03-15', 'Mumbai', 1, 2);

-- 10. Update the winner_team_id for match_id 1 to 1.
UPDATE Matches SET result = 1 WHERE match_id = 13;

-- 11. Retrieve the highest runs_scored by a player in a match.
SELECT MAX(runs_scored)
FROM Batting_Score;

-- 12. Retrieve the total number of matches won by each team.
SELECT t.team_name, COUNT(*) AS wins 
FROM Team_Name t 
INNER JOIN Matches m ON t.team_id = m.result 
GROUP BY t.team_name;

-- 13. Retrieve the average age of players in a team.
SELECT t.team_name, AVG(p.player_age) AS avg_age 
FROM Team_Name t
INNER JOIN Player p ON t.team_id = p.team_id
GROUP BY t.team_name;

-- 14. Retrieve the highest wickets_taken by a player in a match.
SELECT MAX(wickets_taken) FROM Bowling_Score;

-- 15. Retrieve the team with the most number of runs_scored across all matches.
SELECT t.team_name, SUM(m.runs_scored) AS total_runs 
FROM Team_Name t, Match_Score m
WHERE m.team_id = t.team_id
GROUP BY t.team_name 
ORDER BY total_runs 
DESC LIMIT 1;

-- 16. Retrieve the player_name and player_position for all players in a specific team.
SELECT player_name, player_position
FROM Player
WHERE team_id = 1;

-- 17. Retrieve the team_name and coach_name for all matches won by a specific team.
SELECT n.team_name, t.coach_name
FROM Team t
JOIN Team_Name n ON t.team_id = n.team_id
JOIN Matches m ON m.result = t.team_id
WHERE t.team_id = 5;

-- 18. Retrieve the match_date, location, and player_name for all matches played by a specific player.
SELECT Matches.match_date, Matches.location, Player.player_name
FROM Matches 
INNER JOIN Batting_Score ON Matches.match_id = Batting_Score.match_id 
INNER JOIN Player ON Batting_Score.player_id = Player.player_id 
WHERE Player.player_name = 'Andrew Tye'
UNION
SELECT Matches.match_date, Matches.location, Player.player_name
FROM Matches 
INNER JOIN Bowling_Score ON Matches.match_id = Bowling_Score.match_id 
INNER JOIN Player ON Bowling_Score.player_id = Player.player_id 
WHERE Player.player_name = 'Andrew Tye';

-- 19. Retrieve the team_name, match_date, and runs_scored for all matches where a specific player scored more than 100 runs.
SELECT Team_Name.team_name, Matches.match_date, Batting_Score.runs_scored
FROM Matches 
INNER JOIN Batting_Score ON Matches.match_id = Batting_Score.match_id 
INNER JOIN Player ON Batting_Score.player_id = Player.player_id 
INNER JOIN Team_Name ON Player.team_id = Team_Name.team_id 
WHERE Player.player_name = 'Virat Kohli' AND Batting_Score.runs_scored > 100;

-- 20. Retrieve the player_name, match_date, and wickets_taken for all matches where a specific player took more than 3 wickets.
SELECT p.player_name, m.match_date, bs.wickets_taken
FROM Bowling_Score bs
INNER JOIN Player p ON bs.player_id = p.player_id
INNER JOIN Matches m ON bs.match_id = m.match_id
WHERE bs.wickets_taken > 3 AND p.player_name = 'Andrew Tye';