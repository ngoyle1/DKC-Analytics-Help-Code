remove(list = ls())
setwd("/Users/harrocyranka/Desktop/")

options(stringsAsFactors = FALSE)
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


get_account_followers <- function(my_screen_name, my_cursor){
  get_the_json <- GET(paste("https://api.twitter.com/1.1/followers/ids.json?screen_name=",
                            as.character(my_screen_name),"&cursor=",as.character(my_cursor), sep =""), sig)
  json1 <- content(get_the_json)
  json2 <- jsonlite::fromJSON(toJSON(json1))
  return(as.data.frame(json2))
}

##Get Ken Burns##
first_followers <- get_account_followers("KenBurns","-1")
the_next_cursor <- unique(first_followers$next_cursor_str)


while(the_next_cursor != 0){
  to_append <- get_account_followers("KenBurns", the_next_cursor)
  first_followers <- as.data.frame(rbind(first_followers,to_append))
  the_next_cursor <- unique(to_append$next_cursor_str)
}
remove(to_append)

##Get Users Lookup##
f <- split(first_followers$ids, ceiling(seq_along(first_followers$ids)/100))


##Request Attempt##
appended <- data.frame()
for(i in 1:15){
  users[[i]] <- lookupUsers(f[[i]])
  new_df <- do.call("rbind", lapply(users[[i]], as.data.frame))
  appended <- as.data.frame(rbind(appended,new_df))
}

users <- lookupUsers(f[[1]])
df <- do.call("rbind", lapply(users, as.data.frame))

appended$twitter_id <- rownames(appended)
