preprocess_file_2_fun <- function(game_shots, type, numPlayers, playerName, goalieName, time_range1, time_range2, time_range3, time_range4, player_position, team, player_ref, Match, period, outcome, powerplays, zone, blocked, deflected){
  
  
  game_shots <- game_shots[which(game_shots$period %in% period),]
  
  game_shots <- game_shots[which(game_shots$outcome %in% outcome),]
  
  game_shots <- game_shots[which(game_shots$type %in% zone),]
  
  game_shots <- game_shots[which(game_shots$Blocked %in% blocked),]
  
  game_shots <- game_shots[which(game_shots$Deflected %in% deflected),]
  
  
  
  
  game_shots <- game_shots[which(game_shots$manpowerSituation %in% powerplays),]

print(player_ref)
print(player_ref)
print(length(player_ref))

  if(dim(game_shots)[1]>0){
    if(type==1){
      if(is.null(player_ref) == FALSE){
        onIce <- rep(0,length(game_shots[,1]))
        for(i in 1:length(game_shots[,1])){
          for(j in 1: length(player_ref)){
            if(paste('',player_ref[j]) %in% strsplit(as.character(game_shots$teamForwardsOnIceRef[i]), ",")[[1]] |
               paste('',player_ref[j]) %in% strsplit(as.character(game_shots$opposingTeamForwardsOnIceRef[i]), ",")[[1]] |
               paste('',player_ref[j]) %in% strsplit(as.character(game_shots$teamDefencemenOnIceRef[i]), ",")[[1]] |
               paste('',player_ref[j]) %in% strsplit(as.character(game_shots$opposingTeamDefencemenOnIceRef[i]), ",")[[1]] |
               paste('\t',player_ref[j], sep = '') %in% strsplit(as.character(game_shots$teamForwardsOnIceRef[i]), ",")[[1]] |
               paste('\t',player_ref[j], sep = '') %in% strsplit(as.character(game_shots$opposingTeamForwardsOnIceRef[i]), ",")[[1]] |
               paste('\t',player_ref[j], sep = '') %in% strsplit(as.character(game_shots$teamDefencemenOnIceRef[i]), ",")[[1]] |
               paste('\t',player_ref[j], sep = '') %in% strsplit(as.character(game_shots$opposingTeamDefencemenOnIceRef[i]), ",")[[1]]){
               onIce[i] <- onIce[i] + 1
            }
            }
            
          }

        game_shots <- game_shots[which(onIce == length(player_ref)),]
      }
    }
  }

  # 
  
  
  if(type==1){game_shots <- game_shots[which(game_shots$Match %in% Match),]}
  
  game_shots <- game_shots[which(game_shots$numPlayers %in% numPlayers),]
  if(type==1){game_shots <- game_shots[which(game_shots$playerLastName %in% playerName),]}
  game_shots <- game_shots[which(game_shots$playerPosition %in% player_position),]
  
  
  if(length(which(game_shots$gameTime<60*time_range1[1] & game_shots$gameTime>=0))>0)
    game_shots <- game_shots[-which(game_shots$gameTime<60*time_range1[1] & game_shots$gameTime>=0),]
  if(length(which(game_shots$gameTime>60*time_range1[2] & game_shots$gameTime<20*60))>0)
    game_shots <- game_shots[-which(game_shots$gameTime>60*time_range1[2] & game_shots$gameTime<20*60),]
  
  if(length(which(game_shots$gameTime<60*time_range2[1] & game_shots$gameTime>=20*60))>0)
    game_shots <- game_shots[-which(game_shots$gameTime<60*time_range2[1] & game_shots$gameTime>=20*60),]
  if(length(which(game_shots$gameTime>60*time_range2[2] & game_shots$gameTime<40*60))>0)
    game_shots <- game_shots[-which(game_shots$gameTime>60*time_range2[2] & game_shots$gameTime<40*60),]
  
  if(length(which(game_shots$gameTime<60*time_range3[1] & game_shots$gameTime>=40*60))>0)
    game_shots <- game_shots[-which(game_shots$gameTime<60*time_range3[1] & game_shots$gameTime>=40*60),]
  if(length(which(game_shots$gameTime>60*time_range3[2] & game_shots$gameTime<60*60))>0)
    game_shots <- game_shots[-which(game_shots$gameTime>60*time_range3[2] & game_shots$gameTime<60*60),]
  
  if(length(which(game_shots$gameTime<60*time_range4[1] & game_shots$gameTime>=60*60))>0)
    game_shots <- game_shots[-which(game_shots$gameTime<60*time_range4[1] & game_shots$gameTime>=60*60),]
  if(length(which(game_shots$gameTime>60*time_range4[2] & game_shots$gameTime<60*max_time))>0)
    game_shots <- game_shots[-which(game_shots$gameTime>60*time_range4[2] & game_shots$gameTime<60*max_time),]
  
  # print(unique(game_shots$goalieLastName))
  # game_shots <- game_shots[which(game_shots$gameTime between  )]
  if(type==1){game_shots <- game_shots[which(game_shots$goalieLastName %in% goalieName),]}
  
  if(type==1){game_shots <- game_shots[which(game_shots$teamInPossession %in% team),]}
  
  return(game_shots)
}