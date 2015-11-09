library(ggplot2)
library(fastICA)
library(ica)
library(devtools)
library(ggbiplot)
library(FactoMineR)
library(nFactors)
library(mclust)

#Get files for the analysis
setwd("/Users/paulinechow/ML_hmwk_3")
original <- read.csv('./data/News_Original.csv', header=TRUE, sep = ",")
# news_k8_labels <- original[,length(original)] #update NA
news_shares5_labels <- original['shares_5']

drops <- c("url","timedelta", "shares_log", "shares_2", "shares_3", "shares_5") 
news <- original[,!(names(original) %in% drops)] 
news.scaled <- as.data.frame(scale(news))
news.scaled_labels <- data.frame(news.scaled, news_shares5_labels)

########## Randomized Projections
#############################################
randomProjection <- function(A, k = 20) {
  #input: dataset (with target classification as the last feature), k (number of desired random projections)
  #output: random directions that maintian some information from the previous dimensions
  require(dplyr)
  
  myTarget <- colnames(A)[ncol(A)]
  
  if (!is.matrix(A)) {
    tmp <- as.matrix(select(A, -ncol(A)))
  } else {
    tmp <- select(A, -ncol(A))
  }
  
  p <- ncol(tmp)
  set.seed(as.numeric(format(Sys.time(), '%S')))
  R <- matrix(data = rnorm(k*p),
              nrow = k,
              ncol = p)
  tmp <- apply(tmp, 2, function(x) (x - mean(x)) / sd(x))
  returnFrame <-as.data.frame(t(R %*% t(tmp))) %>% mutate(myTarget = A$myTarget)
  
  #changes last column name to the target classification
  colnames(returnFrame)[ncol(returnFrame)] <-myTarget
  
  return(returnFrame)
}

RCA_output <- randomProjection(news.scaled)
summary(RCA_output)
head(RCA_output)

#screeplot(RCA_output,type="lines",col=59, main='R RCA Scree Plot')
###Output components to keep + send to NN
news_keep1 = data.frame(RCA_output[,1:15])
write.csv(news_keep1, file='./logs/News_RCA_output.csv', row.names=TRUE)

