get_county_city <- function(csv_file){
  library(readxl)
  trim <- function (x) gsub("^\\s+|\\s+$", "", x)
  my_cities <- read.csv("/Users/harrocyranka/Desktop/code/zip_code_database.csv", sheet = 1)
  my_cities$City <- trim(tolower(my_cities$City))
  ##Make sure the city, county file is loaded as my_cities
  suppressWarnings(suppressMessages(library(sqldf)))

  first <- read.csv(csv_file, header = TRUE)
  first$primary_city <- trim(tolower(first$primary_city))
  first$primary_city <- trim(gsub("[^a-z]","",tolower(first$primary_city)))
  filter_first <- first[first$primary_city %in% unique(my_cities$City),]
  cities_sum <- sqldf("SELECT filter_first.primary_city,my_cities.State,my_cities.County,
                      COUNT(*) FROM filter_first LEFT JOIN my_cities ON filter_first.primary_city = my_cities.City
                      AND filter_first.primary_state = my_cities.State
                      GROUP BY 1,2,3
                      ORDER BY 4 DESC")
  colnames(cities_sum) <- c("city","state","county","count")
  return(cities_sum)
}


name_filter <- function(data_frame){
  data_frame_with_names <- read.csv("/Users/harrocyranka/Desktop/code/name/name/names_with_probabilities.csv", header = TRUE)
  list_names <- data_frame_with_names$name
  data_frame$first_name <- tolower(data_frame$first_name)
  data_frame$first_name <- gsub("[^a-z]","",tolower(data_frame$first_name))
  filtered_frame <- data_frame[data_frame$first_name %in% list_names,]
  return(filtered_frame)
}

na_counts <- function(data_frame){
  return_vector <- NULL
  for(i in 1:ncol(data_frame)){
    return_vector[i] <- sum(is.na(data_frame[,i]))
  }
  return(return_vector)
}

get_counts_as_df <- function(vector){
	library(dplyr)
	table <- arrange(as.data.frame(table(vector)), desc(Freq))
	return(table)
}


get_regions <- function(x){
  library(sqldf)
  library(xlsx)
  library(readxl)
  my_regions <- read_excel("/Users/harrocyranka/Desktop/code/list_of_regions.xlsx", sheet = 3)
  data_frame <- x
  matched <- sqldf("SELECT data_frame.State as 'Abbreviation',my_regions.State, my_regions.Region, data_frame.count
                   FROM data_frame LEFT JOIN my_regions ON data_frame.State = my_regions.Abbreviation")
  return(matched)
}