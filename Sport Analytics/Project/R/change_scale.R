# Function useful to adjust the scale used in the hockey rink on PlotLy

change_scale <- function(point, dimension = "x") {
  
  if(dimension=="x") {
    new_max <- 42.5
    new_min <- -42.5
    old_max <- 250
    old_min <- -250
  }
  
  else if(dimension=="y") {
    new_max <- 100
    new_min <- 0
    old_max <- 580
    old_min <- 0
  }
  
  new_range <- new_max - new_min
  old_range <- old_max - old_min
  
  return( new_range/old_range * (point-old_max) + new_max )
  
}
