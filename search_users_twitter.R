search_users_twitter <- function(my_screen_name){
  get_the_json <- GET(paste("https://api.twitter.com/1.1/users/search.json?q=",
                            as.character(my_screen_name), sep =""), sig)
  json1 <- content(get_the_json)
  json2 <- jsonlite::fromJSON(toJSON(json1))
  return(as.data.frame(json2))
}

unlist_stuff <- function(kk){
  v <- kk
  names <- v$name
  user_names <- v$screen_name
  description <- v$description
  vv <- as.data.frame(cbind(names, user_names,description))
  return(vv)
}

# lol <- read_excel("/Users/harrocyranka/Desktop/Forbes pitch list.xlsx", sheet = 1)
# lol <- filter(lol, twitter == "0")
# colnames(lol) <- c("id","outlet","first", "last", "contact", "topic","email", "phone","twitter")
# 
# search_terms <- tolower(paste(lol$first,lol$last, sep = "%20"))
# 
# new_frame <- list()
# 
# for(i in 1:length(search_terms)){
#   k_1 <- try(search_users_twitter(search_terms[i]))
#   l_1 <-  try(unlist_stuff(k_1))
#   new_frame[[i]] <- l_1
# }
# remove(i, l_1, k_1)
# 
# v_1 <- do.call("rbind", new_frame)
# 
# #write.xlsx(v_1, "retrieved_handles.xlsx", row.names = FALSE)