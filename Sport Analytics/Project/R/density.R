library(ggplot2)
library(plotly)

#data <- read.csv("../LHC2017-18-regular/playsequence-20170916-SHL-LHCvsFBK-20172018-qTJ-3n1r1ai6p.csv")
load("../data/game.RData")
game_shots <- game[which(game$name %in% c("shot","goal")),]
game_shots_LIN <- game_shots[which(game_shots$teamInPossession == "LinkÃ¶ping LinkÃ¶ping HC"),]
game_shots_FAR <- game_shots[which(game_shots$teamInPossession != "LinkÃ¶ping LinkÃ¶ping HC"),]

names(game_shots_LIN)[23:26] <- c("yCoord", "xCoord", "yAdjCoord", "xAdjCoord")
game_shots_LIN <- game_shots_LIN[(game_shots_LIN$yAdjCoord > 0),]

game_shots_LIN$outcome <- factor(game_shots_LIN$outcome)
game_shots_LIN$name <- factor(game_shots_LIN$name)

opacity <- 0.5
bandwidth <- 10
nlevels <- 20
smoothness <- 700
line_width <- 0.5
line_color <- "white"
den_color <- c("#FFFFFF","#0016DB")

source("R/hockey_rink.R")



#-------------------heatmapper approach-------------------
get_colours <- function(level_list){
  n <- length(level_list)
  
  
     palette <- colorRampPalette(den_color)(n)

  names(palette) <- level_list
  
  return(palette)
}


        
get_contour_shapes <- function(m){
  # Maybe add a "fake" data to extend the curve to a limit
  dens <- with(MASS::geyser, MASS::kde2d(c(game_shots_LIN$xAdjCoord, -100,0,0,100), 
                                         c(game_shots_LIN$yAdjCoord, -100,50,50,200), 
                                         h=bandwidth, n=smoothness))
  
  cl <- contourLines(x = dens$x, y = dens$y, z = dens$z, nlevels = nlevels) 
 # cl <- contourLines(x = dens$x, y = dens$y, z = dens$z)  
  
  max_cl <- length(cl)
  
  cl_levels <- as.character(unique(unlist(lapply(cl, function(x){x$level}))))
  
  colours <- get_colours(cl_levels)
  
  
  for(i in 1:max_cl){	
    m <- add_polygons(m, cl[[i]]$x,cl[[i]]$y,
                    line=list(width=line_width,color=line_color),
                    opacity = opacity,
                     fillcolor = colours[[as.character(cl[[i]]$level)]]) %>%
                    layout(xaxis = list(range = c(-42.6, 42.6)),
                           yaxis = list(range = c(-0.1,100.1)))
  }
  
  return(m)
}

pal <- c("#FF0F17", "#0AFF12")
p1 <- plot_ly(data = game_shots_LIN, x = ~xAdjCoord, y = ~yAdjCoord) %>%
  get_contour_shapes()%>%
  add_markers(color = "black", symbol = ~outcome, colors = "black") %>%
  layout(shapes = rink_shapes)
p1



#---------------------contour-------------------

dens <- with(MASS::geyser, MASS::kde2d(game_shots_LIN$xAdjCoord, game_shots_LIN$yAdjCoord, h=bandwidth, n=smoothness))
p2 <- plot_ly(x = game_shots_LIN$xAdjCoord, y = game_shots_LIN$yAdjCoord) %>%
  add_markers(color = game_shots_LIN$outcome, symbol = game_shots_LIN$name) %>%
  add_contour(x = dens$x,
              y = dens$y,
              z = matrix(dens$z, nrow = length(dens$y), byrow = TRUE),
              colorscale = heat.colors)%>%
  layout(shapes = rink_shapes)
p2







