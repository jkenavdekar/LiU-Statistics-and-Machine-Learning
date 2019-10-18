#' Euclidian
#'
#' @param x first number 
#' @param y second number
#' @references \href{https://en.wikipedia.org/wiki/Euclidean_algorithm}{wikipedia page}
#' @description Given 2 values (x and y), the function choose the greatest (for example x) one and replace it with modular of the other (x mod y) until remainer is equal to zero.
#'
#' @return returns greater common divisor of two value
#' @export
#'
#' @examples euclidean(100, 1000) 

euclidean <-
function(x, y)
{
  if(!is.numeric(x) | !is.numeric(y) | length(x)!=1 | length(y)!=1) 
    stop("Arguments are not numeric!")
  
  r = 1    # remainer of division
  x <- abs(x)
  y <- abs(y)
  
  while(r!=0) 
  {
    
    if(x>y) 
      {
        r <- x%%y
        x <- r
      }
    
    else
    {
      r <- y%%x
      y <- r
    }
    
  }
  
  return( max(x, y) )
}
