# Transaction Categoriser

Bank Australia is awesome, but they aren't quite there when it comes to the data they provide to manage your budget. So, to help manage the home budget I hacked together this R script that takes a category file and performs a fuzzy string match on transaction description to your category search criteria and returns the best result as a category. 

## How to

1. Clone the repository into your R working directory
2. Create a "data" folder in the repository root
3. Download the transactions you'd like categorised, and move the file into your data folder named as 'transactions.csv'
4. Create your cateogry file with a 'searchValue' column as the first column and save as a csv in the data directory as 'transaction-categories.csv'
4. Open the budget-manager.R script in your R IDE of choice
5. Run, and enjoy the newly categorised data! 

## Things to think about

You'll need to review and tune your categorisation inputs as the file takes the 'best' match. I have a soft distance threshold of 0.4 - anything over that has proven to be a poor selection in the model I use for category searching. 

I may introduce a more direct threshold value and default everything over that set value to "uncategorised" to allow you to tune more effectively.
