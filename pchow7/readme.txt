pchow7
Machine Learning
Fall 2015


github repo with code and data : https://github.com/PowChow/ML3-Cluster-DR


A. Datasets: This section is instructions on how to obtain the starting point of each of these datasets. Both available from UCI repo for download
1. Online News Popularity:https://archive.ics.uci.edu/ml/datasets/Online+News+Popularity
2. Wine on UCI or directly through R: https://archive.ics.uci.edu/ml/datasets/Wine


B. Code / Scripts. Please run the following scripts or notebooks in the follow order to get the results. Assignment #3 is dependent on the order of the algorithms on the dataset + dependent on output of each of these steps: 


Online News Popularity ipython notebook, R code scripts and Weka steps: 
1. Part 1 ONline News - Clustering Kmeans v2.ipynb
2. Part 1 Online News - Dimensionality Reduction PCA, ICA, RS, COY.ipynb
3. Part 3 Online News - EFA to Clustering, GMM.ipynb
4. Part 3 Online News - ICA to Clustering, GMM.ipynb
5. Part 3 Online News - PCA to Clustering, GMM.ipynb
6. Part 3 Online News - RCA to Clustering, GMM.ipynb
7. Neural Networks Weka:
* MultiLayerPerceptron
                  weka.classifiers.functions.MultilayerPerceptron -L 0.3 -M 0.2 -N 500 -V 0 -S 0 -E 20 -H a


        - Apply models above for training and cross-validation sets
          * Cross Validation Sets 
            a. Weka Experimenter --> Setup - Advanced --> Result Generator: CrossValidationResults Producer 
            b. weka.experiment.CrossValidationResultProducer -X 10 -O splitEvalutorOut.zip -W weka.experiment.ClassifierSplitEvaluator -- -W \
                    weka.classifiers.meta.FilteredClassifier -I 0 -C 1 -- -F "weka.filters.unsupervised.instance.RemovePercentage -P 10.0" -W \
                    <Add model confirmation from above in this section>
            c. Runs: 1 to 10
            d. Generator Properties: Enable SplitEvalutor --> Classifer --> Filter --> Percentage --> manually add 10, 20, 30, 40, 50, 60, 70, 80, 90
            e. Run model configuration and plot outputs in learning curve


            CrossValidationResults Procedure
            a. Weka Experimenter --> Setup - Advanced --> Result Generator: CrossValidationResults Producer 
            b. weka.experiment.CrossValidationResultProducer -X 10 -O splitEvalutorOut.zip -W weka.experiment.ClassifierSplitEvaluator -- -W \
                    weka.classifiers.meta.FilteredClassifier -I 0 -C 1 -- -F "weka.filters.unsupervised.instance.RemovePercentage -P 10.0" -W \
                    <Add model confirmation from above in this section>
            c. Runs: 1 to 10
            d. Generator Properties: Enable SplitEvalutor --> Classifer --> Filter --> Percentage --> manually add 10, 20, 30, 40, 50, 60, 70, 80, 90
            e. Run model configuration and plot outputs in learning curve


          * Training Sets Procedure
            a. Weka Experimenter --> Setup - Advanced --> Result Generator: CrossValidationResults Producer 
            b. weka.experiment.CrossValidationResultProducer -X 10 -O splitEvalutorOut.zip -W \
                     weka.experiment.ClassifierSplitEvaluator -- -W \
                     weka.classifiers.meta.FilteredClassifier -I 0 -C 1 -- -F "weka.filters.unsupervised.instance.Resample -S 1 -Z 100.0" -W \
                    <Add model confirmation from above in this section>
            c. Runs: 1 to 10
            d. Generator Properties: Enable SplitEvalutor --> Classifer --> Filter --> SampleSizePercentage --> manually add 10, 20, 30, 40, 50, 60, 70, 80, 90
            e. Run model configuration and plot outputs in learning curve



        Wine ipython notebook and R code scripts
1. Wine - Clustering Part 1 and 3 v2.ipynb
2. Wine_Cluster2.R (last part of assignment where dimensionality reduction applied dataset are clustered again)
3. Wine.R