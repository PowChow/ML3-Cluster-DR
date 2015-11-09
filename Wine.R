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

library(ggbiplot)
library(fpc)

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

#PCA
fit <- princomp(data.train, cor=TRUE)
summary(fit) # print variance accounted for 
loadings(fit) # pc loadings 
plot(fit,type="lines") # scree plot 
mtext("Wine PCA Scree Plot", side = 3, line = -3, outer = TRUE)

fit$scores # the principal components
biplot(fit)


wine.pca <- prcomp(data.train, scale. = TRUE)

ggbiplot(wine.pca, obs.scale = 1, var.scale = 1,
         groups = wine.labels, ellipse = TRUE, circle = TRUE) +
  scale_color_discrete(name = '') +
  theme(legend.direction = 'horizontal', legend.position = 'top')