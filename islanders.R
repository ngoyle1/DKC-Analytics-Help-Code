##This will be the Analysis for New York Islanders##

##Preparation
remove(list=ls())
options(stringsAsFactors = FALSE)
library(twitteR)
library(dplyr)
library(ggplot2)
library(httr)
library(jsonlite)

setup_twitter_oauth("R9R5ic0jM3UjHs38PXIArUG1y", "xRYZ8em8ScFD5CCi9kOkomGbhPxPysNH4f4Z2nvO449XNvC7mg")


##The first thing would be to get the most recent tweets from the Islanders Account##
islanders <- getUser("NYIslanders")

islanders_tl <- userTimeline(islanders$id, n = 3200, includeRts = FALSE)
islanders_df <- twListToDF(islanders_tl)

#Cleaning strange characters##
#Original copy so getting the hashtag is easier#
copy <- islanders_df
islanders_df$text <- gsub("[^0-9A-Za-z///' ]", "", islanders_df$text)

##Let's check everyone that retweeted##
#First, let's get the tweets that returned less than 100, so we don't force the API#
options(scipen = 999)

myapp <- oauth_app("Cyranka",key = "R9R5ic0jM3UjHs38PXIArUG1y",
                   secret = "xRYZ8em8ScFD5CCi9kOkomGbhPxPysNH4f4Z2nvO449XNvC7mg")
sig <- sign_oauth1.0(myapp, token = "122462547-qPHZWrRIZZjk7bp7QccEXpFUL7PJpFEwjx0BG64k",
                     token_secret = "U7rDuZd540WSdGpltXZHrgzgxrBTFWg9S9fI9hN32rdrL")


less_than_100 <- subset(islanders_df, islanders_df$retweetCount <= 100)
retweeters_id <- NULL
set.seed(123)
l100_tweets_id <- sample(less_than_100$id, size = 10)


###Getting ids of everyone that retweeted a random sample of tweets - retweeted less than 100 times ##

for(i in 1:10){
    retweeters <- GET(paste("https://api.twitter.com/1.1/statuses/retweeters/ids.json?id=",l100_tweets_id[i],"&count=100&stringify_ids=true", sep = ""),sig)
    json1 <- content(retweeters)
    json2 <- jsonlite::fromJSON(toJSON(json1))
    retweeters_id <- append(retweeters_id,json2$ids)    
}
remove(i)


##Now, let's check these retweeters, get info on them##

##Will try to do this stuff in Python, stopping here##
set.seed(123)
sampling_users <- as.data.frame(sample(x = retweeters_id, size = 160))
colnames(sampling_users) <- "column"

filecon <- file("users_id.txt")
writeLines(as.character(sampling_users$column),filecon)
close(filecon)

##Getting personal information was done in Python##

#Now, I would like to extract the hashtags from the data_frame#
#Doing it in the copied dataframe, to make stuff easier#

list_of_tweets <- as.character(copy$text)
my_hashtags <- NULL


for(i in 1:length(list_of_tweets)){
    my_hashtags[i] <- substr(x = list_of_tweets[i],gregexpr("#\\S*",text = list_of_tweets[i])[[1]][1],
                          gregexpr("#\\S*",text = list_of_tweets[i])[[1]][1] + attr(regexpr("#\\S*",list_of_tweets[i]),"match.length"))
}
remove(i)

##Now I will try to grab 50,000 followers from the Islanders account##
options(scipen = 999)

#Passing a function to do it
##This function will try to automatize obtainining followers##
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

##First, I need to obtain the next_cursor from the first page##
#The following codes does that
first_followers <-get_account_followers("NYIslanders","-1")
    

#Now I need to append to this data frame. Each cursor burns a request
#You can restart from where you stopped because, the next cursor will be where it left off##
the_next_cursor <- unique(first_followers$next_cursor_str)

while(the_next_cursor != 0){
    to_append <- get_account_followers("NYIslanders", the_next_cursor)
    first_followers <- as.data.frame(rbind(first_followers,to_append))
    the_next_cursor <- unique(to_append$next_cursor_str)
}
remove(to_append)

##To get screen names, I will use mechanize in python, but I will write the 
##file first, I will take a sample of 500 names
set.seed(123)
list_to_mechanize <- as.data.frame(sample(first_followers$ids,500))
colnames(list_to_mechanize) <- "column"

new_filecon <- file("list_to_mechanize.txt")
writeLines(as.character(list_to_mechanize$column),new_filecon)
close(new_filecon)

    
    


