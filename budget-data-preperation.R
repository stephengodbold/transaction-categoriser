library(dplyr)
library(fuzzyjoin)

loadData <- function() {
  rawData <- read.csv('C:\\Users\\steph\\OneDrive\\Budget\\data\\transactions.csv')
  
  rawData['source'] <- rawData['ï..source.account']
  rawData['effective'] <- rawData['effective.date']
  rawData['entered'] <- rawData['entered.date']
  
  rawData['ï..source.account'] <- NULL
  rawData['effective.date'] <- NULL
  rawData['entered.date'] <- NULL
  
  return(rawData)
}

categoriseData <- function(data) {
  categoryLabels <- read.csv('C:\\Users\\steph\\OneDrive\\Budget\\data\\category-labels.csv')
  categoryLabels$name <- categoryLabels$ï..Name
  categoryLabels$ï..Name <- NULL
  
  data['L1Category'] <- 'Other'
  
  #doesn't work, but is a start
  matchedData <- data %>% 
    stringdist_left_join(categoryLabels, by=c(description='name'), 
                         ignore_case=T, 
                         method='jw', 
                         distance_col='dist')


  

  #groceries
  #contains(data$description
    
  data$L1Category <- as.factor(data$L1Category)
  
  return(matchedData)
}

budgetData <- loadData()
budgetData <- categoriseData(budgetData)

head(budgetData)
summary(budgetData)
