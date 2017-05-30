new_ajungo_fix <- function(excel_file){
    library(readxl)
    options(stringsAsFactors = FALSE)
    my_file <- read_excel(excel_file, sheet = 1)
    categories <- unlist(c(my_file[3,]))
    k <- unlist(which(is.na(categories) == TRUE))
    categories[k] <- subset(unlist(my_file[15,]), is.na(unlist(my_file[15,])) == FALSE)
    categories <-  gsub("/", "", categories)
    categories <- gsub("  "," ", categories)
    f <- my_file[complete.cases(my_file),]
    
    empty_vector <- NULL
    
    odd_columns <- seq(1,ncol(f),2)
    even_numbers <-seq(2,ncol(f),2)
    
    for(i in odd_columns){
        vector <- as.vector(t(f[,i]))
        empty_vector <- append(empty_vector, vector)
    }
    
    numbers <- NULL
    for(i in even_numbers){
        vector_1 <- as.vector(t(f[,i]))
        numbers <- append(numbers, vector_1)
    }
    
    g <- as.data.frame(cbind(empty_vector,numbers))
    g$numbers <- as.numeric(round(as.numeric(g$numbers), digits = 4))
    g$category <- rep(tolower(categories), each = 10)
    return(unique(g))
    
    
}