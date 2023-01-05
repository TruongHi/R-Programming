library(dplyr)
library(tidyr)
library(stringr)

PATH <- 'D:/R/Project 9 Coffee Shops/coffee.csv'               
df <- read.csv(PATH, header =  TRUE)

# Data Exploratory 
View(head(df))
summary(df)
str(df)
df$Place.type = as.factor(df$Place.type)
Place_type = table(df$Place.type)
Place_name = table(df$Place.name)
Region = table(df$Region)
length(unique(df$Place.name))
cbind(
  lapply(df,class))

# Check missing values using apply
list_na_values = apply(df,2,is.na) # create a list contains NA values
cbind(apply(list_na_values, 2,sum))

# Check missing values using lapply
list_na_values = lapply(df, is.na)
cbind(lapply(list_na_values, sum))

# Or we can use one hot code like this:
cbind(lapply(lapply(df, is.na), sum))

# Drop missing valuesv
df = na.omit(df)

# Value_counts, count unique values 
table(df$Dine.in.option)
table(df$Takeout.option)
table(df$Delivery.option)

# Convert class of columns from chr to logical class.
df$Dine.in.option = as.logical(df$Dine.in.option)
df$Delivery.option = as.logical(df$Delivery.option)
df$Takeout.option = as.logical(df$Takeout.option)

# Replace missing observations with the a specific string
df$Dine.in.option <- replace(df$Dine.in.option, is.na(df$Dine.in.option), 'FALSE')
df$Takeout.option <- replace(df$Takeout.option, is.na(df$Takeout.option), 'FALSE')

# Export to CSV
write.csv(df,'D:/R/Project 9 Coffee Shops/coffee_cleaned.csv')

# Export to Excel
library("writexl")
writexl::write_xlsx(df,'D:/R/Project 9 Coffee Shops/coffee_cleaned.xlsx')

# Import and read Excel file as .xlsx
install.packages("readxl")
library("readxl")
df_02 <- read_excel('D:/R/Project 9 Coffee Shops/coffee_cleaned.xlsx')
View(head(df_02))
