library(here)
library(dplyr)
library(fuzzyjoin)

loadData <- function() {
  rawData <- read.csv(here('budget-manager','data', 'transactions.csv'))
  
  rawData['source'] <- rawData['ï..source.account']
  rawData['effective'] <- rawData['effective.date']
  rawData['entered'] <- rawData['entered.date']
  rawData['transactionId'] <- 1:nrow(rawData)
  
  rawData['ï..source.account'] <- NULL
  rawData['effective.date'] <- NULL
  rawData['entered.date'] <- NULL
  
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