

# Import CSV to R
PATH_1 = 'https://raw.githubusercontent.com/dhminh1024/practice_datasets/master/titanic.csv'               
PATH_2 = 'https://raw.githubusercontent.com/guru99-edu/R-Programming/master/test.csv'
df <- read.csv(PATH_2, header =  TRUE)


# A description of observation of what data is about
View(head(df))
summary(df)
sapply(df,class)
class(df)
df$Survived = as.factor(df$Survived)
df$Sex = as.factor(df$Sex)
df$AgeRange = as.factor(df$AgeRange)
df$FamilySize = as.factor(df$FamilySize)                        
df$Survival_Status = as.factor(df$Survival_Status) 

# Check Class of columns in data frame
cbind(
  lapply(df,class))

# Prepare data
# Check missing values
sum(is.na(df))
sum(is.na(df_replace))
sum(is.na(df$Age))
sum(is.na(df_replace$replace_mean_age))
------OR-------
# Check missing values
list_na_values = lapply(df, is.na) # create a list contains NA values
cbind(lapply(list_na_values, sum))
# Or we can use one hot code like this:
cbind(lapply(lapply(df, is.na), sum))

# Return the column names containing missing observations
list_na_columns = colnames(df)[apply(df, 2, anyNA)]

# Drop missing values
df_droped_na = na.omit(df)

# Impute Missing data with the Mean 
average_missing = apply(df[,colnames(df) %in% list_na_columns], 2, mean, na.rm =  TRUE)
                  ------------OR-------------
  # apply() function must be applied to a data frame or matrix,
  # apply it to a specific column in the data frame will occur ERROR
  # c() function in R Language is used to combine the arguments into a Vector
average_missing = apply(df[c('Age','Fare')],2, mean, na.rm = TRUE)
  # using lapply()
average_missing = lapply(df[c('Age','Fare')], mean, na.rm = TRUE)
  # using sapply()
average_missing = sapply(df[c('Age','Fare')], mean, na.rm = TRUE)

# Impute Missing data with the Median
median_missing = apply(df[,colnames(df) %in% list_na], 2, median, na.rm =  TRUE)
------------OR-------------
  # apply() function must be applied to a data frame or matrix,
  # apply it to a specific column in the data frame will occur ERROR
  # c() function in R Language is used to combine the arguments into a Vector
median_missing = apply(df[c('Age','Fare')], 2, median, na.rm = TRUE)
  # using lapply()
median_missing = lapply(df[c('Age','Fare')], median, na.rm = TRUE)
  # using sapply()
median_missing = sapply(df[c('Age','Fare')], median, na.rm = TRUE)

# Replace missing observations with the mean value
library(dplyr)
df_replace = df %>% mutate(replace_mean_age = ifelse(is.na(Age), average_missing[1], Age),
                           replace_mean_fare = ifelse(is.na(Fare),average_missing[2], Fare))

# Replace missing observations with the mean value
df_replace = df %>% mutate(replace_median_age = ifelse(is.na(Age), median_missing[1], Age),
                           replace_median_age = ifesle(is.na(Fare), median_missing[2], Fare))

# Check Age Function 
  # Multiple If else condition of a dataframe column in R:
df$AgeRange = ifelse(df$Age < 1,'Infants',
                     ifelse(df$Age < 10,'Children',
                            ifelse(df$Age < 18,'Teens',
                                   ifelse(df$Age < 40,'Adults',
                                          ifelse(df$Age < 60,'Middle Age',
                                                 ifelse(df$Age >= 60,'Elders',''))))))

# Survival Status
df$Survival_Status = ifelse(df$Survived == 0,'Dead','Alive')

# Family Size
df$FamilySize = df$SibSp + df$Parch

# Reference:
Reference_path = 'https://medium.com/swlh/basic-exploratory-data-analysis-of-titanic-data-using-r-53d4b764ec89'

# Export to CSV
write.csv(df,'D:/R/Project 4 Titanic Analysis/Titanic_cleaned.csv')

# Export to Excel File
install.packages("readxl")
library("readxl")
install.packages("writexl")
library("writexl")
writexl::write_xlsx(df,'D:/R/Project 4 Titanic Analysis/Titanic_cleaned.xlsx')







