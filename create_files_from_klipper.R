##Airtime Functions##

remove(list = ls())
options(stringsAsFactors = FALSE)
options(scipen = 999)
source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")
library(jsonlite)
library(gtools)

create_scrape_file <- function(infile, define_wd, outfile){
    x <- read.csv(infile, header = TRUE)
    filter <- grep("taken-at", x$Link)
    x <- as.data.frame(x[filter,1])
    colnames(x) <- "link"
    file_name <- paste(define_wd,outfile,".xlsx",sep = "")
    write.xlsx(x,file_name, row.names = FALSE, append = FALSE)
    return(x)
}

school_top_posters <- function(folder_file,define_wd,outfile){
    setwd(folder_file)
    
    my_files <- mixedsort(list.files())
    
    
    list_of_frames <- list()
    vector_of_likes <- NULL
    vector_of_comments <- NULL
    vector_of_dates <- NULL
    vector_of_usernames <- NULL
    vector_of_names <- NULL
    y <- fromJSON(my_files[1])
    
    
    for(i in 1:length(my_files)){
        y <- fromJSON(my_files[i])
        k <- y$entry_data$PostPage$media
        list_of_frames[[i]] <- k
        vector_of_usernames <- append(vector_of_usernames,list_of_frames[[i]]$owner$username)
        vector_of_names <- append(vector_of_names,list_of_frames[[i]]$owner$full_name)
        vector_of_likes <- append(vector_of_likes,list_of_frames[[i]]$likes$count)
        vector_of_comments <- append(vector_of_comments,list_of_frames[[i]]$comments$count)
        fix_date <- as.character(as.POSIXct(list_of_frames[[i]]$date, origin="1970-01-01"))
        vector_of_dates <- append(vector_of_dates, fix_date)
    }
    
    
    data_frame <- as.data.frame(cbind(vector_of_names,vector_of_usernames,vector_of_dates, vector_of_likes, vector_of_comments))
    
    data_frame$vector_of_likes <- as.numeric(as.character(data_frame$vector_of_likes))
    data_frame$vector_of_comments <- as.numeric(as.character(data_frame$vector_of_comments))
    
    #View(data_frame)
    
    data_frame$vector_of_names <- my_coalesce(data_frame$vector_of_names, "Not Displayed")
    
    summed_df <- sqldf("SELECT vector_of_usernames,vector_of_names,SUM(vector_of_likes) as 'total_likes',
                       SUM(vector_of_comments) as 'total_comments'
                       FROM data_frame
                       GROUP BY 1
                       ORDER BY 3 DESC")
    file_name_1 <- paste(define_wd,outfile,"_top_posters",".xlsx",sep = "")
    file_name_2 <- paste(define_wd,outfile,"_all_posts",".xlsx",sep = "")
    write.xlsx(summed_df, file_name_1, row.names = FALSE)
    
    write.xlsx(data_frame,file_name_2, row.names = FALSE)
    setwd("..//")
}