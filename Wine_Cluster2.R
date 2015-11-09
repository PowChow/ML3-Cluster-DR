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
data_2 <- read.csv('./logs/Wine_PCA_output.csv', header=TRUE, sep = ",")

#clustering on wine
nc <- NbClust(data_2,
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
    sum(kmeans(data_2, centers=i)$withinss)
}
plot(1:15,
     wss,
     type="b",
     xlab="Number of Clusters",
     ylab="Within groups sum of squares")

# fit data to kmeans model for visualizations
fit2.km <- kmeans(data_2, 3)
quartz(height=9,width=7)
plotcluster(data.train, fit2.km$cluster)
mtext("AFTER Wine Kmeans: 3 clusters", side = 3, line = -3, outer = TRUE)

#Expectation Maximization 
em_return2 <- simple.init(data2, nclass = 5)
em_return2 <- shortemcluster(data2, em_return2)
summary(em_return2)
ret2 <- emcluster(em_return2, data2,  assign.class = TRUE)
summary(ret2)
quartz(height=9,width=7)
plotem(ret, data2)

# Model Based Clustering
library(mclust)
fit <- Mclust(data.train)
plot(fit) # plot results 
mtext("Wine Model Based Clustering Compares Models", side = 3, line = -3, outer = TRUE)
summary(fit) # display the best model