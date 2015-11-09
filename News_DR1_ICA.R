library(ggplot2)
library(fastICA)
library(ica)
library(devtools)
library(ggbiplot)
library(FactoMineR)
library(nFactors)

#Get files for the analysis
setwd("/Users/paulinechow/ML_hmwk_3")
original <- read.csv('./data/A3_OnlineNewPopularity_sharegrps_labeled.csv', header=TRUE, sep = ",")
# news_k8_labels <- original[,length(original)] #update NA
news_shares5_labels <- original['shares_5']

drops <- c("url","timedelta", "shares_log", "shares_2", "shares_3", "shares_5") 
news <- original[,!(names(original) %in% drops)] 
news.scaled <- as.data.frame(scale(news))
news.scaled_labels <- data.frame(news.scaled, news_shares5_labels)

################### ICA Analysis #########################
##########################################################
ica_model <- fastICA(news.scaled, 30, alg.typ="parallel", fun="exp", maxit=1000)
ica_deflate <- fastICA(news.scaled, 30, alg.typ="deflation", fun="exp", maxit=1000)
ICA_ResultsX <- (as.matrix(news.scaled) %*% ica_model$K) %*% ica_model$W

summary(ica_model)
summary(ica_deflate)

# ica$W
# plot(ica$W)

#PLOT PARALLEL OUTPUTS
par(mfrow = c(2, 3))
plot(ica_model$X, main = "Pre-processed data")
plot(ica_model$X %*% ica_model$K, main = "PCA components")
plot(ica_model$S, main = "ICA components")
plot(ica_model$K, main = "Pre-whitening components")
plot(ica_model$A, main = "Estimated Mixing Matrix")
plot(ica_model$W, main = "Estimated UNMixing Matrix")
mtext("ICA N_Components = 40", side = 3, line = -25, outer = TRUE)

#PLOT DEFLATE OUTPUTS
par(mfrow = c(2, 3))
plot(ica_deflate$X, main = "Pre-processed data")
plot(ica_deflate$X %*% ica_deflate$K, main = "PCA components")
plot(ica_deflate$S, main = "ICA components")
plot(ica_deflate$K, main = "Pre-whitening components")
plot(ica_deflate$A, main = "Estimated Mixing Matrix")
plot(ica_deflate$W, main = "Estimated UN-Mixing Matrix")
mtext("ICA Deflate N_Components = 30", side = 3, line = -25, outer = TRUE)

par(mfrow = c(2, 3))
for (i in c(7, 20, 30, 40, 50, 59)){
  ica_loop_model <- fastICA(news.scaled, i, alg.typ="parallel", fun="exp", maxit=1000)
  plot(ica_loop_model$S, main = c("ICA components ", i))
  
}

###Plot Densities and kurtosis for 18 of Source Signal Distribution
quartz(height=9,width=7)
icaplot()

###Output components to keep + send to NN
news_keep1 = data.frame(ica_model$S[,1:20])
write.csv(news_keep1, file='./logs/News_ICA_output.csv', row.names=TRUE)
