get_discrete_plot <- function(game_shots = choose_data(), orientation) {
  
  #----------------------------get_colours---------------------
  
  den_color <- c("#C2FFC8","#03FF03")
  colors_points <- c("goal" = "#eb1010", 
                     "successful" = "#10EA10",
                     "failed" = "#1010EA")    
  get_colors_discrete <- function(level_list){
    level_list <- level_list - min(level_list)
    palette <- colorRampPalette(den_color)(floor(max(level_list*100))+1)
    cols_needed <- floor(level_list*100) +1
    
    cols <- palette[cols_needed]
    names(cols) <- level_list
    
    return(cols)
  }
  
  
  #----------------------------nshots---------------------
#  x_boundary <- 0
#  y_boundary <- 50
  
  # n_shots <- c(nrow(game_shots[which((game_shots$yAdjCoord<y_boundary) & (game_shots$xAdjCoord<x_boundary)),]),
  #              nrow(game_shots[which((game_shots$yAdjCoord>y_boundary) & (game_shots$xAdjCoord<x_boundary)),]),
  #              nrow(game_shots[which((game_shots$yAdjCoord<y_boundary) & (game_shots$xAdjCoord>x_boundary)),]),
  #              nrow(game_shots[which((game_shots$yAdjCoord>y_boundary) & (game_shots$xAdjCoord>x_boundary)),]))
  # 
  if(length(game_shots[,1]) > 0){
    if(orientation == 'Vertical'){
      n_shots <- rep(0,9)
      angles <- c(90, 78.69007, 52.43141, 35.62294, 0)
      for(i in 1:length(game_shots$xAdjCoord)){
        if(game_shots$yAdjCoord[i] < 25.5){
          n_shots[9] <- n_shots[9] +1
        }
        else{
          if(game_shots$xAdjCoord[i] > 0){
            angle <- atan2(3 + game_shots$xAdjCoord[i],89-game_shots$yAdjCoord[i]) * 180 /pi
            print(angle)
            for(j in 1:4){
              if(angle <= angles[j] && angle >= angles[j+1]){
                n_shots[j] <- n_shots[j]+1
              }
            }
          }
          else{
            angle <- atan2(3 - game_shots$xAdjCoord[i],89-game_shots$yAdjCoord[i]) * 180 /pi
            for(j in 1:4){
              if(angle <= angles[j] && angle >= angles[j+1]){
                n_shots[j+4] <- n_shots[j+4]+1
              }
            }
          }
        }
      }
      n_shots_perc <- n_shots/sum(n_shots)
      print(n_shots)
      print(n_shots_perc)
      
      
      cols <- get_colors_discrete(n_shots_perc)
    
    
      lay <- list.append(rink_shapes,list(type = 'path',
                                          path = ' M 0,89 L 42.5,89 L 42.5,80.9 Z',
                                          fillcolor = cols[[1]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                          path = ' M 0,89 L 42.5,80.9 L 42.5,54 Z',
                                          fillcolor = cols[[2]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                          path = ' M 0,89 L 42.5,54 L 42.5,25.5 Z',
                                          fillcolor = cols[[3]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                          path = ' M 0,89 L 42.5,25.5 L 0,25.5 Z',
                                          fillcolor = cols[[4]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      
      lay <- list.append(lay,list(type = 'path',
                                          path = ' M 0,89 L -42.5,89 L -42.5,80.9 Z',
                                          fillcolor = cols[[5]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                          path = ' M 0,89 L -42.5,80.9 L-42.5,54 Z',
                                          fillcolor = cols[[6]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                          path = ' M 0,89 L -42.5,54 L -42.5,25.5 Z',
                                          fillcolor = cols[[7]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                          path = ' M 0,89 L -42.5,25.5 L 0,25.5 Z',
                                          fillcolor = cols[[8]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      
      lay <- list.append(lay,list(type = 'path',
                                          path = ' M -42.5,25.5 L42.5,25.5 L42.5,0 L-42.5,0 Z',
                                          fillcolor = cols[[9]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      
      p <- plot_ly(x = game_shots$xAdjCoord, y = game_shots$yAdjCoord) %>%
        layout(shapes = lay,
               xaxis = list(title = list(text ="")),
               yaxis = list(title = list(text = ""), #visible=F),
                            scaleanchor = "x", scaleratio = 0.9))%>%
        add_trace(color = game_shots$outcome, colors = colors_points,
                  type = "scatter", mode = 'markers',
                  text = game_shots$hover_info, hoverinfo="text",
                  opacity = 0.8,
                  marker = list(sizeref=0.7, sizemode="area",
                                line = list(color='black', width = 1))) %>%
        add_text(x =  52, y = 85, showlegend = F, 
                 text = paste("Shots:\n", n_shots[1], "; ", 
                              floor(abs(n_shots_perc[1])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(x =  52, y = 68, showlegend = F, 
                 text = paste("Shots:\n", n_shots[2], "; ", 
                              floor(abs(n_shots_perc[2])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(x =  52, y = 40, showlegend = F, 
                 text = paste("Shots:\n", n_shots[3], "; ", 
                              floor(abs(n_shots_perc[3])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(x =  18, y = 40, showlegend = F, 
                 text = paste("Shots:\n", n_shots[4], "; ", 
                              floor(abs(n_shots_perc[4])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(x =  -52, y = 85, showlegend = F, 
                 text = paste("Shots:\n", n_shots[5], "; ", 
                              floor(abs(n_shots_perc[5])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(x =  -52, y = 68, showlegend = F, 
                 text = paste("Shots:\n", n_shots[6], "; ", 
                              floor(abs(n_shots_perc[6])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(x =  -52, y = 40, showlegend = F, 
                 text = paste("Shots:\n", n_shots[7], "; ", 
                              floor(abs(n_shots_perc[7])*100),'%',sep = ""),
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(x =  -18, y = 40, showlegend = F, 
                 text = paste("Shots:\n", n_shots[8], "; ", 
                              floor(abs(n_shots_perc[8])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(x =  0, y = 10, showlegend = F, 
                 text = paste("Shots:\n", n_shots[9], "; ", 
                              floor(abs(n_shots_perc[9])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") 
    }
    else{
      n_shots <- rep(0,9)
      angles <- c(90, 78.69007, 52.43141, 35.62294, 0)
      for(i in 1:length(game_shots$yAdjCoord)){
        if(game_shots$xAdjCoord[i] < 25.5){
          n_shots[9] <- n_shots[9] +1
        }
        else{
          if(game_shots$yAdjCoord[i] > 0){
            angle <- atan2(3 + game_shots$yAdjCoord[i],89-game_shots$xAdjCoord[i]) * 180 /pi
            print(angle)
            for(j in 1:4){
              if(angle <= angles[j] && angle >= angles[j+1]){
                n_shots[j] <- n_shots[j]+1
              }
            }
          }
          else{
            angle <- atan2(3 - game_shots$yAdjCoord[i],89-game_shots$xAdjCoord[i]) * 180 /pi
            for(j in 1:4){
              if(angle <= angles[j] && angle >= angles[j+1]){
                n_shots[j+4] <- n_shots[j+4]+1
              }
            }
          }
        }
      }
      n_shots_perc <- n_shots/sum(n_shots)
      print(n_shots)
      print(n_shots_perc)
      
      
      cols <- get_colors_discrete(n_shots_perc)
      
      
      lay <- list.append(rink_shapes,list(type = 'path',
                                          path = ' M 89,0 L 89,42.5 L 80.9,42.5 Z',
                                          fillcolor = cols[[1]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                  path = ' M 89,0 L 80.9,42.5 L 54,42.5 Z',
                                  fillcolor = cols[[2]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                  path = ' M 89,0 L 54,42.5 L 25.5,42.5 Z',
                                  fillcolor = cols[[3]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                  path = ' M 89,0 L 25.5,42.5 L 25.5,0 Z',
                                  fillcolor = cols[[4]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      
      lay <- list.append(lay,list(type = 'path',
                                  path = ' M 89,0 L 89,-42.5 L 80.9,-42.5 Z',
                                  fillcolor = cols[[5]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                  path = ' M 89,0 L 80.9,-42.5 L 54,-42.5 Z',
                                  fillcolor = cols[[6]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                  path = ' M 89,0 L 54,-42.5 L 25.5,-42.5 Z',
                                  fillcolor = cols[[7]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                  path = ' M 89,0 L 25.5,-42.5 L 25.5,0 Z',
                                  fillcolor = cols[[8]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      
      lay <- list.append(lay,list(type = 'path',
                                  path = ' M 25.5,42.5 L25.5,-42.5 L0,-42.5 L0,42.5 Z',
                                  fillcolor = cols[[9]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      
      
      
      p <- plot_ly(x = game_shots$xAdjCoord, y = game_shots$yAdjCoord) %>%
        layout(shapes = lay,
               xaxis = list(title = list(text ="")),
               yaxis = list(title = list(text = ""), #visible=F),
                            scaleanchor = "x", scaleratio = 0.9))%>%
        add_trace(color = game_shots$outcome, colors = colors_points,
                  type = "scatter", mode = 'markers',
                  text = game_shots$hover_info, hoverinfo="text",
                  opacity = 0.8,
                  marker = list(sizeref=0.7, sizemode="area",
                                line = list(color='black', width = 1))) %>%
        add_text(y =  -52, x = 88, showlegend = F, 
                 text = paste("Shots:\n", n_shots[1], "; ", 
                              floor(abs(n_shots_perc[1])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(y =  -52, x = 65, showlegend = F, 
                 text = paste("Shots:\n", n_shots[2], "; ", 
                              floor(abs(n_shots_perc[2])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(y =  -52, x = 37, showlegend = F, 
                 text = paste("Shots:\n", n_shots[3], "; ", 
                              floor(abs(n_shots_perc[3])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(y =  -18, x = 40, showlegend = F, 
                 text = paste("Shots:\n", n_shots[4], "; ", 
                              floor(abs(n_shots_perc[4])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(y =  52, x = 88, showlegend = F, 
                 text = paste("Shots:\n", n_shots[5], "; ", 
                              floor(abs(n_shots_perc[5])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(y =  52, x = 65, showlegend = F, 
                 text = paste("Shots:\n", n_shots[6], "; ", 
                              floor(abs(n_shots_perc[6])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(y =  52, x = 37, showlegend = F, 
                 text = paste("Shots:\n", n_shots[7], "; ", 
                              floor(abs(n_shots_perc[7])*100),'%',sep = ""),
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(y =  18, x = 40, showlegend = F, 
                 text = paste("Shots:\n", n_shots[8], "; ", 
                              floor(abs(n_shots_perc[8])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(y =  0, x = 10, showlegend = F, 
                 text = paste("Shots:\n", n_shots[9], "; ", 
                              floor(abs(n_shots_perc[9])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip")  
    }
  }
  
  
  else{
    p <- plot_ly() %>%
      layout(shapes = rink_shapes,
             xaxis = list(title = list(text ="")),
             yaxis = list(title = list(text = ""), #visible=F),
                          scaleanchor = "x", scaleratio = 0.9))
  }
  return(p)
  
}