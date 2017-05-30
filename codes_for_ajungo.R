#f <- read_excel("jessica_alba_ajungo.xlsx", sheet = 1)
#g <- read_excel("honest_company_ajungo.xlsx", sheet = 1)
library(dplyr)

ajungo_overlap <- function(list_1, list_2, list_name_1, list_name_2){
    suppressMessages(library(dplyr))
    k <- merge(list_1,list_2, by = c("empty_vector","category"))
    colnames(k) <- c("name", "category",list_name_1,list_name_2)
    k <- arrange(k, k[,2], desc(k[,3]))
    row.names(k) <- c(1:nrow(k))
    return(k)
}

write_ajungo <- function(list_1,excel_file_name){
    library(xlsx)
    library(dplyr)
    list_1 <- arrange(list_1, category,numbers)
    vectors_with_categories <- unique(list_1$category)
    first_data_frame <- subset(list_1, list_1$category == vectors_with_categories[1])
    write.xlsx(first_data_frame,file = excel_file_name,
               sheetName = vectors_with_categories[1], row.names = FALSE)
    for(i in 2:length(vectors_with_categories)){
        write.xlsx(subset(list_1, list_1$category == vectors_with_categories[i]),
                   file = excel_file_name, sheetName = vectors_with_categories[i],
                   row.names = FALSE, append = TRUE)
    }
    write.csv(unique(list_1$category), "categories.csv", row.names = FALSE)
    
}


new_ajungo_fix <- function(excel_file){
    library(readxl)
    library(stringr)
    options(stringsAsFactors = FALSE)
    my_file <- read_excel(excel_file, sheet = 1)
    categories <- unlist(c(my_file[3,]))
    k <- unlist(which(is.na(categories) == TRUE))
    categories[k] <- subset(unlist(my_file[15,]), is.na(unlist(my_file[15,])) == FALSE)
    categories <-  gsub("/", "-", categories)
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
    g <- arrange(g, category, as.numeric(numbers))
    g$category <- str_to_title(g$category)
    
    g$category <- ifelse(g$category == "Game", "Console Game",
                         ifelse(g$category == "Institution", "Higher Education Institution",
                                ifelse(g$category == "Media - News Website","News Website",
                                       ifelse(g$category == "Media - News", "Media Outlet",
                                              ifelse(g$category == "Product - Service", "Online Products and Services",g$category)))))
    return(unique(g))
    
}


new_ajungo_fix_2 <- function(excel_file){
    library(readxl)
    options(stringsAsFactors = FALSE)
    my_file <- read_excel(excel_file, sheet = 1)
    categories <- unlist(c(my_file[4,]))
    k <- unlist(which(is.na(categories) == TRUE))
    categories[k] <- subset(unlist(my_file[16,]), is.na(unlist(my_file[16,])) == FALSE)
    categories <-  gsub("/", "-", categories)
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