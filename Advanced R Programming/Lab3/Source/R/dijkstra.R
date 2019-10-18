#' Dijkstra
#'
#' @param graph data frame with 3 col called v1=first node vector,v2=second node vector,w=distances vector   
#' @param init_node integer value representing the starting node
#' @references \href{https://en.wikipedia.org/wiki/Dijkstra\%27s_algorithm}{wikipedia page}
#' @description For a given source node in the graph, the algorithm finds the shortest path between that node and every other
#' The graph should be a data.frame with three variables (v1, v2 and w) that contains the edges of the graph from v1 to v2 with the weight of the edge w. The dijkstra function should return the shortest path to every other node from the starting node as a vector
#' 
#'  
#'   
#'     
#' @return a vector containing the shortest path between the starting node and other nodes
#' @export
#'
#' @examples wiki_graph <- data.frame(v1=c(1,1,1,2,2,2,3,3,3,3,4,4,4,5,5,6,6,6), 
#'                          v2=c(2,3,6,1,3,4,1,2,4,6,2,3,5,4,6,1,3,5), 
#'                          w=c(7,9,14,7,10,15,9,10,11,2,15,11,6,6,9,14,2,9))
#' dijkstra(wiki_graph, 1)
#' 

dijkstra <-
function(graph, init_node) 
{
  if(!is.data.frame(graph)) 
    stop("'graph' argument is NOT a data.frame!")
  if(NCOL(graph)!=3) 
    stop("'graph' argument has more (or less) than 3 columns!")
  if(0 %in% graph[,3])
    stop("distance vector cannot contain zero!")
  if(!is.numeric(init_node) | length(init_node)!=1) 
    stop("'init_node' argument is not a scalar!")
  if( !all.equal(colnames(graph), c("v1", "v2", "w")) )
    stop("graph names are wrong")
  values <- unique(c(graph$v1, graph$v2))
  
  if(!(init_node %in% values)) stop("'init_node' is not in the present values")
  
  d_matrix <- matrix(Inf, length(values), 2)
  #d_matrix[,1] <- values
  d_matrix[init_node,1] <- 0
  unvisited <- values
  curr_node <- init_node
  while(length(unvisited)!=0) 
  {
    indexes <- which(graph$v2==curr_node | graph$v1==curr_node)
    #temp <- graph[indexes,]
    neighbours <- rep(NA, length(indexes))
    w_i <- graph$w[indexes] + d_matrix[curr_node,1]
    for(i in 1:length(indexes))
    {
      if(graph$v1[indexes[i]]!=curr_node) neighbours[i] <- graph$v1[indexes[i]]
      else neighbours[i] <- graph$v2[indexes[i]]
      if(d_matrix[neighbours[i],1]>w_i[i]) 
      {
        d_matrix[neighbours[i],1] <- w_i[i]
        d_matrix[neighbours[i],2] <- neighbours[i]
      }
    }
    curr_node <- which(d_matrix[, 1] == min(d_matrix[unvisited,1]))
    unvisited <- unvisited[-which(unvisited==curr_node)]
  }
  return(d_matrix[,1])
}
