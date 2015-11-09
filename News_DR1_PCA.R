library(ggplot2)
library(fastICA)
library(ica)
library(devtools)
library(ggbiplot)
library(FactoMineR)
library(nFactors)

#Get files for the analysis
setwd("/Users/paulinechow/ML_hmwk_3")
original <- read.csv('./data/News_Original.csv', header=TRUE, sep = ",")
# news_k8_labels <- original[,length(original)] #update NA
news_shares5_labels <- original['shares_5']

drops <- c("url","timedelta", "shares_log", "shares_2", "shares_3", "shares_5") 
news <- original[,!(names(original) %in% drops)] 
news.scaled <- as.data.frame(scale(news))
news.scaled_labels <- data.frame(news.scaled, news_shares5_labels)
################### PCA analysis
#############################################

#NEWS scaled PCA 
news_pca<-princomp(news.scaled,scale.=F)
news_prpca<-prcomp(news,scale. =F)
news_pca$sdev

summary(news_pca)
screeplot(news_pca,type="lines",col=59, main='R PCA Scree Plot')

#nFactor approach, Determine # of Factors to Extract
#other option for scree
ev <- eigen(cor(news.scaled)) # get eigenvalues
ap <- parallel(subject=nrow(news.scaled),var=ncol(news.scaled),
               rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea) 
plotnScree(nS)

#PCA Variable Factor Map
result <- PCA(news.scaled[,1:25])
# loadings(news_fit)
# biplot(news_fit) #graphs the intersection of comp 1 and comp 2 -- not very informative
# pca$rotation
pca$score 
# predict(news_pca, 
#         newdata=tail(news.scaled, 2))

#Plot results -- Does not work for first round of dimensionality reduction
# g <- ggbiplot(news_prpca, obs.scale = 1, var.scale = 1, 
#               groups = news_shares5_labels, ellipse = TRUE, 
#               circle = TRUE)
# g <- g + scale_color_discrete(name = '')
# g <- g + theme(legend.direction = 'horizontal', 
#                legend.position = 'top')
# print(g)
###################################
#OUTPUT TO FILE FOR CLUSTERING AND NN
news_keep1 = data.frame(news_pca$scores[,1:25])
write.csv(news_keep1, file='./logs/News_PCA_output.csv', row.names=TRUE)
