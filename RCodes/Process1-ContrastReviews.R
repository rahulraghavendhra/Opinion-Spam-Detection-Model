predictTest <- function(test_text, mat, classifier){
  train_mat = mat[1:2,]
  train_mat[,1:ncol(train_mat)] = 0
  
  test_matrix = create_matrix(test_text, language="english", removeStopwords=T, removeNumbers=T,stemWords=T, toLower=T, removePunctuation=T)
  test_mat <- as.matrix(test_matrix)
  
  for(col in colnames(test_mat)){
    if(col %in% colnames(train_mat))
    {
      train_mat[2,col] = test_mat[1,col];
    }
  }
  
  #test_mat = as.matrix(t(test_mat))
  row.names(train_mat)[1] = ""
  row.names(train_mat)[2] = test_text
  p <- predict(classifier, train_mat[1:2,])
  as.character(p[2])
}


#reading the training data-set
data <- read.csv("/home/rahul/Documents/BIS/Project/Data/training/Final-training.csv")
mat <- create_matrix(data[,1], language="english", removeStopwords=T, removeNumbers=T,stemWords=T, toLower=T, removePunctuation=T, removeSparseTerms=0.998)
mat = as.matrix(mat)

#building svm classifier model
svm_classifier = svm(mat, as.factor(data[,3]))
output_svm <- predictTest('this is not nice', mat, svm_classifier) 
output_svm
data_test <- read.csv("/home/rahul/Documents/BIS/Project/Data/test/test-final.csv")
for(i in 1:length(data_test$DETAILEDREVIEW)){
  output_svm[i] <- predictTest(data_test$DETAILEDREVIEW[i], mat, svm_classifier)  
  #dat$y[i] <- dat$x[i]^2
}

data_svm <- cbind(data, output_svm)
write.csv(data_svm, "/home/rahul/Documents/BIS/Project/Data/Results/R-Results/output-training-svm.csv")

#building naive bayes classifier
nb_classifier = naiveBayes(mat, as.factor(data[,3]))
output_nb <- predictTest('Wow! this is not nice', mat, nb_classifier) 
for(i in 1:length(data$Reviews)){
  output_nb[i] <- predictTest(data$Reviews[i], mat, nb_classifier)  
  #dat$y[i] <- dat$x[i]^2
}

output_nb

data_nb <- cbind(data, output_nb)

write.csv(data, "/home/rahul/Documents/BIS/Project/Data/Results/R-Results/output-training-nb.csv")
