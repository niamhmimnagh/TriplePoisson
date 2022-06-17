# Mimnagh et al.
# A Bayesian Model to Estimate Abundance Based on Scarce Animal Vestige Data
# https://doi.org/10.48550/arXiv.2206.05944
# This script simulates data for the triple Poisson model, and fits the model with both a Poisson and negative binomial distribution on observed occupancy.
 # The models are then compared using DIC values.

library(R2jags)

# Notation:
# Y[i] = number of vestiges observed at each transect
# alpha = vestige production rate
# TT = abundance
# nu[i] = transect coverage rate
# G = number of groups
# lambda_G = mean number of groups
# lambda_N = mean group size

# Simulate Scarce Data:
alpha<-100
ntransects<-2
lambda_N<-7
lambda_G<-11
G<-rpois(1,lambda_G)
TT<-rpois(1,G*lambda_N)
nu<-rep(0.01, ntransects)
Y<-vector(length=ntransects)
for(i in 1:ntransects){
  Y[i]<-rpois(1, alpha*TT*nu[i])

}



# JAGS code (Poisson top tier):
 cat("
model {
  for(i in 1:sample_size) {
    ## observation process
    Y[i] ~ dpois(alpha * TT * nu[i])
  }
  
  ## latent processes
  TT ~ dpois(G * lambda_n)
  G ~ dpois(lambda_g)
  
  ## priors
    lambda_n ~ dgamma(0.1,0.1) 
    lambda_g ~ dgamma(0.1,0.1)
}", file={alphaUniform <- tempfile()})
  
 # choose parameters to watch
  jags.params=c("lambda_n", "lambda_g","TT")
  
  # set up the data
  jags.data <- list("Y" = Y, "sample_size" = length(Y),"nu" = nu, "alpha"=alpha)
  list2env(jags.data , envir=globalenv())
  
  jags_model_poisson <- jags.parallel(
    model = alphaUniform,
    parameters.to.save = jags.params,
    data = names(jags.data),
    n.iter=50000,
    n.chains = 3,
    n.burnin = 20000,
    n.thin = 10)

  
  
# JAGS Code (Negative binomial top tier)  
  cat("
model {
  for(i in 1:sample_size) {
    ## observation process
    Y[i] ~ dnegbin(p[i],r)              # p = success parameter = r/(r+Poisson Mean)
    p[i] <- r/(r+(alpha * TT * nu[i]))
  }
  
  ## latent processes
  TT ~ dpois(G * lambda_n)
  G ~ dpois(lambda_g)
  
  ## priors
    r ~ dunif(0,50)
    lambda_n ~ dgamma(0.1,0.1) 
    lambda_g ~ dgamma(0.1,0.1)
}", file={alphaUniform <- tempfile()})
  
  jags.params=c("alpha","lambda_n", "lambda_g","TT","r")
  jags.data <- list("Y" = Y, "sample_size" = length(Y),"nu" = nu, "alpha"=alpha)
  list2env(jags.data , envir=globalenv())
  
  jags_model_negbin <- jags.parallel(
    model = alphaUniform,
    parameters.to.save = jags.params,
    data = names(jags.data),
    n.iter=50000,
    n.chains = 3,
    n.burnin = 20000,
    n.thin = 10)
  
# Results
  print(jags_model_poisson)
  print(jags_model_negbin)
  
# Comparison
  AICcmodavg::DIC(jags_model_poisson)
  AICcmodavg::DIC(jags_model_negbin)
  
  
