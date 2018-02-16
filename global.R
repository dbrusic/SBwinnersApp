#load data
sbTeams_basic <- read.csv("sbTeams_basic.csv")
#take out index column ("X")
sbTeams_basic <- sbTeams_basic[, -1]
#take out penalties column ("O.penaltyyardspergame")
sbTeams_basic <- sbTeams_basic[, -12]
# for turnover differential: number of turnovers caused minus turnovers
# lost (positive value better)
sbTeams_winners <- sbTeams_basic[1:52, ]
sbTeams_losers <- sbTeams_basic[53:104, ]
diff_df <- cbind(sbTeams_winners[,1:3], sbTeams_winners[,4:22] - sbTeams_losers[,4:22])
#take out numberofpostseasongames column
diff_df <- diff_df[,1:21]
