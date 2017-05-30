
##Change these
remove(list = ls())

input = readline("Enter the desired working directory: ")
setwd(input)
length(grep("Screen Shot",x = list.files(),value = TRUE))


##Function
move_file <- function(x,new_location){
    #setwd("/Users/harrocyranka/Desktop")
    desktop <- getwd()
    files <- grep(x,x = list.files(),value = TRUE)
    
    for(i in files){
    from_rename <- paste(desktop,"/",files, sep = "")
    
    where_to_put <- new_location
    
    to_rename <- paste(where_to_put,files, sep = "")
    file.rename(from_rename, to_rename)
    }
}

##Call the function
file_destination <- readline("Enter the destination: ")
move_file("Screen Shot", file_destination)