library("e1071")
library("RTextTools")
readText <- function(filename){
  result<- c()
  current.line <- 1
  con <- file(filename)
  open(con)
  tmp = ""
  while(length(line <- readLines(con, n=1, warn=FALSE)) > 0 ){
    if (current.line == 1){
      tmp = line
    }
    else{
      if (line == "#######"){
        result <- c(result, tmp)
        tmp = ""
      }
      else{
        tmp <- paste(tmp, line)
      }
    }
    current.line <- current.line + 1
  }
  
  close(con)
  return (result)
}

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
pos <- readText("/home/rahul/Documents/BIS/Project/Data/Traindata-prof/positive.txt")
pos_class <- rep("positive", length(pos))
pos_data <- cbind(pos, pos_class)

neg <- readText("/home/rahul/Documents/BIS/Project/Data/Traindata-prof/negative.txt")
neg_class <- rep("negative", length(neg))
neg_data <- cbind(neg, neg_class)

#training_data <- rbind(pos_data, neg_data)

#using a smaller set of training data (large memory requirements)
data <- rbind(pos_data[1:1000,], neg_data[1:1000,])


#data <- read.csv("/home/rahul/Documents/BIS/Project/Data/training/Final-training.csv")
mat <- create_matrix(data[,1], language="english", removeStopwords=T, removeNumbers=T,stemWords=T, toLower=T, removePunctuation=T, removeSparseTerms=0.998)
mat = as.matrix(mat)
mat
colnames(data)

nb_classifier = naiveBayes(mat, as.factor(data[,2]))
predictTest("I hate it", mat, nb_classifier)
predictTest("Wow thats not nice ", mat, nb_classifier)

data_sample <- read.csv("/home/rahul/Documents/BIS/Project/Data/testdemo.csv")
#data_sample <- data[1:10,]
for(i in 1:length(data_sample$Reviews)){
  output[i] <- predictTest(data_sample$Reviews[i], mat, nb_classifier)  
  #dat$y[i] <- dat$x[i]^2
}
data_output <- cbind(data_sample, output)
colnames(data_output)
spam_output <- "hi"
#for(i in 1:length(data_sample$Reviews)){
 # if((data_sample$Rating[i] < 3 and data_sample$output[i] == 'positive') and (data_sample$Rating[i] > 3 and data_sample$output[i] == 'negative')) {spam_output[i] <- 'SPAM'}else{spam_output[i] <- 'NOT SPAM'}
#}
for(i in 1:length(data_output$Reviews)){
  if((data_output$Rating[i] < 3 & data_output$output[i] == 'positive') | (data_output$Rating[i] > 3 & data_output$output[i] == 'negative')) {spam_output[i] <- "SPAM"}else{spam_output[i] <- "NOT SPAM"}
}
data_output <- cbind(data_output, spam_output)
write.csv(data_output, "/home/rahul/Documents/BIS/Project/Data/fina_output.csv")
spam_output