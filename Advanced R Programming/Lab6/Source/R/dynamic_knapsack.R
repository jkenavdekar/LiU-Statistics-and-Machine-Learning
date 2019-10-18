#' Dynamic Knapsack
#'
#' @param x Data frame that consists of two numeric columns (order is not relevant): 
#' \itemize{
#'   \item "v": values of the objects;
#'   \item "w": weights of the objects.
#' }
#' @param W A numeric value, being the knapsack size.
#' @description This function can solve the knapsack problem exact by iterating over all possible values of W.
#' @return The functoin returns a list containing two named objects:
#' \itemize{
#'   \item "value": maximum knapsack value;
#'   \item "elements": a vector containing the indexes of the objects (rows of data.frame) used to obtain the final result.
#' }
#' @export
#' 
dynamic_knapsack = function(x, W){
  
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
  
  
  item_count = nrow(x)
  x$order = 1:item_count
  x = x[order(x$w),]
  too_big <- which(x$w>W)
  if(length(too_big)!=0)
    x <- x[-too_big,]
  item_count = nrow(x)
  s <- x$w[1]+x$w[2]
  table = matrix(0, item_count, W+1)
  # set 1st row
  table[1, ] = c(rep(0, x$w[1]), rep(x$v[1], (W+1)-x$w[1]))
  j_prec <- 1
  
  for(i in 2:item_count){
    
    j <- x$w[i]+1
    if(j_prec!=j) {
      table[i:item_count, j_prec:(j-1)] <- 
        matrix(table[i-1, j_prec:(j-1)], item_count-i+1, j-j_prec, byrow = T)
    }
    
    while( j<=(W+1) ) {
      
      if((j-1) <= s) {
        
        if((j-1) < x$w[i]) 
          table[i,j] = table[i-1, j]
        else
          table[i,j] = max(table[i-1, j], (x$v[i] + table[i-1, j-x$w[i]]))
        j <- j+1
        
      }
      
      else {
        j_prec <- x$w[i]+1
        table[i, (j-1):W+1] <- table[i, j-1]
        if(i<item_count)
          s <- s+x$w[i+1]
        j <- W+2
      }
      
    }
  }
  
  # finding elements
  i <- item_count
  j <- W+1
  ind <- c()
  
  while(j>1) {
    if(i>1) {
      if(table[i, j] == table[i-1, j]) 
        i <- i-1
      else {
        ind <- c(ind, x$order[i])
        j <- j - x$w[i]
        i <- ifelse(i>1, i-1, i)
      }
    }
    else {
      ind <- c(ind, x$order[i])
      j <- 1
    }
  }
  return(list(value=table[item_count,W+1], elements=ind))
}
