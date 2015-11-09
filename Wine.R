library(ggplot2)
library(fastICA)
library(ica)
library(devtools)
library(ggbiplot)
library(FactoMineR)
library(nFactors)
library(rattle)
library(NbClust)
library(EMCluster)
library(nFactors)
library(psych)
library(ggbiplot)
library(fpc)

#Get files for the analysis
setwd("/Users/paulinechow/ML_hmwk_3")

# get data from package or data folder in the materials
data(wine, package="rattle")
head(wine) 
data.train <- scale(wine[,-1])
data.labels <- wine[,-1]
head(data.train)

#clustering on wine
nc <- NbClust(data.train,
              min.nc=2, max.nc=15,
              method="kmeans")
barplot(table(nc$Best.n[1,]),
        xlab="Numer of Clusters",
        ylab="Number of Criteria",
        main="Number of Clusters Chosen by 26 Criteria")
#scree plot
wss <- 0
for (i in 1:15){
  wss[i] <-
    sum(kmeans(data.train, centers=i)$withinss)
}
plot(1:15,
     wss,
     type="b",
     xlab="Number of Clusters",
     ylab="Within groups sum of squares")

# fit data to kmeans model for visualizations
fit.km <- kmeans(data.train, 4)
quartz(height=9,width=7)
plotcluster(data.train, fit.km$cluster)
mtext("Wine Kmeans: 4 clusters", side = 3, line = -3, outer = TRUE)

#Expectation Maximization 
em_return <- simple.init(data.train, nclass = 5)
em_return <- shortemcluster(data.train, em_return)
summary(em_return)
ret <- emcluster(em_return,data.train,  assign.class = TRUE)
summary(ret)
quartz(height=9,width=7)
plotem(ret, data.train)

# Model Based Clustering
library(mclust)
fit <- Mclust(data.train)
plot(fit) # plot results 
mtext("Wine Model Based Clustering Compares Models", side = 3, line = -3, outer = TRUE)
summary(fit) # display the best model

##################PCA
pca_fit <- princomp(data.train, cor=TRUE)
summary(pca_fit) # print variance accounted for 
loadings(pca_fit) # pc loadings 
plot(pca_fit,type="lines") # scree plot 
mtext("Wine PCA Scree Plot", side = 3, line = -3, outer = TRUE)

pca_fit$scores # the principal components
biplot(pca_fit)

## PCA with prcomp
wine.pca <- prcomp(data.train, scale. = TRUE)
result <- PCA(data.train) # graphs generated automatically

#****************************** OUTPUT FOR NEXT CLUSTERING
pca_keep = data.frame(pca_fit$scores[,1:4])
write.csv(pca_keep, file='./logs/Wine_PCA_output.csv', row.names=TRUE)
#************************** 


## ICA
ica_model <- fastICA(data.train, 30, alg.typ="parallel", fun="exp", maxit=1000)
summary(ica_model)

#PLOT PARALLEL OUTPUTS
par(mfrow = c(2, 3))
plot(ica_model$X, main = "Pre-processed data")
plot(ica_model$X %*% ica_model$K, main = "PCA components")
plot(ica_model$S, main = "ICA components")
plot(ica_model$K, main = "Pre-whitening components")
plot(ica_model$A, main = "Estimated Mixing Matrix")
plot(ica_model$W, main = "Estimated UNMixing Matrix")
# mtext("ICA N_Components = 40", side = 3, line = -25, outer = TRUE)

par(mfrow = c(2, 3))
for (i in c(1,2,4,8,10)){
  ica_loop_model <- fastICA(data.train, i, alg.typ="parallel", fun="exp", maxit=1000)
  plot(ica_loop_model$S, main = c("ICA components ", i))
  
}

###Plot Densities and kurtosis for 18 of Source Signal Distribution
quartz(height=9,width=7)
icaplot()

########## Randomized Projections
#############################################
randomProjection <- function(A, k = 6) {
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

RCA_output <- randomProjection(data.train)
summary(RCA_output)
head(RCA_output)

## EFA
efa_fit <- factanal(data.train, 8, rotation="varimax")
print(efa_fit, digits=2, cutoff=.3, sort=TRUE)

# plot factor 1 by factor 2
load <- efa_fit$loadings[,1:8]
quartz(height=9,width=7)
plot(load,type="n") # set up plot 
text(load,labels=names(data.train),cex=.7) # add variable names

print(loadings(efa_fit), cutoff = 1e-05) -> efa_loadings

#get values for components here
corMat <- cor(data.train)
fit3 <- fa(corMat, nfactors=9,rotate = "oblimin", fm = "pa")
fit3
