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

#Expectation Maximization 
em_return <- simple.init(news.scaled, nclass = 12)
em_return <- shortemcluster(news.scaled, em_return)
summary(em_return)
ret <- emcluster(em_return,news.scaled,  assign.class = TRUE)
summary(ret)
quartz(height=9,width=7)
plotem(ret, news.scaled)