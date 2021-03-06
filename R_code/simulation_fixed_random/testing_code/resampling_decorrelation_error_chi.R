# Following simulation is to test if under normal distribution, we can estimate the interaction effect unbaisly by proposed method

setwd("~/dev/projects/Chen_environmental_study/")
source("./R_code/Yang_REML.R")
source("./R_code/simulation_fixed_random/chi_square_fixed_random_simulation_helpers.R")

library(sas7bdat)
library(MASS)
library(tidyverse)
library(foreach)
library(doRNG)
library(doParallel)

## covariance matrix estimation
est_cov_chi <- function(n, p, rho, chi_coef = 1) {
  # generate individual chi_square
  p_normal <- p*chi_coef
  cor_str <- matrix(rep(rho,p_normal^2), ncol = p_normal)
  diag(cor_str) <- 1
  x <- mvrnorm(n = n,
               mu = rep(0,p_normal),
               Sigma = cor_str)
  x <- x^2
  
  # combine different chi square to get different degree of freedom
  if(chi_coef == 1) {len_index <- p; index_p <- sample(1:p)}
  else len_index <- 0
  
  while(len_index < p) {
    index_p <- sample(1:p, p_normal, replace = TRUE)  
    len_index <- unique(index_p) %>% length(.)
  } # make sure we sample all p different groups with replacement
  index_list <- split(1:p_normal, index_p)
  
  b <- lapply(X = index_list, 
              FUN = function(data, index) {rowSums(data[,index, drop = FALSE])}, data = x) %>%
    Reduce(cbind, x = .)
  cor(b)
}

## estimate the true covariance correlation matrix 

n <- 100
p <- 34
rho <- 0.6
registerDoParallel(20)

rs <- foreach(i = 1:10000) %dopar% {
  est_cov_chi(n = n, p = p, rho = rho)
}

# it seems that the correlation is also sqaure for the chi-square distribution
est_cov <- Reduce("+", rs)/10000

## testing the estimation of cov of different size of sub-sampling size 

pro <- seq(0.1, 0.9, 0.1)
p_normal <- 34 
cor_str <- matrix(rep(rho,p_normal^2), ncol = p_normal)
diag(cor_str) <- 1
x <- mvrnorm(n = n,
             mu = rep(0,p_normal),
             Sigma = cor_str)
X <- x^2

cor_list <- as.list(numeric(9))

for(i in 1:length(pro)){
  cor_tmp <- foreach(j = 1:1000) %dopar% {
                                          x_sub <- X[sample(1:n,n*pro[i],replace = FALSE),]
                                          cor(x_sub)
  }
  cor_list[[i]] <- Reduce("+", cor_tmp)/1000
}
