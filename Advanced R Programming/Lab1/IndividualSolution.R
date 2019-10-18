########################################################################################
### SECTION 1.1, VECTORS
########################################################################################


# 1.1.1

my_num_vector <- function() {
  return( c(log(11, base = 10), cos(pi/5), exp(pi/3), (1173 %% 7)/19) )
}

# 1.1.2

filter_my_vector <- function(x, leq) {
  x[x>=leq] <- NA
  return(x)
}

# 1.1.3

dot_prod <- function(a,b) {
  return(sum(a*b))
}

# 1.1.4

approx_e <- function(N) {
  x <- 0:N
  return(sum(1/factorial(x)))
}

# verify <- T
# i <- 1
# while(verify) {
#   
#   if(round(approx_e(i), 5)==round(exp(1), 5)) {
#     verify <- F
#     print(i)
#   }
#   
#   else i <- i+1
# }

# It's sufficient to put N=8 in order to approximate exp(1) to the fifth decimal place

########################################################################################
### SECTION 1.2, Matrices
########################################################################################


# 1.2.1

my_magic_matrix <- function() {
  return( matrix(c(4,3,8,9,5,1,2,7,6), 3, 3) )
}

# The magic is: every row, column and diagonal of the matrix sum to 15

# 1.2.2

calculate_elements <- function(A) {
  return( NROW(A)*NCOL(A) )
}

# 1.2.3

row_to_zero <- function(A, i) {
  A[i,] <- 0
  return(A)
}

# 1.2.4

add_elements_to_matrix <- function(A, x, i, j) {
  A[i,j] <- A[i,j] + x
  return(A)
}

########################################################################################
### SECTION 1.3, Lists
########################################################################################


# 1.3.1

my_magic_list <- function() {
  return( list(info = "my own list", my_num_vector(), my_magic_matrix()) )
}

# 1.3.2

change_info <- function(x, text) {
  x$info <- text
  return(x)
}

# 1.3.3

add_note <- function(x, note) {
  x$note <- note
  return(x)
}

# 1.3.4

sum_numeric_parts <- function(x) {
  return( sum(as.numeric(unlist(x, recursive = TRUE)), na.rm = TRUE) )
}

########################################################################################
### SECTION 1.4, Data frames
########################################################################################


# 1.4.1

my_data.frame <- function() {
  return( data.frame(id = 1:3, name = c("John", "Lisa", "Azra"), 
                     income = c(7.3, 0, 15.21), rich = c(FALSE, FALSE, TRUE)) )
}

# 1.4.2

sort_head <- function(df, var.name, n) {
  temp <- df[order(df[,which(colnames(df)==var.name)], decreasing = TRUE),]
  return(temp[1:n,])
}

# 1.4.3

add_median_variable <- function(df, j) {
  m <- median(df[,j])
  compared_to_median <- rep(NA, NROW(df))
  compared_to_median[which(df[,j]>m)] <- "Greater"
  compared_to_median[which(df[,j]<m)] <- "Smaller"
  compared_to_median[which(df[,j]==m)] <- "Median"
  return( data.frame(df, compared_to_median = compared_to_median) )
}

# 1.4.4

analyze_columns <- function(df, j) {
  mylist <- list()
  summary1 <- c(mean(df[,j[1]]), median(df[,j[1]]), sd(df[,j[1]]))
  names(summary1) <- c("mean", "median", "sd")
  mylist[[ colnames(df)[j[1]] ]] <- summary1
  summary2 <- c(mean(df[,j[2]]), median(df[,j[2]]), sd(df[,j[2]]))
  names(summary2) <- c("mean", "median", "sd")
  mylist[[ colnames(df)[j[2]] ]] <- summary2
  mylist[[ "correlation_matrix" ]] <- cor(df[,j], df[,j])
  return( mylist )
}

name <- "Stefano Toffol"
liuid <- "steto820"
