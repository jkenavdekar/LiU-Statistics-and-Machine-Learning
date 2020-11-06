#----------------------------loading---------------------
source("R/hockey_rink.R")


load("../data/game.RData")
numPlayers <- paste(game$teamSkatersOnIce, game$opposingTeamSkatersOnIce, sep = "vs")
# numPlayers <- as.factor(numPlayers)
game$numPlayers <- numPlayers
game <- game[,c(25, 26, 16, 19, 3, 28, 7, 43)]
game_shots <- game[which(game$name == "shot"),]
names(game_shots)[1:2] <- c("yAdjCoord", "xAdjCoord")
game_shots <- game_shots[(game_shots$yAdjCoord > 0),]
game_shots$outcome <- factor(game_shots$outcome)
game_shots$name <- factor(game_shots$name)
print("Successful load")

#----------------------------get_colours---------------------

den_color <- c("#FF8787","#FF0800")
get_colors_discrete <- function(level_list){
  print(level_list)
  level_list <- level_list - min(level_list)
  print(level_list)
  palette <- colorRampPalette(den_color)(floor(max(level_list*100))+1)
  cols_needed <- floor(level_list*100) +1
  
  cols <- palette[cols_needed]
  names(cols) <- level_list
  
  return(cols)
}


#----------------------------nshots---------------------
x_boundary <- 0
y_boundary <- 50

n_shots <- c(nrow(game_shots[which((game_shots$yAdjCoord<y_boundary) & (game_shots$xAdjCoord<x_boundary)),]),
            nrow(game_shots[which((game_shots$yAdjCoord>y_boundary) & (game_shots$xAdjCoord<x_boundary)),]),
            nrow(game_shots[which((game_shots$yAdjCoord<y_boundary) & (game_shots$xAdjCoord>x_boundary)),]),
            nrow(game_shots[which((game_shots$yAdjCoord>y_boundary) & (game_shots$xAdjCoord>x_boundary)),]))


n_shots_perc <- n_shots/sum(n_shots)
cols <- get_colors_discrete(n_shots_perc)

lay <- list.append(rink_shapes,list(type = "rect",
                                    fillcolor = cols[[1]], line = list(color = cols[[1]]), opacity = 0.3,
                                    x0 = -42.5, x1 = x_boundary, xref = "x",
                                    y0 = 0, y1 = y_boundary, yref = "y"))
lay <- list.append(lay,list(type = "rect",
                                    fillcolor = cols[[2]], line = list(color = cols[[2]]), opacity = 0.3,
                                    x0 = -42.5, x1 = x_boundary, xref = "x",
                                    y0 = y_boundary, y1 = 100, yref = "y"))
lay <- list.append(lay,list(type = "rect",
                            fillcolor = cols[[3]], line = list(color = cols[[3]]), opacity = 0.3,
                            x0 = x_boundary, x1 = 42.5, xref = "x",
                            y0 = 0, y1 = y_boundary, yref = "y"))
lay <- list.append(lay,list(type = "rect",
                            fillcolor = cols[[4]], line = list(color = cols[[4]]), opacity = 0.3,
                            x0 = x_boundary, x1 = 42.5, xref = "x",
                            y0 = y_boundary, y1 = 100, yref = "y"))



p <- plot_ly(x = game_shots$xAdjCoord, y = game_shots$yAdjCoord) %>%
  add_markers(color = game_shots$outcome, symbol = game_shots$name) %>%
  add_text(x =  mean(c(-42.5, x_boundary)), y = mean(c(0, y_boundary)), text = floor(n_shots_perc[1]*100), textfont = list(color = '#000000', size = 100)) %>%
  add_text(x =  mean(c(-42.5, x_boundary)), y = mean(c(y_boundary, 100)), text = floor(n_shots_perc[2]*100), textfont = list(color = '#000000', size = 100)) %>%
  add_text(x = mean(c(x_boundary, 42.5)), y = mean(c(0, y_boundary)), text = floor(n_shots_perc[3]*100), textfont = list(color = '#000000', size = 100)) %>%
  add_text(x = mean(c(x_boundary, 42.5)), y = mean(c(y_boundary, 100)), text = floor(n_shots_perc[4]*100), textfont = list(color = '#000000', size = 100)) %>%
  layout(shapes = lay)
  


p

