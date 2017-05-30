##This Script Should Automate Twitter Analysis of the Data, However Make Sure to Grab the Twitter Authorization First#
options(stringsAsFactors = FALSE)
options(scipen = 999)
library(twitteR)
library(dplyr)
library(httr)
library(jsonlite)

setup_twitter_oauth("R9R5ic0jM3UjHs38PXIArUG1y", "xRYZ8em8ScFD5CCi9kOkomGbhPxPysNH4f4Z2nvO449XNvC7mg")


options(scipen = 999)

myapp <- oauth_app("Cyranka",key = "R9R5ic0jM3UjHs38PXIArUG1y",
                   secret = "xRYZ8em8ScFD5CCi9kOkomGbhPxPysNH4f4Z2nvO449XNvC7mg")
sig <- sign_oauth1.0(myapp, token = "122462547-qPHZWrRIZZjk7bp7QccEXpFUL7PJpFEwjx0BG64k",
                     token_secret = "U7rDuZd540WSdGpltXZHrgzgxrBTFWg9S9fI9hN32rdrL")





twitter_analysis <- function(nb_data_frame, api_data_frame, dir_to_create){
  options(stringsAsFactors = FALSE)
  options(scipen = 999)
  suppressMessages(library(xlsx))
  suppressMessages(library(dplyr))
  suppressMessages(library(readxl))
  suppressMessages(library(sqldf))
  suppressMessages(library(tm))
  source("/Users/harrocyranka/Desktop/code/get_county_name_filter.R")
  source("/Users/harrocyranka/Desktop/code/name_fixer_na_counts.R")
  source("/Users/harrocyranka/Desktop/code/get_universe_overlap.R")
  source("/Users/harrocyranka/Desktop/code/my_coalesce.R")
  source("/Users/harrocyranka/Desktop/code/my_coalesce_2.Rd")
  source("/Users/harrocyranka/Desktop/code/get_unigram_bigrams.R")
  
  
  my_coalesce <- function(list,term){
    new_list <- ifelse(list == ""|is.na(list) == TRUE,term,list)
    return(new_list)
  }
  
  ##Bringing the two datasets##
  list_of_regions <- read_excel("/Users/harrocyranka/Desktop/code/list_of_regions.xlsx", sheet = 3)
  
  z <- read.csv(api_data_frame, header = TRUE)
  y <- read.csv(nb_data_frame, header = TRUE)
  m <- get_counts_as_df(y$tag_list)
  
  x <- sqldf("SELECT z.id,z.screenName,z.followersCount,z.statusesCount,
             y.primary_country,y.primary_state,z.created,y.first_name
             FROM y JOIN z ON z.screenName = y.twitter_login")
  ##Start Analysis
  x$follower_level_1 <- follower_numbers_1(x$followersCount)
  x$follower_level_2 <- follower_numbers_2(x$followersCount)
  
  broad_categories <- get_counts_as_df(x$follower_level_1)
  
  granular <- get_counts_as_df(x$follower_level_2)
  
  total_penetration <- sqldf("SELECT follower_level_1, SUM(followersCount) FROM x
                             GROUP BY 1
                             ORDER BY 2 DESC")
  # Platform Engagement
  x$now <- Sys.Date()
  x$created <- gsub("(\\s).+","",x$created)
  x$created <- my_coalesce(x$created, as.character(Sys.Date()))
  #x$created <- as.Date(x$created, "%m/%d/%y")
  x$number_of_days <-as.numeric(as.character(x$now - as.Date(x$created)))
  x$stat_day <- x$statusesCount/x$number_of_days
  x$stat_day <- round(ifelse(x$stat_day == Inf, 0, x$stat_day),2)
  x$age <- (x$number_of_days)/365
  x$engagement <- ifelse(x$stat_day >5, "Heavy User", ifelse(x$stat_day > 1 & x$stat_day <= 5, "Medium User","Low User"))
  
  
  engagement <- get_counts_as_df(x$engagement)
  
  ##Geo Location##
  k <- subset(x, x$primary_country == "United States" | x$primary_state %in% list_of_regions$Abbreviation)
  states_locations <- get_regions(get_counts_as_df(k$primary_state))
  ##Don't forget to include Gender Once you are at DKC
  
  ##Get Gender##
  for_gender <- select(x, id, first_name)
  
  for_gender$first_name <- name_fixer(for_gender$first_name)
  for_gender <- subset(for_gender, for_gender$first_name!="")
  
  
  gender <- gender_names(for_gender$first_name)
  gender_counts <- get_counts_as_df(gender$gender)
  
  ##Get who they follow##
  p <- read.csv(nb_data_frame, header = TRUE)
  p$tag_list <- reorganize(p$tag_list, string_1="", string_2 = "")
  #p <- subset(p, p$primary_country == "United States" | p$primary_state %in% list_of_regions$Abbreviation)
  #m <- get_counts_as_df(x$tag_list)
  #u_gram <- get_unigram(api_data_frame, "unigrams.csv")
  
  #get_bigram(api_data_frame, "bigrams.csv")
  
  #Writing the Files
  #Follower Levels#
  dir.create(dir_to_create)
  
  file.copy(paste(getwd(),"/",api_data_frame, sep = ""), paste(dir_to_create,"/",api_data_frame,sep = ""))
  setwd(dir_to_create)
  
  write.xlsx(states_locations, "geo_location.xlsx", row.names = FALSE)
  write.xlsx(broad_categories, "follower_levels.xlsx", sheetName = "broad_categories", append = FALSE, row.names = FALSE)
  write.xlsx(granular, "follower_levels.xlsx", sheetName = "granular_categories", append = TRUE, row.names = FALSE)
  write.xlsx(total_penetration, "follower_levels.xlsx", sheetName = "penetration", append = TRUE, row.names=FALSE)
  write.xlsx(m,"follower_levels.xlsx", sheetName = "who_they_follow", append = TRUE, row.names = FALSE)
  write.xlsx(engagement, "engagement.xlsx", sheetName = "engagement", append = TRUE, row.names = FALSE)
  write.xlsx(gender_counts,"gender_counts.xlsx", row.names = FALSE)
  #get_unigram(api_data_frame, "unigrams.csv")
  #get_bigram(api_data_frame, "bigrams.csv")
 }



#This is function is to automate api information
api_get <- function(nb_file,file_to_write, more_than_6 = FALSE){
  x <- read.csv(nb_file, header = TRUE)
  twitter_ids <- x$twitter_id
  
  ##Get Users Lookup##
  f <- split(twitter_ids, ceiling(seq_along(twitter_ids)/100))
  
  
  ##Request Attempt##
  appended <- data.frame()
  users <- list()
  if(more_than_6 == FALSE){
    for(i in 1:length(f)){
      users[[i]] <- lookupUsers(f[[i]])
      new_df <- do.call("rbind", lapply(users[[i]], as.data.frame))
      appended <- as.data.frame(rbind(appended,new_df))
      print(i)
      # update GUI console
      flush.console()  
    }
  }else{
    for(i in 1:length(f)){
      users[[i]] <- lookupUsers(f[[i]])
      new_df <- do.call("rbind", lapply(users[[i]], as.data.frame))
      appended <- as.data.frame(rbind(appended,new_df))
      print(i)
      print("Using more than 6 seconds")
      # update GUI console
      Sys.sleep(6)
      flush.console()  
    }
    row.names(appended) <- c(1:nrow(appended))
  }
  write.csv(appended,file_to_write, row.names = FALSE)
}



get_first_followers <- function(my_screen_name, my_cursor){
  get_the_json <- GET(paste("https://api.twitter.com/1.1/followers/ids.json?screen_name=",
                            as.character(my_screen_name),"&cursor=",as.character(my_cursor), sep =""), sig)
  json1 <- content(get_the_json)
  json2 <- jsonlite::fromJSON(toJSON(json1))
  return(as.data.frame(json2))
 
}



get_users_api_direct <- function(data_frame, define_wait_time){
    f <- split(data_frame$ids, ceiling(seq_along(data_frame$ids)/100))
    
    ##Request Attempt##
    appended <- data.frame()
    users <- list()
    for(i in 1:length(f)){
        users[[i]] <- lookupUsers(f[[i]])
        new_df <- do.call("rbind", lapply(users[[i]], as.data.frame))
        appended <- as.data.frame(rbind(appended,new_df))
        Sys.sleep(define_wait_time)
        print(i)
        # update GUI console
        flush.console()  
    }
    print("Now Wrapping the List in a Data Frame")
    empty_frame <- data.frame()
    
    for(i in 1:length(users)){
        first <- twListToDF(users[[i]])
        empty_frame <- as.data.frame(rbind(empty_frame,first))
    }
    
    row.names(empty_frame) <- c(1:nrow(empty_frame))
    return(empty_frame)
}


get_ids <- function(enter_account){
    first_followers <- get_first_followers(enter_account,"-1")
    the_next_cursor <- unique(first_followers$next_cursor_str)
    while(the_next_cursor != 0){
        to_append <- get_first_followers(enter_account, the_next_cursor)
        first_followers <- as.data.frame(rbind(first_followers,to_append))
        the_next_cursor <- unique(to_append$next_cursor_str)
    }
    return(first_followers)
}