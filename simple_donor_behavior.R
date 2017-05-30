simple_donation_behavior_insta <- function(id_vector,name_vector){
    library(dplyr)
    behaviors <- read_excel("/Users/harrocyranka/Desktop/code/facebook_behavior_categories.xlsx", sheet = 2)
    filter <- grep("donat",tolower(behaviors$description))
    donors <- behaviors[filter,][1:11,]
    
    donors_vector <- NULL
    for(i in 1:nrow(donors)){
        donors_vector[i]<- fbad_reachestimate(targeting_spec = list(
            geo_locations = list(countries = 'US'),
            publisher_platforms = "instagram",
            flexible_spec = list(
                list(behaviors = data.frame(
                    id = donors$id[i],
                    name = donors$name[i]
                )),
                list(interests = data.frame(
                    id = id_vector,
                    name = name_vector
                ))
            )
        ))$users
        print(i)
    }
    remove(i)
    df <- as.data.frame(cbind(donors$name, donors_vector))
    df$donors_vector <- as.numeric(as.character(df$donors_vector))
    df <- filter(df, donors_vector != "Green living")
    colnames(df) <- c("Donation Type", "Count")
    df <- arrange(df, desc(Count))
    return(df)
}

simple_donation_behavior_fb <- function(id_vector,name_vector){
    library(dplyr)
    behaviors <- read_excel("/Users/harrocyranka/Desktop/code/facebook_behavior_categories.xlsx", sheet = 2)
    filter <- grep("donat",tolower(behaviors$description))
    donors <- behaviors[filter,][1:11,]
    
    donors_vector <- NULL
    for(i in 1:nrow(donors)){
        donors_vector[i]<- fbad_reachestimate(targeting_spec = list(
            geo_locations = list(countries = 'US'),
            flexible_spec = list(
                list(behaviors = data.frame(
                    id = donors$id[i],
                    name = donors$name[i]
                )),
                list(interests = data.frame(
                    id = id_vector,
                    name = name_vector
                ))
            )
        ))$users
        print(i)
    }
    remove(i)
    df <- as.data.frame(cbind(donors$name, donors_vector))
    df$donors_vector <- as.numeric(as.character(df$donors_vector))
    df <- filter(df, donors_vector != "Green living")
    colnames(df) <- c("Donation Type", "Count")
    df <- arrange(df, desc(Count))
    return(df)
}


simple_donation_uni <- function(id_vector,name_vector, platform){
    library(dplyr)
    behaviors <- read_excel("/Users/harrocyranka/Desktop/code/facebook_behavior_categories.xlsx", sheet = 2)
    filter <- grep("donat",tolower(behaviors$description))
    donors <- behaviors[filter,][1:11,]
    
    donors_vector <- NULL
    for(i in 1:nrow(donors)){
        donors_vector[i]<- fbad_reachestimate(targeting_spec = list(
            geo_locations = list(countries = 'US'),
            publisher_platforms = platform,
            flexible_spec = list(
                list(behaviors = data.frame(
                    id = donors$id[i],
                    name = donors$name[i]
                )),
                list(interests = data.frame(
                    id = id_vector,
                    name = name_vector
                ))
            )
        ))$users
        print(i)
    }
    remove(i)
    df <- as.data.frame(cbind(donors$name, donors_vector))
    df$donors_vector <- as.numeric(as.character(df$donors_vector))
    df <- filter(df, donors_vector != "Green living")
    colnames(df) <- c("Donation Type", "Count")
    df <- arrange(df, desc(Count))
    return(df)
}