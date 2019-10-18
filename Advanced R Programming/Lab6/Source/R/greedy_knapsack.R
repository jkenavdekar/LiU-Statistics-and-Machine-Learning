#' Title greedy_knapsack
#'
#' @param x Data frame which consists the value and the weight for each object.
#' @param W The knapsack size
#' @description This function uses Greedy heuristic.
#' It does not return an exact result but it will reduce the computational complexity.
#' @return The functoin returns a list containing two named objects:
#' \itemize{
#'   \item "value": maximum knapsack value;
#'   \item "elements": a vector containing the indexes of the objects (rows of data.frame) used to obtain the final result.
#' }
#' @export
greedy_knapsack<-function(x,W){
  
  if(!is.data.frame(x) | ncol(x)!=2) 
    stop("The input object is not of data.frame type.\n")
  if(!(all(colnames(x)==c("v", "w")) | all(colnames(x)==c("w", "v"))))
    stop("The data.frame should have the columns named 'v' and 'w'.")
  if(!is.numeric(x$v)) 
    stop("Column of values (v) is not of the expected type (numeric).")
  if(!is.numeric(x$w)) 
    stop("Column of weights (w) is not of the expected type (numeric).")
  if(!is.numeric(W) | length(W)!=1 | W<=0) 
    stop("The total weight (W) should be a positive scalar.")
  
  my_weight=0
  heuristic<-x$v/x$w
  n <- nrow(x)
  x$id <- 1:n
  x <- x[order(heuristic, decreasing = T),]
  
  indexes<-c()
  total_value<-0
  i <- 1
  
  while (my_weight < W | i<=n) {
    if(x$w[i] <= W-my_weight){
      my_weight <- my_weight + x$w[i]
      indexes <- c(indexes, x$id[i])
      total_value <- total_value + x$v[i]
    }
    else {
      break
    }
    i <- i+1
  }
  
  return(list(value=total_value,elements=indexes))
}
