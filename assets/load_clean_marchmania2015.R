# this file assumes you've downloaded CSVs from 
# https://www.kaggle.com/c/march-machine-learning-mania-2015/data 
# and placed them on the provided path
# (empty string should search current working directory)
load.clean.ncaa = function(data.dir){
	# ------------------------------------------------------------------------------
	# load libraries:
	# ------------------------------------------------------------------------------
	message("Loading libraries...")
	pkgs.req = c("dplyr", "lubridate") # dplyr::rbind_all, lubridate::mdy
	temp = sapply(pkgs.req, function(p) if(!require(p, character.only = TRUE)){
		install.packages(p);library(p, character.only=TRUE)})

	# ------------------------------------------------------------------------------
	# load data:
	# ------------------------------------------------------------------------------
	message("Loading CSVs...")
	if(length(grep(paste(.Platform[["file.sep"]],"$",sep=""), data.dir))==0){
		data.dir = paste(data.dir, .Platform[["file.sep"]], sep="")
	}
	# there may be other CSV files in this directory... let's specify the list manually rather than using list.files()
	csvs.to.load = c("teams", "seasons", "regular_season_compact_results", "regular_season_detailed_results", 
		"tourney_compact_results", "tourney_detailed_results", "tourney_seeds", "tourney_slots")
	# will convert strings to factors later. easier for merging if they stay strings for now.
	march.mania.df.list = sapply(csvs.to.load, 
		function(fn) read.csv(paste(data.dir,.Platform[["file.sep"]],fn,".csv",sep=""), stringsAsFactors=FALSE))

	# ------------------------------------------------------------------------------
	# clean/merge/summarize data:
	# ------------------------------------------------------------------------------
	message("Cleaning data...")
	# merge together the compact and detailed records for "regular season" games
	march.mania.df.list$regular_season_results = merge(
		march.mania.df.list$regular_season_compact_results, 
		march.mania.df.list$regular_season_detailed_results, 
		all = TRUE)
	march.mania.df.list$regular_season_results$game.type = "Regular Season"

	# merge together the compact and detailed records for NCAA tournament games
	march.mania.df.list$tourney_results = merge(
		march.mania.df.list$tourney_compact_results, 
		march.mania.df.list$tourney_detailed_results, 
		all = TRUE)
	march.mania.df.list$tourney_results$game.type = "Tournament"

	# parse the tournament seed information
	# convert seed.region and seed.playin to factors later
	march.mania.df.list$tourney_seeds$seed.region = substr(march.mania.df.list$tourney_seeds$seed, 1, 1)
	march.mania.df.list$tourney_seeds$seed.playin = substr(march.mania.df.list$tourney_seeds$seed, 4, 4)
	march.mania.df.list$tourney_seeds$seed = as.numeric(substr(march.mania.df.list$tourney_seeds$seed, 2, 3))

	# merge the tournament seed info in with the tournament game info separately for winning and losing teams
	march.mania.df.list$tourney_results = merge(
		march.mania.df.list$tourney_results, 
		march.mania.df.list$tourney_seeds, 
		by.x = c("season", "lteam"), 
		by.y = c("season", "team"),
		all.x = TRUE)
	colnames(march.mania.df.list$tourney_results)[grep("^seed",colnames(march.mania.df.list$tourney_results))] = paste(
		"l", grep("^seed",colnames(march.mania.df.list$tourney_results), value=TRUE), sep="")
	march.mania.df.list$tourney_results = merge(
		march.mania.df.list$tourney_results, 
		march.mania.df.list$tourney_seeds, 
		by.x = c("season", "wteam"), 
		by.y = c("season", "team"),
		all.x = TRUE)
	colnames(march.mania.df.list$tourney_results)[grep("^seed",colnames(march.mania.df.list$tourney_results))] = paste(
		"w", grep("^seed",colnames(march.mania.df.list$tourney_results), value=TRUE), sep="")

	# stack all games together into one giant data.frame
	march.mania.df.list$game_results = rbind_all(march.mania.df.list[c("regular_season_results","tourney_results")])
	# replace blanks with NA's
	repl.blank.with.na = function(col){
		col[col==""] = NA
		return(col)
	}
	str.to.fac = c("wseed.region","wseed.playin","lseed.region","lseed.playin","game.type")
	march.mania.df.list$game_results[,str.to.fac[1:4]] = sapply(march.mania.df.list$game_results[,str.to.fac[1:4]], repl.blank.with.na)
	# sapply can't be used here -- converts to character and nullifies the as.factor()
	march.mania.df.list$game_results[,str.to.fac] = as.data.frame(lapply(march.mania.df.list$game_results[,str.to.fac], as.factor))
	march.mania.df.list$game_results$wloc = factor(as.character(march.mania.df.list$game_results$wloc), 
		levels=c("H","A","N"), labels=c("Home","Away","Neutral"))

	# label the teams with their names, but keep their IDs too
	march.mania.df.list$game_results[,c("wteam.name","lteam.name")] = as.data.frame(lapply(march.mania.df.list$game_results[,c("wteam","lteam")],
		factor, levels=march.mania.df.list$teams$team_id, labels=march.mania.df.list$teams$team_name))

	# Create a unique game key for winning and losing teams by exploiting the fact that no teams ever played >1 game on a given date
	march.mania.df.list$game_results$wteam.game.id = apply(march.mania.df.list$game_results[,c("season","daynum","wteam")], 
		1, paste, collapse="_")
	march.mania.df.list$game_results$lteam.game.id = apply(march.mania.df.list$game_results[,c("season","daynum","lteam")], 
		1, paste, collapse="_")

	# For predictions, we need to recode the teams into "team1" and "team2" rather than "winner" and "loser"
	march.mania.df.list$game_results$team1 = apply(march.mania.df.list$game_results[,c("wteam","lteam")], 1, min)
	march.mania.df.list$game_results$team2 = apply(march.mania.df.list$game_results[,c("wteam","lteam")], 1, max)
	march.mania.df.list$game_results$game.id.matchup = apply(march.mania.df.list$game_results[,c("season","team1","team2")], 
	1, paste, collapse="_")
	march.mania.df.list$game_results$game.id.unique = apply(march.mania.df.list$game_results[,c("season","daynum","team1","team2")], 
		1, paste, collapse="_")
	march.mania.df.list$game_results$team1.win = with(march.mania.df.list$game_results,as.numeric(team1==wteam))

	# change [game day-dayzero] to correct dates
	march.mania.df.list$game_results = merge(march.mania.df.list$game_results, march.mania.df.list$seasons[,c("season","dayzero")])
	march.mania.df.list$game_results$dayzero = mdy(as.character(march.mania.df.list$game_results$dayzero))
	march.mania.df.list$game_results$date = march.mania.df.list$game_results$dayzero + days(march.mania.df.list$game_results$daynum)

	# new data frame of team results
	# be sure not to name any columns above starting with "w" or "l" unless you really mean it!
	# "loc" starts with "l" so process the "l" first
	march.mania.df.list$winner_results = march.mania.df.list$game_results
	colnames(march.mania.df.list$winner_results)[grep("^l", colnames(march.mania.df.list$winner_results))] = gsub("^l","opp.",colnames(march.mania.df.list$winner_results)[grep("^l", colnames(march.mania.df.list$winner_results))])
	colnames(march.mania.df.list$winner_results)[grep("^w", colnames(march.mania.df.list$winner_results))] = gsub("^w","",colnames(march.mania.df.list$winner_results)[grep("^w", colnames(march.mania.df.list$winner_results))])
	march.mania.df.list$winner_results$opp.loc = factor(as.character(march.mania.df.list$winner_results$loc), 
		levels=c("Home","Away","Neutral"), labels=c("Away","Home","Neutral"))
	march.mania.df.list$winner_results$result = "Win"

	march.mania.df.list$loser_results = march.mania.df.list$game_results
	colnames(march.mania.df.list$loser_results)[grep("^l", colnames(march.mania.df.list$loser_results))] = gsub("^l","",colnames(march.mania.df.list$loser_results)[grep("^l", colnames(march.mania.df.list$loser_results))])
	colnames(march.mania.df.list$loser_results)[grep("^w", colnames(march.mania.df.list$loser_results))] = gsub("^w","opp.",colnames(march.mania.df.list$loser_results)[grep("^w", colnames(march.mania.df.list$loser_results))])
	march.mania.df.list$loser_results$loc = factor(as.character(march.mania.df.list$loser_results$opp.loc), 
		levels=c("Home","Away","Neutral"), labels=c("Away","Home","Neutral"))
	march.mania.df.list$loser_results$result = "Loss"

	march.mania.df.list$team_results = rbind_all(march.mania.df.list[c("winner_results","loser_results")])
	march.mania.df.list$team_results$result = as.factor(march.mania.df.list$team_results$result)

	ncaa.team.results = march.mania.df.list$team_results
	ncaa.game.results = march.mania.df.list$game_results
	tourney.slots = march.mania.df.list$tourney_slots
	tourney.regions = march.mania.df.list$seasons[,-which(colnames(march.mania.df.list$seasons)=="dayzero")]

	message("Done.")
	return(list(teams = ncaa.team.results, games = ncaa.game.results))
}
# fgm - field goals made
# fga - field goals attempted
# fgm3 - three pointers made
# fga3 - three pointers attempted
# ftm - free throws made
# fta - free throws attempted
# or - offensive rebounds
# dr - defensive rebounds
# ast - assists
# to - turnovers
# stl - steals
# blk - blocks
# pf - personal fouls
# numot - overtime periods in the game
# season - the year in which the *tournament* was played