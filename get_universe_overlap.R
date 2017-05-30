##This is the first function to use
options(stringsAsFactors = FALSE)
options(scipen = 999)



reorganize <- function(my_vector, string_1,string_2){
  new_vector <- NULL
  for(i in 1:length(my_vector)){
    first <- strsplit(my_vector[i],",")
    second <- sort(trim(unlist(first)))
    third <- subset(second, second!=string_1)
    fourth <- subset(third, third!=string_2)
    fifth <- paste(fourth, collapse = ", ")
    new_vector[i] <- fifth
  }
  return(new_vector)
}

options(scipen = 999)
options(stringsAsFactors = FALSE)
library(readxl)

#a <- read.csv("islanders_tri_state_export.csv")

# #test <- a$tag_list[1:20]
# 
# #null_list <- data.frame()
# 
# for(i in 1:20){
#     f <- unlist(strsplit(test[i],","))
#     g <- sort(paste(f,collapse = ""))
#     null_list <- as.data.frame(rbind(g,null_list))
# }
# 
# z <- tbl_df(null_list)
# colnames(z) <- "variable"
# z_gb <- group_by(z,variable)
# sum <- summarise(z_gb, n = n())
