##More .R Functions

na_counts <- function(data_frame){
    vector_of_nas <- NULL
    for(i in 1:ncol(data_frame)){
        vector_of_nas[i] <- sum(is.na(data_frame[,i]))
        
    }
    return(vector_of_nas)
}


name_fixer <- function(input_vector){
    trim <- function (x) gsub("^\\s+|\\s+$", "", x)
    vector_of_names <- tolower(input_vector)
    
    name_vector_1 <- trim(gsub("  "," ",vector_of_names))
    #name_vector_2 <- tolower(name_vector_1)
    name_vector_3 <- trim(gsub("(\\s[a-z].+)","",name_vector_1))
    name_vector_4 <- trim(gsub("[^a-z]+"," ", name_vector_3))
    name_vector_5 <- trim(gsub("(\\s[a-z].+)","",name_vector_4))
    name_vector_6 <- trim(gsub("[^a-z]+"," ", name_vector_5))
    name_vector_7 <- trim(gsub("(\\s[a-z].+)","", name_vector_6))
    
    return(name_vector_7)
}
