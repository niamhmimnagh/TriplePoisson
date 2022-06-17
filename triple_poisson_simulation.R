# Function to simulate data for the triple Poisson model
dataSimulation<-function(lambda_g, lambda_n, alpha, ntransects){
  
  G <- rpois(1, lambda_g) ## number of groups
  N <- rpois(G, lambda_n) ## number of individuals per group
  TT <- sum(N) ## total number of individuals
  YY <- rpois(ntransects, alpha * TT ) ## produced number of vestiges
  nu <- runif(ntransects,0,0.05) ## coverage of the transects
  Y <- rpois(ntransects,nu*alpha*TT) ## observed number of vestiges by transect
  
  dataList<-list("Y"=Y, 
                 "lambda_g"=lambda_g, 
                 "lambda_n"=lambda_n, 
                 "alpha"=alpha, 
                 "G"=G, 
                 "N"=N, 
                 "TT"=TT, 
                 "YY"=YY, 
                 "nu"=nu,
                 "ntransects"=ntransects)
  return(dataList)
}

# Function to run the JAGS code and save results
modelRun<-function(Y, nu, alpha){
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
      lambda_n ~ dgamma(0.01,0.01) 
      lambda_g ~ dunif(0.01,0.01)
  }", file={alphaCorrect <- tempfile()})
  
  jags.params=c("lambda_n", "lambda_g","TT")
  jags.data <- list("Y" = Y, "sample_size" = length(Y),"nu" = nu, "alpha"=alpha)
  list2env(jags.data , envir=globalenv())
  correctAlphaModel <- jags.parallel(
    model = alphaCorrect,
    parameters.to.save = jags.params,
    data = names(jags.data),
    n.iter=50000,
    n.chains = 3,
    n.burnin = 20000,
    n.thin = 10)
  
  modList<-list("lambda_n_est"=correctAlphaModel$BUGSoutput$mean$lambda_n,
                "lambda_g_est"=correctAlphaModel$BUGSoutput$mean$lambda_g,
                "TT_est"=correctAlphaModel$BUGSoutput$mean$TT,
                "summary"=correctAlphaModel$BUGSoutput$summary)
  return(modList)
}



# Wrapper function to run the above functions 
simulation<-function(ndatasets, lambda_g, lambda_n, alpha, ntransects){
  data1<-vector("list", length=ndatasets)
  
  
  for(dataset in 1:ndatasets){
    data1[[dataset]]<-c(data1[[dataset]],
                        dataSimulation(alpha=alpha,lambda_g=lambda_g,lambda_n=lambda_n, ntransects=ntransects))
  }
  
  
  
  for(dataset in 1:ndatasets){
    data1[[dataset]]<-c(data1[[dataset]],
                        modelRun(Y=data1[[dataset]][["Y"]],
                                 nu=data1[[dataset]][["nu"]],
                                 alpha=data1[[dataset]][["alpha"]]))
    print(paste("dataset (",dataset, ") complete", sep=""))
  }
  return(data1)
}


# This function takes a dataset produced by the simulation function above and returns mean relative bias in estimates of mean group size, number of groups and abundance
relativeBias<-function(datalist){
  lambda_g<-lambda_n<-TT<-vector(length=length(datalist))
  for(i in 1:length(datalist)){
    lambda_g[i]<-mean((abs(datalist[[i]][["lambda_g_est"]]-datalist[[i]][["lambda_g"]]))/abs(datalist[[i]][["lambda_g"]]))
    lambda_n[i]<-mean((abs(datalist[[i]][["lambda_n_est"]]-datalist[[i]][["lambda_n"]]))/abs(datalist[[i]][["lambda_n"]]))
    TT[i]<-mean((abs(datalist[[i]][["TT_est"]]-datalist[[i]][["TT"]]))/abs(datalist[[i]][["TT"]]))
  }
  result<-cbind("RB.lambda_g"=lambda_g, 
                "RB.lambda_n"=lambda_n, 
                "RB.TT"=TT)
  return(result)
}




# This function takes a dataset produced by the simulation function above and returns the true value of abundance, the estimated value and the 95% credible interval
credibleInterval<-function(datalist){
  TT<-estimatedTT<-lowerBound<-upperBound<-vector(length=100)
  dat<-matrix(ncol=4, nrow=100)
  for(i in 1:length(datalist)){
      # Values for true and estimated TT
    TT[i]<-datalist[[i]][["TT"]]   
    estimatedTT[i]<-datalist[[i]][["TT_est"]]
  
  
  # 95% Credible Intervals
  modelsummary<-datalist[[i]][["summary"]]      
  credibleInterval<-as.data.frame(modelsummary[,c(3,7)])                                  
  credibleInterval<-as.vector(credibleInterval[grep("TT",rownames(credibleInterval)),])
  lowerBound[i]<-credibleInterval[,1]
  upperBound[i]<-c(credibleInterval[,2])
  
  dat[i,]<-cbind(TT[i], estimatedTT[i], lowerBound[i], upperBound[i])
  }
  colnames(dat)<-c("TT","estimatedTT", "lowerBound", "upperBound")
  dat<-as.data.frame(dat)
return(dat)
}

