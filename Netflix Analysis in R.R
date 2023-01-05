library(dplyr)
library(tidyr)
library(stringr)
library(plyr)

PATH <- 'D:/R/Project 12 Netflix Analysis/netflix_titles.csv'               
df <- read.csv(PATH, header =  TRUE)

View(head(df))
str(df)
dim(df)
summary(df)

# Remove duplicates in dataset. 
df = df %>% distinct()

# Check Class of columns in data frame
cbind(
  lapply(df,class))

# Check NA values
cbind(lapply(lapply(df, is.na), sum))

# Replace empty String with NA values
df[df == ''] = NA

# Replace NA values with MODE values
# Create the function because R does not have mode function
getmode = function(v) {
  uniqv = unique(v)
  uniqv[which.max(tabulate(match(v,uniqv)))]
}
# Now we have mode value
mode_values = getmode(df$rating)
mode_values

# Replace missing values with mode value using replace
df$rating = 
  replace(df$rating,
          is.na(df$rating),
          mode_values)

# Replace missing values with 0 using ifelse
df = 
  df %>% mutate(duration =
                  ifelse(is.na(duration), 0,duration))

# Select Rows which is Movie type              
Movie_df = df[df$type == 'Movie', ]
View(head(Movie_df))

# Creating column
Movie_df$minute = str_extract(Movie_df$duration,'\\d+')
Movie_df$minute = as.numeric(Movie_df$minute)

# Remove column in Dataframe
df = subset(df, select = -c(minute))

# Check NA values
cbind(lapply(lapply(Movie_df, is.na), sum))

# Check if rating has strange values,
# We have 66 min, 74 min, 84 min which is not rating type
table(Movie_df$rating)
rating = str_extract(Movie_df$rating,'\\d+\\s(min)')
wrong_values_rating = unique(rating)
wrong_values_rating = wrong_values_rating[2:4]

# Remove rows which contains wrong values of rating
Movie_df= subset(Movie_df, !(rating %in% wrong_values_rating))
View(head(Movie_df))
unique(Movie_df$rating)

# Remove Movie type data rows 
df = df[df$type != 'Movie', ]
dim(df)

# Final dataframe for later analysis
Movie_df = Movie_df[Movie_df$minute > 43 & Movie_df$minute < 158, ]

# Using rbind() to concate Movie_df and df
install.packages('plyr')
library(plyr)
df = rbind.fill(Movie_df,df)

# Export to CSV     
write.csv(df, "D:/R/Project 12 Netflix Analysis/df_netflix.csv")

