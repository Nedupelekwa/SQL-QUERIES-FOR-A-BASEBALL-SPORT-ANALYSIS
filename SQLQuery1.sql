--- LAST PITCHING RAYS DATA

SELECT *
  FROM [my trials].dbo.[LastPitchRays]

  --- RAYS PITCHING STATISTIC

SELECT *
  FROM [my trials].dbo.[RaysPitchingStats]



  --Question 1 AVG Pitches Per at Bat Analysis

--1a AVG Pitches Per At Bat (LastPitchRays)

select AVG(Pitch_number)AvgPitchesPerAtBat
from [my trials].dbo.[LastPitchRays]


--1b AVG Pitches Per At Bat Home Vs Away (LastPitchRays) -> Union

select
'home' TypeOfGame,
	AVG(1.00*Pitch_number) AvgPitchesPerAtBat
from [my trials].dbo.[LastPitchRays]
where home_team = 'TB'
union
select
'away' TypeOfGame,
	AVG(1.00*Pitch_number) AvgPitchesPerAtBat
from [my trials].dbo.[LastPitchRays]
where away_team = 'TB'


--1c AVG Pitches Per At Bat Lefty Vs Righty  -> Case Statement 
select
	AVG(Case when batter_position = 'L' Then 1.00*Pitch_number end) LeftyatBats,
	AVG(Case when batter_position = 'R' Then 1.00*Pitch_number end) RightyatBats
	from [my trials].dbo.[LastPitchRays]


--1d AVG Pitches Per At Bat Lefty Vs Righty Pitcher | Each Away Team -> Partition By

SELECT DISTINCT
home_team,
Pitcher_position,
AVG(1.00*Pitch_number) over(partition by home_team, pitcher_position)
from [my trials].dbo.[LastPitchRays]
where away_team = 'TB'


--1e Top 3 Most Common Pitch for at bat 1 through 10, and total amounts (LastPitchRays)

select distinct
	Player_name,
	Pitch_number,
	count(player_name) over (partition by Player_name, Pitch_number) PitchNumbers
from [my trials].dbo.[LastPitchRays]
where Pitch_number < 11


--1f AVG Pitches Per at Bat Per Pitcher with 20+ Innings | Order in descending (LastPitchRays + RaysPitchingStats)

select
	RPS.Name,
	AVG(1.00 * Pitch_number) AVGPitches
from [my trials].dbo.[LastPitchRays] LPR
JOIN [my trials].dbo.[RaysPitchingStats] RPS ON RPS.pitcher = LPR.pitcher
where IP >= 20
Group by RPS.Name 
Order by AVG(1.00 * Pitch_number) DESC


--Question 2 Last Pitch Analysis

--2a Count of the different last events Fastball or Offspeed (LastPitchRays)

select
	sum(case when events in ('4-seam Fastball','cutter') then 1 else 0 end) Fastball,
	sum(case when events not in ('4-seam Fastball','cutter') then 1 else 0 end) Offspeed
from [my trials].[dbo.LastPitchRays]

select*
from [my trials].dbo.[LastPitchRays]

--
--2b Percentage of the different last events Fastball or Offspeed (LastPitchRays)
select
	100 * sum(case when events in ('4-seam Fastball','cutter') then 1 else 0 end)/ count (*) FastballPercent,
	100 * sum(case when events not in ('4-seam Fastball','cutter') then 1 else 0 end)/ count (*) OffspeedPercent
from [my trials].dbo.[LastPitchRays]


--2c Top 5 Most common last pitch for a Relief Pitcher vs Starting Pitcher (LastPitchRays + RaysPitchingStats)
select*
a.POS,
a.pitch_name,
a.timesthrown,
RANK () OVER (PARTITION BY a.POS order by a.timesthrown desc) PitchRank
FROM(
SELECT*
from [my trials].dbo.[LastPitchRays] LPR
JOIN [my trials].dbo.[RaysPitchingStats] RPS ON pitcher_id = LPR.pitcher
group by RPS.POS, LPR.pitch_name

--Question 3 Shane McClanahan

--3a AVG Release speed, spin rate,  strikeouts, most popular zone ONLY USING LastPitchRays

SELECT
	AVG(release_speed) AvgReleaseSpin,
	AVG(release_spin_rate) AvgSpinRate,
	Sum(case when events = 'strikeout' then 1 else 0 end) strikeouts
	from [my trials].dbo.[LastPitchRays]
	where player_name = 'McClanahan, Shane'

	select zone, count (*)
	from [my trials].dbo.[LastPitchRays] LPR
	where player_name = 'McClanahan, Shane'
	group by zone
	order by count (*) desc


	---3b number of events played per category in descending order

	select events, count(*)
	from [my trials].dbo.[LastPitchRays]
	group by events
	order by count (*) desc


	--3c top pitches for each infield position where total pitches are over 5, rank them

	select *
	from (
		select pitch_name, count (*) timeshit, 'Third' position
		from [my trials].dbo.[LastPitchRays]
		where hit_location = 5 and player_name = 'McClanahan, Shane'
		group by pitch_name
		union
		select pitch_name, count (*) timeshit, 'Short' position
		from [my trials].dbo.[LastPitchRays]
		where hit_location = 6 and player_name = 'McClanahan, Shane'
		group by pitch_name
		union
		select pitch_name, count (*) timeshit, 'Second' position
		from [my trials].dbo.[LastPitchRays]


--3d Show different balls/strikes as well as frequency when someone is on base 
select balls, strikes, count(*) frequency
		from [my trials].dbo.[LastPitchRays]
		where(on_3b is not null or on_2b is not null or on_1b is not null)
		and player_name = 'McClanahan, Shane'
		group by balls, strikes
		order by count(*) desc


--3e What pitch causes the lowest launch speed

select top 1 pitch_name, avg(launch_speed * 1.00) LaunchSpeed
		from [my trials].dbo.[LastPitchRays]
		where player_name = 'McClanahan, Shane'
		group by pitch_name
		order by avg(launch_speed)

