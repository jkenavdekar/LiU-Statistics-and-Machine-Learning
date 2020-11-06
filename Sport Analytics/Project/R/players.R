players_fun <- function() {
  
  names_teamA <- c("Harvey", "Karl", "Ronald", "John", "Bruno", "C. R.", 
                   "George W.", "Jerzy", "Harald", "Thomas", "David", "Joseph",
                   "Egon", "Hirotugu", "Corrado", "Pafnuty")
  surnames_teamA <- c("Goldstein", "Pearson", "Fisher", "Tukey", "de Finetti", "Rao",
                      "Snedecor", "Neyman", "Cramer", "Bayes", "Cox", "Kruskal",
                      "Pearson", "Akaike", "Gini", "Chebyshev")
  names_teamB <- c("Abraham", "Alan", "of Syracuse", "Brook", "Augustin-Louis",
                   "Bernhard", "David", "Edward", "Giuseppe", "Gottfried",
                   "John", "John", "Joseph", "Joseph Louis", "Leonhard", "Pierre-Simon")
  surnames_teamB <- c("De Moivre", "Turing", "Archimedes", "Taylor", "Cauchy",
                      "Riemann", "Hilbert", "Lorenz", "Peano", "Leibniz",
                      "Nash", "Von Neumann", "Fourier", "Lagrange", "Euler", "Laplace")
  output <- data.frame(players_ref = 1:32,
                       players_name = c(names_teamA, names_teamB), 
                       players_surname = c(surnames_teamA, surnames_teamB),
                       stringsAsFactors = F)
  
  return(output)
  
}
