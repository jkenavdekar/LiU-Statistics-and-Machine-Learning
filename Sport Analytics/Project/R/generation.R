generation <- function() {
  
  # Generate a random length (on average 40 shots per match per side)
  n <- round(rnorm(1, 160, 10))
  generated <- data.frame(yAdjCoord = rep(NA, n))
  
  # Fake coords
  generated$yAdjCoord <- abs(rnorm(n, 70, 20))
  generated$yAdjCoord[generated$yAdjCoord>90] <- 
    generated$yAdjCoord[generated$yAdjCoord>90] - 
    (generated$yAdjCoord[generated$yAdjCoord>90]-70)/2
  generated$xAdjCoord <- runif(n, -39.5, 39.5)
  
  generated$name <- "shot"
  generated$type <- ifelse(abs(generated$yAdjCoord)<21.5 && generated$xAdjCoord>54,
                           "slot", "outside")
  
  # Goals really unlikely
  generated$outcome <- sample(c("goal", "successful", "failed"), 
                              n,
                              replace = T,
                              prob = c(0.15, 0.4, 0.45))
  
  # Only 10% in overtime
  generated$period <- sample(1:4,
                             n,
                             replace = T,
                             prob = c(0.3, 0.3, 0.3, 0.1))
  
  # Unbalance in 30%
  generated$manpowerSituation <- sample(c("evenStrength", "powerPlay", "shortHanded"),
                                        n,
                                        replace = T,
                                        prob = c(0.7, 0.15, 0.15))
  
  # Decided based on the shooters
  generated$teamInPossession <- NA
  
  # Names and last names of the players (first two are goalie, next four are defenders,
  # the remaining are forwards)
  names_teamA <- c("Harvey", "Karl", "Ronald", "John", "Bruno", "C. R.", 
                   "George W.", "Jerzy", "Harald", "Thomas", "David", "Joseph",
                   "Egon", "Hirotugu", "Corrado", "Pafnuty")
  surnames_teamA <- c("Goldstein", "Pearson", "Fisher", "Tukey", "de Finetti", "Rao",
                      "Snedecor", "Neyman", "Cramer", "Bayes", "Cox", "Kruskal",
                      "Pearson", "Akaike", "Gini", "Chebyshev")
  referenceA <- 1:16
  names_teamB <- c("Abraham", "Alan", "", "Brook", "Augustin-Louis",
                   "Bernhard", "David", "Edward", "Giuseppe", "Gottfried",
                   "John", "John", "Joseph", "Joseph Louis", "Leonhard", "Pierre-Simon")
  surnames_teamB <- c("De Moivre", "Turing", "Archimedes", "Taylor", "Cauchy",
                      "Riemann", "Hilbert", "Lorenz", "Peano", "Leibniz",
                      "Nash", "Von Neumann", "Fourier", "Lagrange", "Euler", "Laplace")
  referenceA <- 17:32
  merged_names <- c(names_teamA, names_teamB)
  merged_surnames <- c(surnames_teamA, surnames_teamB)
  ind_shooters <- sample(c(3:16, 19:32), n, replace = T)
  generated$playerFirstName <- merged_names[ind_shooters]
  generated$playerLastName <- merged_surnames[ind_shooters]
  generated$playerReferenceId <- ind_shooters
  generated$Match <- c(rep("Statisticians vs Mathematicians - ??/??", floor(n/2)),
                       rep("Mathematicians vs Statisticians - ??/??", ceiling(n/2)))
  
  # Gotta fix the team in possession
  generated$teamInPossession <- 
    ifelse(generated$playerReferenceId<17, "Statisticians", "Mathematicians")
  
  # Goalie random but based on shooter's team
  ind_goalie <- sample(1:2, n, replace = T)
  ind_goalie[ind_shooters<=16] <- ind_goalie[ind_shooters>16]+16
  generated$goalieFirstName <- merged_names[ind_goalie]
  generated$goalieLastName <- merged_surnames[ind_goalie]
  
  # Situation on the field
  num_players <- rep(NA, n)
  num_players[generated$manpowerSituation=="evenStrength"] <- 
    sample(c("5vs5", "4vs4", "3vs3"), 
           length(num_players[generated$manpowerSituation=="evenStrength"]),
           replace = T, 
           prob = c(0.85, 0.1, 0.05))
  num_players[generated$manpowerSituation=="powerPlay"] <- 
    sample(c("5vs4", "4vs3", "5vs3"), 
           length(num_players[generated$manpowerSituation=="powerPlay"]), 
           replace = T, 
           prob = c(0.85, 0.1, 0.05))
  num_players[generated$manpowerSituation=="shortHanded"] <- 
    sample(c("4vs5", "3vs4", "3vs5"), 
           length(num_players[generated$manpowerSituation=="shortHanded"]), 
           replace = T, 
           prob = c(0.85, 0.1, 0.05))
  generated$numPlayers <- num_players
  
  # Blocked with prob 15
  generated$Blocked <- sample(c("0", "1"), n, replace = T, prob = c(0.85, 0.15))
  
  # Game time depends on the period
  gameTime <- rep(NA, n)
  gameTime[generated$period==1] <- runif(sum(generated$period==1), 10, 1200)
  gameTime[generated$period==2] <- runif(sum(generated$period==2), 1210, 2400)
  gameTime[generated$period==3] <- runif(sum(generated$period==3), 2410, 3600)
  gameTime[generated$period==4] <- runif(sum(generated$period==4), 3610, 4000)
  generated$gameTime <- gameTime
  
  # Roles based on the player
  roles <- rep(c(rep("G", 2), rep("D", 4), rep("LW", 3), rep("C", 4), rep("RW", 3)), 2)
  generated$playerPosition <- roles[ind_shooters]
  
  # Random but within role and player that made the shot
  generated$teamForwardsOnIceRefs <- rep(NA, n)
  generated$teamDefencemenOnIceRefs <- rep(NA, n)
  generated$opposingTeamForwardsOnIceRefs <- rep(NA, n)
  generated$opposingTeamDefencemenOnIceRefs <- rep(NA, n)
  for(i in 1:n) {
    
    # Shooters are statisticians
    if(ind_shooters[i] < 17) {
      
      if(ind_shooters[i] > 6) {
        temp <- 7:16
        temp <- temp[temp!=ind_shooters[i]]
        generated$teamForwardsOnIceRefs[i] <- 
          paste(c(ind_shooters[i], sample(temp, 2)), collapse = ', ')
        generated$teamDefencemenOnIceRefs[i] <- 
          paste(sample(3:6, 2), collapse = ', ')
        generated$opposingTeamForwardsOnIceRefs[i] <- 
          paste(sample(23:32, 3), collapse = ', ')
        generated$opposingTeamDefencemenOnIceRefs[i] <- 
          paste(sample(19:22, 2), collapse = ', ')
      }
      
      else {
        temp <- 3:6
        temp <- temp[temp!=ind_shooters[i]]
        generated$teamForwardsOnIceRefs[i] <- 
          paste(sample(7:16, 3), collapse = ', ')
        generated$teamDefencemenOnIceRefs[i] <- 
          paste(c(ind_shooters[i], sample(temp, 1)), collapse = ', ')
        generated$opposingTeamForwardsOnIceRefs[i] <- 
          paste(sample(23:32, 3), collapse = ', ')
        generated$opposingTeamDefencemenOnIceRefs[i] <- 
          paste(sample(19:22, 2), collapse = ', ')
      }
    
    }
    
    # Shooters are mathematicians
    else {
      
      if(ind_shooters[i] > 22) {
        temp <- 23:32
        temp <- temp[temp!=ind_shooters[i]]
        generated$teamForwardsOnIceRefs[i] <- 
          paste(c(ind_shooters[i], sample(temp, 2)), collapse = ', ')
        generated$teamDefencemenOnIceRefs[i] <- 
          paste(sample(19:22, 2), collapse = ', ')
        generated$opposingTeamForwardsOnIceRefs[i] <- 
          paste(sample(7:16, 3), collapse = ', ')
        generated$opposingTeamDefencemenOnIceRefs[i] <- 
          paste(sample(3:6, 2), collapse = ', ')
      }
      
      # Shooters are mathematicians
      else {
        temp <- 19:22
        temp <- temp[temp!=ind_shooters[i]]
        generated$teamForwardsOnIceRefs[i] <- 
          paste(sample(23:32, 3), collapse = ', ')
        generated$teamDefencemenOnIceRefs[i] <- 
          paste(c(ind_shooters[i], sample(temp, 1)), collapse = ', ')
        generated$opposingTeamForwardsOnIceRefs[i] <- 
          paste(sample(7:16, 3), collapse = ', ')
        generated$opposingTeamDefencemenOnIceRefs[i] <- 
          paste(sample(3:6, 2), collapse = ', ')
      }
      
    }
  }
  
  # Deflected with prob 15
  generated$Deflected <- sample(c("0", "1"), n, replace = T, prob = c(0.85, 0.15))
  
  generated$hover_info <- rep(NA, n)
  for(i in 1:nrow(generated)){
    dist <- sqrt(((generated$yAdjCoord[i]-89)^2 + generated$xAdjCoord[i]^2))
    angle <- atan2(generated$xAdjCoord[i],89-generated$yAdjCoord[i]) * 180 /pi
    generated$hover_info[i] <- 
      paste('Shooter:', generated$playerFirstName[i], generated$playerLastName[i], 
            '\nDistance:', round(dist, digits = 1), "ft", 
            '\nAngle:', round(angle, digits = 1), "°", 
            "\nGoalie:", generated$goalieFirstName[i], generated$goalieLastName[i])
  }
  
  return(generated)
  
}
