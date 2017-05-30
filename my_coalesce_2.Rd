follower_numbers_1 <- function(vector){
	returning_vector <- ifelse(vector >10000,"Influencer",
								ifelse(vector <=10000 & vector >500, "Micro Influencer",
								"Ordinary User"))
}


gender_names <- function(name_vector){
    library(sqldf)
    library(dplyr)
    my_names <- read.csv("/Users/harrocyranka/Desktop/code/name/name/names_with_probabilities.csv")
    from_df <- as.data.frame(name_vector)
    colnames(from_df) <- "name"
    merged <- sqldf("SELECT from_df.name, my_names.p_female
                      FROM my_names INNER JOIN from_df
                      ON my_names.name = from_df.name")
    merged$gender <- ifelse(merged$p_female > 0.55, "Female",ifelse(merged$p_female < 0.45,"male", "undefined"))
    return(merged)
}


follower_numbers_2 <- function(follower_vector){
      empty_vector <- ifelse(follower_vector > 20000,"20001+",
                      ifelse(follower_vector <= 20000 &follower_vector > 10000,"10001-20000",
                      ifelse(follower_vector <= 10000 & follower_vector > 5000,"5001-10000",
                      ifelse(follower_vector <= 5000 & follower_vector > 2500, "2501-5000",
                      ifelse(follower_vector <= 2500 & follower_vector > 1000, "1001-2500",
                      ifelse(follower_vector <= 1000 & follower_vector > 500,"501-1000","0-500"))))))
      return(empty_vector)
      
}


engagement_levels <- function(my_vector){
      empty_vector <- ifelse(my_vector >5, "Heavy User", ifelse(my_vector > 1 & my_vector <= 5, "Medium User","Low User"))
      return(empty_vector)
}