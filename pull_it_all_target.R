remove(list = ls())
options(stringsAsFactors = FALSE)
options(scipen = 999)

source("/Users/harrocyranka/Desktop/code/twitter_info_analysis_3.R")

get_ids2 <- function(enter_account){
  first_followers <- get_first_followers(enter_account,"1545391382678740000")
  the_next_cursor <- unique(first_followers$next_cursor_str)
  while(the_next_cursor != 0){
    to_append <- get_first_followers(enter_account, the_next_cursor)
    Sys.sleep(65)
    first_followers <- as.data.frame(rbind(first_followers,to_append))
    the_next_cursor <- unique(to_append$next_cursor_str)
    write.csv(to_append, paste(the_next_cursor,".csv",sep = ""), sep = "")
    print(tail(first_followers,n = 5))
    print("")
    print(the_next_cursor)
  }
  return(first_followers)
}

x <- get_ids2(enter_account = "Target")

setwd("#ids_to_upload/")
d <- split(x,rep(1:1812564,each=95000))
