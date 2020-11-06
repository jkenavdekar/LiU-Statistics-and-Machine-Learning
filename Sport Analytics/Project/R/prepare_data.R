library(stringr)
prepare_data <- function(game, type){
  game_shots <- game[which(game$name %in% c("shot")),]

  if(length(game[1,]) == 44 & type == 1){
    print('I am in')
    game <- game[,-20]
    game_shots <- game_shots[,-20]
    
    print(length(game[1,]))
    
   # game_shots$opposingTeamGoalieOnIceRef <- as.factor(game_shots$opposingTeamGoalieOnIceRef)
    
  }
  if(length(game[1,]) == 45 & type == 2){
    game_shots <- game_shots[,-20]
  #  game_shots$opposingTeamGoalieOnIceRef <- as.factor(game_shots$opposingTeamGoalieOnIceRef)
  #  game_shots$goalieLastName <- as.factor(game_shots$goalieLastName)
    
  }

  if(type == 1){
    reference_players <- game[,40:42] %>% distinct()
    reference_goalies <- reference_players[
      reference_players$playerReferenceId %in% game$teamGoalieOnIceRef, ]
    colnames(reference_goalies) <- 
      c("goalieFirstName", "goalieLastName", "opposingTeamGoalieOnIceRef")

    game_shots <- game_shots %>% 
      left_join(reference_goalies, by = "opposingTeamGoalieOnIceRef")
    #refs <- strsplit(as.character(game_shots$teamForwardsOnIceRef[1]), ",")
    #refs <- str_replace_all(string=refs, pattern=" ", repl="")
  #  game_shots$teamForwardsOnIceRef <- strsplit(as.character(game_shots$teamForwardsOnIceRef[1]), ",")[[1]]
 #   if(' 499' %in% strsplit(as.character(game_shots$teamForwardsOnIceRef[1]), ",")[[1]]){
#      print('wohooooooooooo')
 #   }
  #  print(as.character(game_shots$teamForwardsOnIceRef[1]))
    game_shots$goalieLastName <- as.factor(game_shots$goalieLastName)
    
  }
 
  
  game_shots$playerPosition <- as.factor(game_shots$playerPosition)
  numPlayers <- paste(game_shots$teamSkatersOnIce, game_shots$opposingTeamSkatersOnIce, sep = "vs")
  game_shots$numPlayers <- numPlayers
  game_shots$Blocked <- as.factor(as.numeric(grepl("blocked", game_shots$type)))
  game_shots$Deflected <- as.factor(as.numeric(grepl("deflected", game_shots$type)))
  game_shots$type <- gsub("blocked", "", game_shots$type)
  game_shots$type[game_shots$type=="deflected"] <-
    ifelse( abs(game_shots$yAdjCoord[game_shots$type=="deflected"])<21.5 && 
              game_shots$xAdjCoord[game_shots$type=="deflected"]>54,
            "slot", "outside" )
  
  # NOTE: we will rename the deflected shots as "slot" type if they fall between
  # the centers of the two circles (+/-21.5) and at a maximum distance from the goal
  # corresponding to the lower limit of the circle (54)
  print(game_shots[1:5,])
  print(game_shots$Deflected)
  print(game_shots[1:5,48])
  
  if(type == 1){
    game_shots <- game_shots[,c(25, 26, 16, 18, 19, 3, 28, 7, 40:47, 5, 39, 30, 31, 34, 35, 48)]
  }
  if(type == 2){
    game_shots <- game_shots[,c(25, 26, 16, 18, 19, 3, 28, 7, 40:47, 5, 39, 30, 31, 34, 35)]
  }
  print(game_shots$Deflected)
  
  game_goals <- game[which((game$name == "goal") & (!is.na(game$yAdjCoord))),]
  game_shots$goalieLastName <- as.factor(game_shots$goalieLastName)
  levels(game_shots$outcome)
  levels(game_shots$outcome) = c('', 'failed', 'successful', 'undetermined', 'goal')
  for(i in (1:nrow(game_goals))){
    game_shots[which((game_shots$yAdjCoord==game_goals$yAdjCoord[i]) &
                       (game_shots$xAdjCoord==game_goals$xAdjCoord[i])),5] = as.factor("goal")
  }
  
  
  names(game_shots)[1:2] <- c("yAdjCoord", "xAdjCoord")
  game_shots <- game_shots[(game_shots$yAdjCoord > 0),]
  if(type == 1){
    game_shots$hover_info <- rep("",nrow(game_shots))
    for(i in 1:nrow(game_shots)){
      dist <- sqrt(((game_shots$yAdjCoord[i]-89)^2 + game_shots$xAdjCoord[i]^2))
      angle <- atan2(game_shots$xAdjCoord[i],89-game_shots$yAdjCoord[i]) * 180 /pi
      game_shots$hover_info[i] <- 
        paste('Shooter:', game_shots$playerFirstName[i], game_shots$playerLastName[i], 
              '\nDistance:', round(dist, digits = 1), "ft", 
              '\nAngle:', round(angle, digits = 1), "°", 
              "\nGoalie:", game_shots$goalieFirstName[i], game_shots$goalieLastName[i])
    }
  }
  
  game_shots$outcome <- factor(game_shots$outcome)
  game_shots$name <- factor(game_shots$name)
  
  print("Successful load")
  return(game_shots)
}