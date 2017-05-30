options(stringsAsFactors = FALSE)

my_coalesce <- function(list,term){
    new_list <- ifelse(list == ""|is.na(list) == TRUE,term,list)
    return(new_list)
}




# returns string w/o leading whitespace
trim_leading <- function (x)  sub("^\\s+", "", x)

# returns string w/o trailing whitespace
trim_trailing <- function (x) sub("\\s+$", "", x)

# returns string w/o leading or trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

#Proper that works with single word#
to_proper <- function(x){
    z <- paste(toupper(substr(x,1,1)),tolower(substr(x,2,nchar(x))), sep = "")
    return(z)
    
}

to_proper_2 <- function(x){
    ##Not efficient, but good enough, has to use with for loop##
    splitting <- strsplit(x, split = " ")
    z <- unlist(splitting)
    last_vector <- NA
    for(i in 1:length(z)){
        last_vector[i] <- trim(to_proper(z[i]))
    }
    return(paste(last_vector, collapse =" "))
    
}

to_proper_3 <- function(x){
    ##More efficient, uses lapply instead of for loops#
    splitting <- strsplit(x, split = " ")
    z <- unlist(splitting)
    last_vector <- lapply(z, to_proper)
    return(paste(last_vector, collapse =" "))  
    # for(i in 1:5){
    #     x_1[,i] <- unlist(lapply(as.character(x_1[,i]), to_proper_3))
    #     y[,i] <- unlist(lapply(as.character(y[,i]), to_proper_3))
    # }
    ##The above example shows how to transform all datafrae columns##
}


return_df_random_sample <- function(sample_size, infile, outfile){
	##This works only with csv files##
	x <- read.csv(infile, header = TRUE)
	lines <- c(1:nrow(x))	
	x_1 <- x[sample(lines, sample_size,replace = FALSE),]
	write.csv(x_1, outfile, row.names = FALSE)
}

trim_and_proper <- function(data_frame){
    for(i in 1:ncol(data_frame)){
        if(is.character(data_frame[,i]) == TRUE){
            data_frame[,i] <- trim(unlist(lapply(as.character(data_frame[,i]), to_proper_3)))
        }else if(is.logical(data_frame[,i])==TRUE){
        	data_frame[,i] <- my_coalesce(data_frame[,i],"")
        }
        else{
            next
        }
    }
    return(data_frame)
}


##The for loop below is useful to change multiple missing values at once
## Use with discretion :)

# for(i in 1:ncol(x)){
#     if(is.numeric(x[,i]) == TRUE){
#         x[,i] <- my_coalesce(x[,i],".")
#     }else if(is.character(x[,i]) == TRUE){
#         x[,i] <- my_coalesce(x[,i],"")
#     }else if(is.logical(x[,i]) == TRUE){
#         x[,i] <- my_coalesce(x[,i],"Not Logical")
#     }else{
#         next
#     }
# }