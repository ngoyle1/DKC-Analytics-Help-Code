
print("###....Loading Packages script running...###")
suppressMessages(suppressWarnings(library(sqldf)))
print("Loaded SQLDF")
suppressMessages(library(xlsx))
print("Loaded xlsx")

suppressMessages(library(ggplot2))
print("Loaded ggplot2")

suppressMessages(library(plyr))
print("Loaded Plyr")
suppressMessages(library(dplyr))
print("Loaded Dplyr")


print("####Loading user created functions ###")
source("/Users/harrocyranka/Desktop/code/get_county_name_filter.R")
source("/Users/harrocyranka/Desktop/code/name_fixer_na_counts.R")
source("/Users/harrocyranka/Desktop/code/get_universe_overlap.R")
source("/Users/harrocyranka/Desktop/code/my_coalesce.R")
source("/Users/harrocyranka/Desktop/code/my_coalesce_2.Rd")

print("Loading packages script off")

extract_regex <- function(vector, reg_exp){
  my_hashtags <- NULL
  list_of_tweets <- vector
  
  for(i in 1:length(list_of_tweets)){
    my_hashtags[i] <- substr(x = list_of_tweets[i],gregexpr(reg_exp,text = list_of_tweets[i])[[1]][1],
                             gregexpr(reg_exp,text = list_of_tweets[i])[[1]][1] + attr(regexpr(reg_exp,list_of_tweets[i]),"match.length"))
    print(i)
  }
  return(my_hashtags)
}

'%ni%' <- Negate('%in%')

sum_tags <- function(target_tag, my_vector,my_df){
	v <- grep(target_tag, my_vector, value = FALSE)
	my_sum <- sum(my_df[v,]$Freq)
	return(my_sum)
}

colnames_insta <- function(data_frame){
	x <- data_frame
	colnames(x) <- colnames(x) <- c("id", "username","full_name","profile_picture","description","website",
                 "n_posts","following","followers", "date_of_last_post", "avg_number_of_likes_last_30_posts",
                 "last_post_latitude","last_post_longitude","last_post_location")
	return(x)
}

assign_quintiles <- function(x){
  f <- x
  f <- cut(f, breaks = quantile(f, probs = seq(0, 1, 0.2)), 
                     include.lowest = TRUE, labels = 1:5)
  return(f)
}

assign_deciles <- function(x){
  f <- x
  f <- cut(f, breaks = quantile(f, probs = seq(0, 1, 0.1)), 
           include.lowest = TRUE, labels = 1:10)
  return(f)
}

assign_percentiles <- function(x){
  f <- x
  f <- cut(f, breaks = quantile(f, probs = seq(0, 1, 0.01)), 
           include.lowest = TRUE, labels = 1:100)
  return(f)
}

reverse_percentiles <- function(x){
  f <- x
  f <- cut(f, breaks = unique(quantile(f, probs = seq(0, 1, 0.01))), 
           include.lowest = TRUE, labels = 100:1)
  return(f)
}


standardize <- function(my_list){
  numerator <- (my_list - mean(my_list))
  denominator <- sd(my_list)
  last <- numerator/denominator
  last <- round(last, 3)
  return(last)
}