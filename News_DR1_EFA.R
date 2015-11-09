library(ggplot2)
library(fastICA)
library(ica)
library(devtools)
library(ggbiplot)
library(FactoMineR)
library(nFactors)
library(psych)

#Get files for the analysis
setwd("/Users/paulinechow/ML_hmwk_3")
original <- read.csv('./data/A3_OnlineNewPopularity_sharegrps_labeled.csv', header=TRUE, sep = ",")
# news_k8_labels <- original[,length(original)] #update NA
news_shares5_labels <- original['shares_5']

drops <- c("url","timedelta", "shares_log", "shares_2", "shares_3", "shares_5") 
news <- original[,!(names(original) %in% drops)] 
news.scaled <- as.data.frame(scale(news))
news.scaled_labels <- data.frame(news.scaled, news_shares5_labels)

######Exploratory Factor Analysis  - produces maximum likelihood factor analysis
#### Another example for comparison
# Maximum Likelihood Factor Analysis
# entering raw data and extracting 3 factors, 
# with varimax rotation 
fit <- factanal(news.scaled, 9, rotation="varimax")
print(fit, digits=2, cutoff=.3, sort=TRUE)

# plot factor 1 by factor 2
load <- fit$loadings[,1:20]
quartz(height=9,width=7)

plot(load,type="n") # set up plot 
text(load,labels=names(news.scaled),cex=.7) # add variable names
print(loadings(fit), cutoff = 1e-05) -> efa_loadings

#get values for components here
corMat <- cor(news.scaled)
fit3 <- fa(corMat, nfactors=9,rotate = "oblimin", fm = "pa")
fit3


####OUTPUT 
#screeplot(RCA_output,type="lines",col=59, main='R RCA Scree Plot')
###Output components to keep + send to NN
news_keep1 = data.frame(efa_loadings[,1:9])
write.csv(news_keep1, file='./logs/News_EFA_output.csv', row.names=TRUE)
