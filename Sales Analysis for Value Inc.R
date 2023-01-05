
library(tidyr)
library(stringr)  
library(dplyr)

# Import CSV to R
PATH <- 'D:/R/Project 1 Sales Analysis for Value Inc/transaction.csv'               
df <- read.csv(PATH, header =  TRUE, sep =';')

View(head(df))

# Check missing values
cbind(
  lapply(
    lapply(df, is.na)
    , sum)
)

# Check duplicates
sum(duplicated(df))

# Remove duplicates in dataset. 
df = df %>% distinct()

# Split strings into different columns
df = df %>% separate(ClientKeywords, c('ClientAge','Clienttype','LenghtofContract'),sep=',')

# Remove Special Characters using select 
ClientKeyWords = data.frame(lapply(select(df,c('ClientAge','Clienttype','LenghtofContract')),
                                   function(x)
{gsub('[^[:alnum:] ]',"",x)}))
------------------------------------OR------------------------------------
# Remove Special Characters without using select 
ClientKeyWords = data.frame(lapply(df[c('ClientAge','Clienttype','LenghtofContract')],
                                   function(x)
                                   {gsub('[^[:alnum:] ]',"",x)}))
# Remove Special Characters by creating a list 
ClientKeyWords = lapply(df[c('ClientAge','Clienttype','LenghtofContract')],
                                   function(x)
                                   {gsub('[^[:alnum:] ]',"",x)})

class(ClientKeyWords)

# Remove and Bind new columns (DATAFRAME, VECTOR, MATRICES ONLY) using subset and cbind
df = subset(df, select = -c(ClientAge,Clienttype,LenghtofContract))
df = cbind(df, ClientKeyWords)

# Remove old columns and replace new columns using mutate(), append list into dataframe.
df = df %>% mutate(ClientAge = ClientKeyWords$ClientAge,
                   Clienttype = ClientKeyWords$Clienttype,
                   LenghtofContract = ClientKeyWords$LenghtofContract)

#replace "Old Value" with "New Value" in the conference column
transaction_clean$ClientAge <- str_replace(transaction_clean$ClientAge, "SENIOR", "Senior")

# check data info 
str(df)
summary(df)

# Creating new column by performing calculation between columns.
# Remember to check class()/typeof() data.
# Cost Per Transaction
df$CostPerTransaction <- 
  as.numeric(df$NumberOfItemsPurchased) * 
  as.numeric(df$CostPerItem)

# Profit Per Item
df = df %>% 
  mutate(ProfitPerItem = as.numeric(SellingPricePerItem) - as.numeric(CostPerItem))

# Profit Per Transaction
df$ProfitPerTransaction <- 
  as.numeric(df$NumberOfItemsPurchased) * 
  as.numeric(df$ProfitPerItem)

# Sales Per Transaction
df$SalesPerTransaction = 
  as.numeric(df$NumberOfItemsPurchased)*
  as.numeric(df$SellingPricePerItem)
  
# Markup
df$Markup = 
  (as.numeric(df$SalesPerTransaction)-
  as.numeric(df$CostPerTransaction)) / as.numeric(df$CostPerTransaction)

# Round values to 1 decimal place
df$Markup = round(df$Markup, digits = 2)

# Unite() function concates multiple columns into one
df = df %>% unite(Date, Year, Month, Day, sep = "-")
df = df %>% unite(Date, Date, Time, sep = " ")

# Extract string in a dataframe
df$Month = substr(df$Date,6,8)

# ONE HOT CODE USING MUTATE():
df = df %>% mutate(CostPerTransaction = NumberOfItemsPurchased * CostPerItem,
                   ProfitPerItem = SellingPricePerItem - CostPerItem,
                   SalesPerTransaction = NumberOfItemsPurchased * SellingPricePerItem,
                   ProfitPerTransaction = SalesPerTransaction - CostPerTransaction,
                   Markup = ProfitPerTransaction / CostPerTransaction,
                   Markup = round(Markup, digits = 2)) %>% 
  unite(Date, Year, Month, Day, sep = "-") %>% 
  unite(Date, Date, Time, sep = " ") %>% 
  mutate(Month = substr(Date,6,8))
  
# Merge data
PATH_2 <- 'D:/R/Project 1 Sales Analysis for Value Inc/Value_inc_seasons.csv'               
seasons <- read.csv(PATH_2, header =  TRUE, sep = ';')

df <- merge(df, seasons, by.x = "Month")

# Check dimension of data
dim(df)

# Export to CSV     
write.csv(df, "D:/R/Project 1 Sales Analysis for Value Inc/ValueInc_cleaned.csv")




