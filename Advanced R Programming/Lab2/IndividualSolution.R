########################################################################################
### SECTION 1.1, CONDITIONAL STATEMENTS
########################################################################################


# 1.1.1

sheldon_game <- function(player1, player2) {
  choices <- c("rock", "paper", "scissor", "lizard", "spock")
  if(!((player1 %in% choices) & (player2 %in% choices))) stop("Value not allowed!")
  if(player1==player2) return("Draw!")
  ind1 <- which(choices==player1)
  ind2 <- which(choices==player2)
  win_matrix <- matrix(c(3,2,3,4,2,1,2,5,1,3,1,4,4,2,4,5,5,1,5,3),10,2, byrow = TRUE)
  sub_p1 <- win_matrix[win_matrix[,1]==ind1,2]
  if(ind2 %in% sub_p1) return("Player 1 wins!")
  sub_p2 <- win_matrix[win_matrix[,1]==ind2,2]
  if(ind1 %in% sub_p2) return("Player 2 wins!")
}

########################################################################################
### SECTION 1.2, FOR LOOPS
########################################################################################


# 1.2.1

my_moving_median <- function(x, n, ...) {
  if(!(is.numeric(n) & length(n)==1) | !is.numeric(x)) stop("Not all values are numeric!")
  moving_median <- rep(NA, length(x)-n)
  for(i in 1:(length(x)-n)) moving_median[i] <- median(x[i:(i+n)], ...)
  return(moving_median)
}

# 1.2.2

for_mult_table <- function(from, to) {
  if(!(is.numeric(from) & length(from)==1) | !(is.numeric(to) & length(to)==1))
    stop("Not all values are scalar!")
  if((from<0) | (to<0)) stop("Not all values are positive!")
  if(to<from) stop("'To' is smaller than 'from'!")
  mult_table <- matrix(NA, to-from+1, to-from+1)
  colnames(mult_table) <- from:to
  rownames(mult_table) <- from:to
  values <- from:to
  for(i in 1:(to-from+1)) mult_table[,i] <- values[i]*values
  return(mult_table)
}

# 1.2.3

cor_matrix <- function(X) {
  if(!is.data.frame(X)) stop("The object in input IS NOT of type data.frame!")
  cor_m <- matrix(NA, NCOL(X), NCOL(X))
  diag(cor_m) <- 1
  for(i in 1:(NCOL(X)-1)) {
    for(j in (i+1):NCOL(X)) {
      COV <- mean(X[,i]*X[,j])-mean(X[,i])*mean(X[,j])
      SD_X1 <- sqrt(mean(X[,i]^2)-mean(X[,i])^2)
      SD_X2 <- sqrt(mean(X[,j]^2)-mean(X[,j])^2)
      cor_m[i,j] <- COV/(SD_X1*SD_X2)
      cor_m[j,i] <- COV/(SD_X1*SD_X2)
    }
  }
  return(cor_m)
}

########################################################################################
### SECTION 1.3, WHILE LOOPS
########################################################################################


# 1.3.1

find_cumsum <- function(x, find_sum) {
  if(!is.numeric(x) | !is.vector(x) | !is.numeric(find_sum)) stop("Value(s) not allowed!")
  s <- 0
  i <- 1
  while(s<=find_sum & i<=length(x)) {
    s <- s + x[i]
    i <- i+1
  }
  return(s)
}

# 1.3.2

while_mult_table <- function(from, to) {
  if(!(is.numeric(from) & length(from)==1) | !(is.numeric(to) & length(to)==1))
    stop("Not all values are scalar!")
  if((from<0) | (to<0)) stop("Not all values are positive!")
  if(to<from) stop("'To' is smaller than 'from'!")
  mult_table <- matrix(NA, to-from+1, to-from+1)
  colnames(mult_table) <- from:to
  rownames(mult_table) <- from:to
  values <- from:to
  i <- 1
  while(i<=(to-from+1)) {
    mult_table[,i] <- values[i]*values
    i <- i+1
  }
  return(mult_table)
}

# 1.3.3

trial_division_factorization <- function(x) {
  if(!is.integer(x)) stop("Input is not an integer!")
  threshold <- as.integer(sqrt(x)) + 1
  i <- 2
  temp <- x
  factors <- NA
  while(i<threshold) {
    if(temp%%i==0) {
      temp <- temp/i
      factors <- c(factors, i)
      i <- 2
    }
    else i <- i+1
  }
  if(length(factors)==1) return(c(x))
  else return(factors[-1])
}

########################################################################################
### SECTION 1.4, repeat and loops controls
########################################################################################


# 1.4.1

repeat_find_cumsum <- function(x, find_sum) {
  if(!is.numeric(x) | !is.vector(x) | !is.numeric(find_sum)) stop("Value(s) not allowed!")
  s <- 0
  i <- 1
  repeat {
    if(s>find_sum | i>length(x)) break
    s <- s + x[i]
    i <- i+1
  }
  return(s)
}

# 1.4.2

repeat_my_moving_median <- function(x, n, ...) {
  if(!(is.numeric(n) & length(n)==1) | !is.numeric(x)) stop("Not all values are numeric!")
  moving_median <- rep(NA, length(x)-n)
  i <- 1
  repeat {
    if(i>length(x)-n) break
    moving_median[i] <- median(x[i:(i+n)], ...)
    i <- i+1
  }
  return(moving_median)
}

########################################################################################
### SECTION 1.5, ENVIRONMENT
########################################################################################


# 1.5.1

in_environment <- function(env) {
  return(ls(env))
}

# 1.5.2

where <- function(fun) {
  if(!is.character(fun) | length(fun)!=1) stop("Argument value is not allowed!")
  env_list <- search()
  found <- FALSE
  for(i in 1:length(env_list)) {
    if(fun %in% ls.str(env_list[i])) {
      found <- i
      break
    }
  }
  if(!found) stop(paste(fun, "not found!"))
  return(env_list[found])
}

########################################################################################
### SECTION 1.6, FUNCTIONALS
########################################################################################


# 1.6.1

cov <- function(X) {
  if(!is.data.frame(X)) stop("Argument is not a data.frame type!")
  return( unlist(lapply(X, function(x) sd(x)/mean(x))) )
}

########################################################################################
### SECTION 1.7, CLOSURES
########################################################################################


# 1.7.1

moment <- function(i) {
  if(!is.numeric(i)) stop("Argument value is not an integer!")
  function(x) {
    if(!is.vector(x)) stop("Argument value is not a vector!")
    mean((x-mean(x))^i)
  }
}

# 1.7.2

mcmc_counter_factory <- function(burnin, thin) {
  if(burnin<0 | thin<=0) stop("Arguments value(s) are not allowed!")
  counter <- function() {
    iteration <- 0
    samples <- 0
    function() {
      iteration <<- iteration + 1
      if(iteration>burnin & ((iteration-burnin)%%thin==0)) {
        store_sample <<- TRUE
        samples <<- samples + 1
      }
      else store_sample <<- FALSE
      list(iteration, store_sample, samples)
    }
  }
  counter()
}

name <- "Stefano Toffol"
liuid <- "steto820"
