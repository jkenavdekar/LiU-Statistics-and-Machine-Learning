get_discrete_plot_vs_average <- function(game_shots, all_season_shots, orientation) {
  
  #----------------------------get_colours---------------------
  if(length(game_shots[,1]) > 0){
    den_color_red <- c("#FF8787","#FF0800")
    den_color_green <- c("#C2FFC8","#03FF03")
    colors_points <- c("goal" = "#eb1010", 
                       "successful" = "#10EA10",
                       "failed" = "#1010EA") 
    
    get_colors_discrete <- function(level_list){
      max_diff <- max(abs(level_list))
      pallete_green <- colorRampPalette(den_color_green)(floor(max_diff*100)+1)
      pallete_red <- colorRampPalette(den_color_red)(floor(max_diff*100)+1)
      
      cols <- rep(0, length(level_list))
      for(i in 1: length(level_list)){
        if(level_list[i] > 0){
          cols[i] <- pallete_green[(floor(level_list[i]*100)+1)]
        }
        else{
          cols[i] <- pallete_red[-(ceiling(level_list[i]*100)-1)]
          
        }
      }
      
      
      
      return(cols)
    }
    print(length(game_shots$xAdjCoord))
    print(length(all_season_shots$xAdjCoord))
    
    #----------------------------nshots---------------------
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
      n_shots_all_season <- rep(0,9)
      for(i in 1:length(all_season_shots$xAdjCoord)){
        if(all_season_shots$yAdjCoord[i] < 25.5){
          n_shots_all_season[9] <- n_shots_all_season[9] +1
        }
        else{
          if(all_season_shots$xAdjCoord[i] > 0){
            angle <- atan2(3 + all_season_shots$xAdjCoord[i],89-all_season_shots$yAdjCoord[i]) * 180 /pi
            for(j in 1:4){
              if(angle <= angles[j] && angle >= angles[j+1]){
                n_shots_all_season[j] <- n_shots_all_season[j]+1
              }
            }
          }
          else{
            angle <- atan2(3 - all_season_shots$xAdjCoord[i],89-all_season_shots$yAdjCoord[i]) * 180 /pi
            for(j in 1:4){
              if(angle <= angles[j] && angle >= angles[j+1]){
                n_shots_all_season[j+4] <- n_shots_all_season[j+4]+1
              }
            }
          }
        }
      } 
      
      
      n_shots_perc_game <- n_shots/sum(n_shots)
      n_shots_all_season_perc <- n_shots_all_season/sum(n_shots_all_season)
      
      n_shots_perc <- n_shots_perc_game - n_shots_all_season_perc
    
      
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
      
      print('We got here!')
      
      p <- plot_ly(x = game_shots$xAdjCoord, y = game_shots$yAdjCoord) %>%
        layout(shapes = lay,
               xaxis = list(title = list(text ="")),
               yaxis = list(title = list(text = ""), #visible=F),
                            scaleanchor = "x", scaleratio = 0.9)) %>%
        add_trace(color = game_shots$outcome, colors = colors_points,
                  type = "scatter", mode = 'markers',
                  text = game_shots$hover_info, hoverinfo="text",
                  opacity = 0.8,
                  marker = list(sizeref=0.7, sizemode="area",
                                line = list(color='black', width = 1))) %>% 
        add_text(x =  52, y = 85, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[1]>0, "+", "-"),
                              floor(abs(n_shots_perc[1])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(x =  52, y = 68, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[2]>0, "+", "-"),
                              floor(abs(n_shots_perc[2])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(x =  52, y = 40, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[3]>0, "+", "-"),
                              floor(abs(n_shots_perc[3])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(x =  18, y = 40, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[4]>0, "+", "-"),
                              floor(abs(n_shots_perc[4])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(x =  -52, y = 85, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[5]>0, "+", "-"),
                              floor(abs(n_shots_perc[5])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(x =  -52, y = 68, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[6]>0, "+", "-"),
                              floor(abs(n_shots_perc[6])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(x =  -52, y = 40, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[7]>0, "+", "-"),
                              floor(abs(n_shots_perc[7])*100),'%',sep = ""),
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(x =  -18, y = 40, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[8]>0, "+", "-"),
                              floor(abs(n_shots_perc[8])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(x =  0, y = 10, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[9]>0, "+", "-"),
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
      n_shots_all_season <- rep(0,9)
      for(i in 1:length(all_season_shots$xAdjCoord)){
        if(all_season_shots$yAdjCoord[i] < 25.5){
          n_shots_all_season[9] <- n_shots_all_season[9] +1
        }
        else{
          if(all_season_shots$xAdjCoord[i] > 0){
            angle <- atan2(3 + all_season_shots$xAdjCoord[i],89-all_season_shots$yAdjCoord[i]) * 180 /pi
            for(j in 1:4){
              if(angle <= angles[j] && angle >= angles[j+1]){
                n_shots_all_season[j] <- n_shots_all_season[j]+1
              }
            }
          }
          else{
            angle <- atan2(3 - all_season_shots$xAdjCoord[i],89-all_season_shots$yAdjCoord[i]) * 180 /pi
            for(j in 1:4){
              if(angle <= angles[j] && angle >= angles[j+1]){
                n_shots_all_season[j+4] <- n_shots_all_season[j+4]+1
              }
            }
          }
        }
      } 
      
      
      n_shots_perc_game <- n_shots/sum(n_shots)
      n_shots_all_season_perc <- n_shots_all_season/sum(n_shots_all_season)
      
      n_shots_perc <- n_shots_perc_game - n_shots_all_season_perc
      
      print(n_shots_perc_game)
      print(n_shots_all_season_perc)
      
      
      cols <- get_colors_discrete(n_shots_perc)
      
      
      
      lay <- list.append(rink_shapes,list(type = 'path',
                                          path = ' M 89,0 L89,-42.5 L80.9,-42.5 L88.64,0 Z',
                                          fillcolor = cols[[1]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                  path = ' M 88.64,0 L80.9,-42.5 L54,-42.5 L86.69,0 Z',
                                  fillcolor = cols[[2]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                  path = ' M 86.69,0 L54,-42.5 L25.5,-42.5 L84.81,0 Z',
                                  fillcolor = cols[[3]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                  path = ' M 84.81,0 L25.5,-42.5 L25.5,0 Z',
                                  fillcolor = cols[[4]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      
      lay <- list.append(lay,list(type = 'path',
                                  path = ' M 89,0 L89,42.5 L80.9,42.5 L88.64,0 Z',
                                  fillcolor = cols[[5]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                  path = ' M 88.64,0 L80.9,42.5 L54,42.5 L86.69,0 Z',
                                  fillcolor = cols[[6]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                  path = ' M 86.69,0 L54,42.5 L25.5,42.5 L84.81,0 Z',
                                  fillcolor = cols[[7]],line = list(color = 'rgba(0,0,0,0.3)'), opacity = 0.3))
      lay <- list.append(lay,list(type = 'path',
                                  path = ' M 84.81,0 L25.5,42.5 L25.5,0 Z',
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
                 text = paste("'17/'18: ", ifelse(n_shots_perc[1]>0, "+", "-"),
                              floor(abs(n_shots_perc[1])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(y =  -52, x = 65, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[2]>0, "+", "-"),
                              floor(abs(n_shots_perc[2])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(y =  -52, x = 37, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[3]>0, "+", "-"),
                              floor(abs(n_shots_perc[3])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(y =  -18, x = 40, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[4]>0, "+", "-"),
                              floor(abs(n_shots_perc[4])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(y =  52, x = 88, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[5]>0, "+", "-"),
                              floor(abs(n_shots_perc[5])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(y =  52, x = 65, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[6]>0, "+", "-"),
                              floor(abs(n_shots_perc[6])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(y =  52, x = 37, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[7]>0, "+", "-"),
                              floor(abs(n_shots_perc[7])*100),'%',sep = ""),
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(y =  18, x = 40, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[8]>0, "+", "-"),
                              floor(abs(n_shots_perc[8])*100),'%',sep = ""), 
                 textfont = list(color = '#000000', size = 12, family = 'sans serif'),
                 hoverinfo = "skip") %>%
        add_text(y =  0, x = 10, showlegend = F, 
                 text = paste("'17/'18: ", ifelse(n_shots_perc[9]>0, "+", "-"),
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
