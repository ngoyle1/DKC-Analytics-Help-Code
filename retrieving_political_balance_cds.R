remove(list = ls())
options(stringsAsFactors = FALSE)
options(scipen = 999)

setwd("/Users/harrocyranka/Desktop/code/")
source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")
source("/Users/harrocyranka/Desktop/code/fb_ads_functions_march.R")


x <- read_excel("congressional_districts.xlsx", sheet = 1)
x$district <- as.character(x$district)

x$district <- ifelse(nchar(x$district) == 1,paste("0",x$district, sep = ""), x$district)

##Bring Abbreviations
regions <- read_excel("list_of_regions.xlsx", sheet = 3)

x <- sqldf("SELECT x.*, regions.Abbreviation as 'abbreviation'
           FROM x LEFT JOIN regions ON x.state = regions.State")
x$fb_code <- paste("US:",x$abbreviation,x$district, sep = "")
#write.xlsx(x, "electoral_districts_with_codes.xlsx", row.names = FALSE)

##Ideology
fb_ad_ideology_cd <- function(define_district){
  categories <- read_excel("/Users/harrocyranka/Desktop/code/categories_for_fb_ads.xlsx", sheet = 1)
  political <- subset(categories, categories$type == "politics")
  political <- political[1:5,]
  political_vector <- NULL
  for(i in 1:nrow(political)){
    political_vector[i] <- fbad_reachestimate(targeting_spec = list(
      geo_locations = list(electoral_districts =data.frame(key = define_district)),
      flexible_spec = list(
        list(politics = data.frame(
          id = political$id[i],
          name = political$Name[i]
        ))      
      ))
    )$users
    print(paste(as.character(political$Name)[i], " Retrieved", " for ", define_district,sep = ""))
  }
  ideology_vector <- c("Very Liberal", "Liberal", "Moderate","Conservative", "Very Conservative")
  my_data_frame <- as.data.frame(cbind(ideology_vector,as.numeric(as.character(political_vector))))
  colnames(my_data_frame) <- c("Politics","Count")
  return(my_data_frame)
}
# dir.create("list_of_districts_with_csv")
setwd("list_of_districts_with_csv/")
list_of_districts <- list()
for(i in 1:nrow(x)){
  list_of_districts[[i]] <- fb_ad_ideology_cd(x$fb_code[i])
  list_of_districts[[i]]$district <- x$fb_code[i]
  print(paste("Retrieved for ",x$fb_code[i], sep = ""))
  write.csv(list_of_districts[[i]],paste(x$state[i],"_",as.character(x$district[i]),".csv",sep=""), row.names = FALSE)
  Sys.sleep(5)
}
remove(i)

###