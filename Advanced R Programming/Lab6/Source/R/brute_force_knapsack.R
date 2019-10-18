






#' Title brute_force_knapsack
#'
#' @param x Data frame which consists the value and the weight for each object.
#' @param parallel Gives the opportunity to use parallel programming,if parallel=TRUE.
#' @param W The knapsack size.
#'
#' @description this function is guaranteed to give a correct answer in all situations.
#' The function enumerates all different combinations by using a binary representation of the numbers
#' 1 to 2n and include all elements of that is equal to 1 in the binary representation.
#' @return The functoin returns a list containing two named objects:
#' \itemize{
#'   \item "value": maximum knapsack value;
#'   \item "elements": a vector containing the indexes of the objects (rows of data.frame) used to obtain the final result.
#' }
#' @import parallel
#' 
#' @export
brute_force_knapsack <- function(x, W , parallel=FALSE) {
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
  rownames(x) <- 1:nrow(x)
  n <- nrow(x)
  best_val <- 0
  best_ind <- 0
  if(parallel==FALSE){
    
    i <- 1
    bits <- intToBits(i)
    
    while(bits[n+1]==0) {
      ind <- which(bits==1)
      if(sum(x$w[ind])<=W & sum(x$v[ind])>best_val) {
        best_val <- sum(x$v[ind])
        best_ind <- as.numeric(rownames(x)[ind])
      }
      i <- i+1
      bits <- intToBits(i)
    }
    return(list(value = best_val, elements = best_ind))
  } else {
    # Calculate the number of cores
    no_cores <- parallel::detectCores()-1
    
    # Initiate cluster
    cl <- parallel::makeCluster(no_cores)
    
    parallel::clusterExport(cl,list("x","best_val","best_ind","W") , envir = environment())
    
    fun<-function(i){
      ind <- which(intToBits(i) == 1)
      if(sum(x$w[ind])<=W & sum(x$v[ind])>best_val){
        best_val <<- sum(x$v[ind])
        best_ind <<- as.numeric(rownames(x)[ind])
      } 
      return(list(value = best_val, elements = best_ind))
    }
    res = parallel::parLapply(cl,1:(2^n-1),fun)
    parallel::stopCluster(cl)
    return(list(value = res[[2^n-1]]$value, elements = res[[2^n-1]]$elements))
  }
  
}



