estimate_audience <- function(handles){  
  df_empty <- list()
  
  for(i in 1:length(handles)){
    first <- try(get_first_followers(handles[[i]],"-1"))
    df_empty[[i]] <- try(first)
  }
  remove(i, first)
  ##
  
  ##Lists with API Pulls##
  api_pulls <- list()
  for(i in 1:length(df_empty)){
    api_pulls[[i]] <- get_users_api_direct(df_empty[[i]],0)
  }
  remove(i)
  ##
  
  
  for(i in 1:length(api_pulls)){
    api_pulls[[i]]$follow_numbers <- follower_numbers_1(api_pulls[[i]]$followersCount)
  }
  
  ##Grouped By
  total_users <- NULL
  for(i in 1:length(handles)){
    first <- getUser(handles[i])
    total_users[i] <- first$getFollowersCount()
    
  }
  remove(i, first)
  
  
  summarized_df <- list()
  for(i in 1:length(api_pulls)){
    r_1 <- tbl_df(api_pulls[[i]])
    r_2 <- group_by(r_1, by = follow_numbers)
    r_3 <- as.data.frame(dplyr::summarise(r_2, categories = n()))
    summarized_df[[i]] <- r_3
    colnames(summarized_df[[i]]) <- c("Type", "Frequency")
    summarized_df[[i]] <- arrange(summarized_df[[i]], desc(Frequency))
    summarized_df[[i]]$percent <- summarized_df[[i]]$Frequency/sum(summarized_df[[i]]$Frequency)
    summarized_df[[i]]$estimate <- round(summarized_df[[i]]$percent*total_users[i],0)
    summarized_df[[i]]$account <- handles[i]
  }
  
  summarized_df[[1]]
  remove(r_1,r_2,r_3,i)
  
  estimates <- do.call("rbind", summarized_df)
  estimates_2 <- select(estimates,account, Type, estimate)
  
  library(reshape2)
  
  v <- dcast(estimates_2, account ~Type)
  colnames(v)
  
  v_1 <- v[,c(1,4,3,2)]
  
  v_1 <- arrange(v_1, desc(`Ordinary User`))
  return(v_1)
}

estimate_audience_2 <- function(handles){  
  df_empty <- list()
  
  for(i in 1:length(handles)){
    first <- try(get_first_followers(handles[[i]],"-1"))
    df_empty[[i]] <- try(first)
  }
  remove(i, first)
  ##
  
  ##Lists with API Pulls##
  api_pulls <- list()
  for(i in 1:length(df_empty)){
    api_pulls[[i]] <- get_users_api_direct(df_empty[[i]],0)
  }
  remove(i)
  ##
  
  
  for(i in 1:length(api_pulls)){
    api_pulls[[i]]$follow_numbers <- follower_numbers_2(api_pulls[[i]]$followersCount)
  }
  
  ##Grouped By
  total_users <- NULL
  for(i in 1:length(handles)){
    first <- getUser(handles[i])
    total_users[i] <- first$getFollowersCount()
    
  }
  remove(i, first)
  
  
  summarized_df <- list()
  for(i in 1:length(api_pulls)){
    r_1 <- tbl_df(api_pulls[[i]])
    r_2 <- group_by(r_1, by = follow_numbers)
    r_3 <- as.data.frame(dplyr::summarise(r_2, categories = n()))
    summarized_df[[i]] <- r_3
    colnames(summarized_df[[i]]) <- c("Type", "Frequency")
    summarized_df[[i]] <- arrange(summarized_df[[i]], desc(Frequency))
    summarized_df[[i]]$percent <- summarized_df[[i]]$Frequency/sum(summarized_df[[i]]$Frequency)
    summarized_df[[i]]$estimate <- round(summarized_df[[i]]$percent*total_users[i],0)
    summarized_df[[i]]$account <- handles[i]
  }
  
  summarized_df[[1]]
  remove(r_1,r_2,r_3,i)
  
  estimates <- do.call("rbind", summarized_df)
  estimates_2 <- select(estimates,account, Type, estimate)
  
  library(reshape2)
  
  v <- dcast(estimates_2, account ~Type)
  colnames(v)
  return(v)
}