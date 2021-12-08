library(here)
library(dplyr)
library(fuzzyjoin)

loadData <- function() {
  rawData <- read.csv(here('budget-manager','data', 'transactions.csv'))
  
  #cleaning up my augmented column name
  if ('ï..Source' %in% colnames(rawData)) {
    rawData['source'] <- rawData['ï..Source']
    rawData['ï..Source'] <- NULL
  }
  
  #simplifying default column names
  if ('ï..Effective.Date' %in% colnames(rawData)) {
    rawData['effective'] <- rawData['ï..Effective.Date']  
    rawData['ï..Effective.Date'] <- NULL
  } else {
    rawData['effective'] <- rawData['Effective.Date'] 
    rawData['Effective.Date'] <- NULL  
  }
  
  rawData['entered'] <- rawData['Entered.Date']
  rawData['description'] <- rawData['Transaction.Description']
  
  rawData['Entered.Date'] <- NULL
  rawData['Transaction.Description'] <- NULL
  
  #adding a transaction Id to enable slicing
  rawData['transactionId'] <- 1:nrow(rawData)
  
  return(rawData)
}

#load your category data, then intersect categories with transactions 
#and return the closest match for each description
categoriseData <- function(data) {
  categoryLabels <- read.csv(here('budget-manager','data', 'category-labels.csv'))
  categoryLabels$name <- categoryLabels$ï..Name
  categoryLabels$ï..Name <- NULL
  
  
  matchedData <- data %>% 
    stringdist_inner_join(categoryLabels, by=c(description='name'), 
                         ignore_case=T, 
                         method='jw', 
                         distance_col='distance') %>%
    group_by(transactionId) %>% 
    slice(which.min(distance))
  
  return(matchedData)
}

budgetData <- loadData()
budgetData <- categoriseData(budgetData)
write.csv(budgetData, here('budget-manager', 'data', 'categorised-transactions.csv'))