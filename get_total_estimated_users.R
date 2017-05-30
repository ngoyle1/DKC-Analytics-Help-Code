remove(list = ls())
options(stringsAsFactors = FALSE)
options(scipen = 999)

setwd("/Users/harrocyranka/Desktop/Research_and_Projects/pager/")
source("/Users/harrocyranka/Desktop/code/twitter_info_analysis_3.R")
source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")

x <- read_excel("pager_handles.xlsx", sheet = 1)
x <- x[,c(1:4)]
health <- subset(x, x$Space == "Health")

df_empty <- list()

for(i in 1:nrow(health)){
  first <- try(get_first_followers(x$handle[[i]],"-1"))
  df_empty[[i]] <- try(first)
}
remove(i, first)

###
for(i in 1:length(df_empty)){
  df_empty[[i]]$handle <- health$handle[[i]]
}
remove(i)

##Lists with API Pulls##
api_pulls <- list()
for(i in 1:length(df_empty)){
  api_pulls[[i]] <- get_users_api_direct(df_empty[[i]],0)
}
remove(i)

#save(api_pulls, file="api_pulls.RData")

for(i in 1:length(api_pulls)){
  api_pulls[[i]]$follow_numbers <- follower_numbers_1(api_pulls[[i]]$followersCount)
}



##Grouped By
total_users <- NULL
for(i in 1:nrow(health)){
  first <- getUser(x$handle[i])
  total_users[i] <- first$getFollowersCount()
  
}
remove(i, first)

summarized_df <- list()
for(i in 1:length(api_pulls)){
  r_1 <- tbl_df(api_pulls[[i]])
  r_2 <- group_by(r_1, by = follow_numbers)
  r_3 <- summarise(r_2, categories = count(follow_numbers))
  summarized_df[[i]] <- r_3$categories
  colnames(summarized_df[[i]]) <- c("Type", "Frequency")
  summarized_df[[i]] <- arrange(summarized_df[[i]], desc(Frequency))
  summarized_df[[i]]$percent <- summarized_df[[i]]$Frequency/sum(summarized_df[[i]]$Frequency)
  summarized_df[[i]]$estimate <- round(summarized_df[[i]]$percent*total_users[i],0)
  summarized_df[[i]]$account <- health$name[[i]]
}
save(summarized_df, file="estimated_following.RData")
summarized_df[[1]]
remove(r_1,r_2,r_3,i)

estimates <- do.call("rbind", summarized_df)

write.xlsx(estimates, "estimated_audience.xlsx", row.names = FALSE)