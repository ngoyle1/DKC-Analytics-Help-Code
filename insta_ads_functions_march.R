library(httr)
library(fbRads)
library(data.table)
library(jsonlite)
library(readxl)
library(xlsx)

app <- oauth_app('querying_ads_attempt', '1045624065519288', 'ff93f7d28d956c381a7b61b0149fe41a')
#Sys.setenv('HTTR_SERVER_PORT' = '1410/')
#tkn <- oauth2.0_token(
    #oauth_endpoints('facebook'), app, scope = 'ads_management',
    #type  = 'application/x-www-form-urlencoded', cache = FALSE)
tkn<-"EAAO2ZCVLZBbrgBAO9OvEPkUMadqXgpk51QDgF5bRsZBTPPNGOuiu9PC66gNeSR3fTipjhBimu8d220Jo2yg7visgD821CLoGqIDCJbFXfhMw28Mne68pwWVVjfHuHqn1xZAoC8dJznZCiziCooZBTS2ZCimiwxDAusC3TJDl9sTkgZDZD"

fbad_init(accountid = "319640814", token = tkn, version = '2.8')

fb_ad_education <- function(id_vector,name_vector){
    library(readxl)
    suppressMessages(library(dplyr))
    education <- read_excel("/Users/harrocyranka/Desktop/code/fb_ads_education_levels.xlsx", sheet = 1)
    education_vector <- NULL
    for(i in 1:nrow(education)){
        education_vector[i] <- fbad_reachestimate(targeting_spec = list(
            geo_locations = list(countries = 'US'),
            publisher_platforms = "instagram",
            education_statuses = education$code[i],
            flexible_spec = list(
                list(interests = data.frame(
                    id = id_vector,
                    name = name_vector
                ))
            )
        ))$users
        print(paste(education$education_status[i]," -"," Retrieved", " for ", name_vector,sep = ""))
        Sys.sleep(3)
    }
    
    education_frame <- as.data.frame(cbind(education$education_status,education_vector))
    colnames(education_frame) <- c("Education", "Count")
    education_frame$Count <- as.numeric(as.character(education_frame$Count))
    education_frame <- arrange(education_frame, desc(Count))
    return(education_frame)
}

fb_ad_income <- function(id_vector,name_vector){
  suppressMessages(library(readxl))
  incomes <- read_excel("/Users/harrocyranka/Desktop/code/facebook_api_marketing/income_distribution_fb_ads.xlsx", sheet = 1)
  colnames(incomes) <- c("key", "name")
  
  income_vector <- NULL
for(i in 1:nrow(incomes)){
    income_vector[i] <- fbad_reachestimate(targeting_spec = list(
      geo_locations = list(countries = 'US'),
      publisher_platforms = "instagram",
      flexible_spec = list(
        list(interests = data.frame(
          id = id_vector,
          name = name_vector
        )),
        list(income = data.frame(
          id = incomes$key[i],
          name = incomes$name[i]
        ))
      )
    ))$users
    print(paste(incomes$name[i],"-"," Retrieved", " for ", name_vector,sep = ""))
    Sys.sleep(3)
    }
  income_data_frame <- as.data.frame(cbind(incomes$name,income_vector))
  colnames(income_data_frame) <- c("Bracket", "Count")
  income_data_frame$Count <- as.numeric(income_data_frame$Count)
  return(income_data_frame)
}



fb_ad_age <- function(id_vector, name_vector){
  suppressMessages(library(readxl))
  age <- read_excel("/Users/harrocyranka/Desktop/code/facebook_api_marketing/age_for_fb_ads.xlsx", sheet = 1)
  age_vector <- NULL
  for(i in 1:nrow(age)){
    age_vector[i] <- fbad_reachestimate(targeting_spec = list(
      age_min = unbox(age$age_1[i]),
      age_max = unbox(age$age_2[i]),
      geo_locations = list(countries = 'US'),
      publisher_platforms = "instagram",
      flexible_spec = list(
        list(interests = data.frame(
          id = id_vector,
          name = name_vector
        ))
      )
    ))$users
    print(paste(age$age_1[i],"-",age$age_2," Retrieved", " for ", name_vector,sep = ""))
    Sys.sleep(3)
  }
  age_data_frame <- as.data.frame(cbind(age$Category, age_vector))
  colnames(age_data_frame) <- c("Age Category","Count")
  age_data_frame$Count <- as.numeric(age_data_frame$Count)
  return(age_data_frame)
  
}


fb_ad_state <- function(id_vector, name_vector){
  suppressMessages(library(readxl))
  states <- read.csv("/Users/harrocyranka/Desktop/code/facebook_api_marketing/state_codes_for_fb_ads.csv")
  states_vector <- NULL
  for(i in 1:nrow(states)){
    states_vector[i] <- fbad_reachestimate(targeting_spec = list(
    geo_locations = list(regions =data.frame(key = as.character(states$key[i]))),
    publisher_platforms = "instagram",
    flexible_spec = list(list(
      interests = data.frame(
        id = as.character(id_vector),
        name = as.character(name_vector)
      )
    ))
  ))$users
  print(paste(states$name[i], " Retrieved", " for ", name_vector,sep = ""))
  Sys.sleep(3)
  }
  state_data_frame <- as.data.frame(cbind(states$name,states_vector))
  colnames(state_data_frame) <- c("State", "Count")
  state_data_frame$Count <- as.numeric(state_data_frame$Count)
  return(state_data_frame)
}

fb_ad_top_dmas_top_50 <- function(id_vector, name_vector){
    suppressMessages(library(readxl))
    states <- read_excel("/Users/harrocyranka/Desktop/code/dma_fb_list.xlsx", sheet = 1)
    states <- states[c(1:50),]
    states_vector <- NULL
    for(i in 1:50){
        states_vector[i] <- fbad_reachestimate(targeting_spec = list(
            geo_locations = list(geo_markets = data.frame(key = states$key[i])),
            publisher_platforms = "instagram",
            flexible_spec = list(list(
                interests = data.frame(
                    id = as.character(id_vector),
                    name = as.character(name_vector)
                )
            ))
        ))$users
        print(paste(states$name[i], " Retrieved", " for ", name_vector,sep = ""))
        Sys.sleep(3)
    }
    dma_data_frame <- as.data.frame(cbind(states$name,states_vector))
    colnames(dma_data_frame) <- c("dma", "count")
    dma_data_frame$count <- as.numeric(dma_data_frame$count)
    return(dma_data_frame)
}


fb_ad_dmas_all<- function(id_vector, name_vector){
    suppressMessages(library(readxl))
    states <- read_excel("/Users/harrocyranka/Desktop/code/dma_fb_list.xlsx", sheet = 1)
    states_vector <- NULL
    for(i in 1:nrow(states)){
        states_vector[i] <- fbad_reachestimate(targeting_spec = list(
            geo_locations = list(geo_markets = data.frame(key = states$key[i])),
            publisher_platforms = "instagram",
            flexible_spec = list(list(
                interests = data.frame(
                    id = as.character(id_vector),
                    name = as.character(name_vector)
                )
            ))
        ))$users
        print(paste(states$name[i], " Retrieved", " for ", name_vector,sep = ""))
        Sys.sleep(3)
    }
    dma_data_frame <- as.data.frame(cbind(states$name,states_vector))
    colnames(dma_data_frame) <- c("dma", "count")
    dma_data_frame$count <- as.numeric(dma_data_frame$count)
    return(dma_data_frame)
}

fb_ad_gender <- function(id_vector, name_vector){
    gender_identifier <- c("Men", "Women")
    gender_numbers <- c(1,2)
    gender_vector <- NULL
    for(i in 1:2){
    gender_vector[i] <- fbad_reachestimate(targeting_spec = list(
        genders = gender_numbers[i],
        geo_locations = list(countries = 'US'),
        publisher_platforms = "instagram",
        flexible_spec = list(list(
            interests = data.frame(
                id = as.character(id_vector),
                name = as.character(name_vector)
            )
        ))
    ))$users
    print(paste(gender_identifier[i], " Retrieved", " for ", name_vector,sep = ""))
    }
    my_data_frame <- as.data.frame(cbind(gender_identifier,as.numeric(as.character(gender_vector))))
    colnames(my_data_frame) <- c("Gender", "Count")
    return(my_data_frame)
}


fb_ad_ideology <- function(id_vector, name_vector){
    categories <- read_excel("/Users/harrocyranka/Desktop/code/categories_for_fb_ads.xlsx", sheet = 1)
    political <- subset(categories, categories$type == "politics")
    political_vector <- NULL
    for(i in 1:nrow(political)){
        political_vector[i] <- fbad_reachestimate(targeting_spec = list(
            geo_locations = list(countries = 'US'),
            publisher_platforms = "instagram",
            flexible_spec = list(
                list(interests = data.frame(
                    id = id_vector,
                    name = name_vector
                )),
                list(politics = data.frame(
                    id = political$id[i],
                    name = political$Name[i]
                ))      
            ))
        )$users
        print(paste(as.character(political$Name)[i], " Retrieved", " for ", as.character(name_vector) ,sep = ""))
    }
    ideology_vector <- c("Very Liberal", "Liberal", "Moderate","Conservative", "Very Conservative",
                         "Conservative Activist", "Liberal Activist",
                         "Conservative Donor", "Liberal Donor")
    my_data_frame <- as.data.frame(cbind(ideology_vector,as.numeric(as.character(political_vector))))
    colnames(my_data_frame) <- c("Politics","Count")
    return(my_data_frame)
}


fb_ad_industries <- function(id_vector, name_vector){
    x <- read_excel("/Users/harrocyranka/Desktop/code/categories_for_fb_ads.xlsx", sheet = 1)
    filter <- grep("People who are owners or employees of a business in the",x$description)
	industries <- subset(x, x$type == "industries")
	industry_vector <- NULL
	for(i in 1:nrow(industries)){
	    industry_vector[i] <- fbad_reachestimate(targeting_spec = list(
	        geo_locations = list(countries = 'US'),
          publisher_platforms = "instagram",
	        flexible_spec = list(
	            list(interests = data.frame(
	                id = id_vector,
	                name = name_vector
	            )),
	            list(industries = data.frame(
	                id =industries$id[i],
	                name = industries$Name[i]
	            ))      
	        ))
	    )$users
	    print(paste(as.character(industries$Name)[i], " Retrieved", " for ", as.character(name_vector) ,sep = ""))
	    Sys.sleep(3)
	}
	final_frame <- as.data.frame(cbind(industries$Name,as.numeric(as.character(industry_vector))))
	colnames(final_frame) <- c("industry", "count")
	return(final_frame)
}

fb_ad_race <- function(id_vector, name_vector){
  race_ids <- c("6021722613183","6018745176183","6003133212372")
  race_names <- c("Asian American (US)","African American (US)","Hispanic (US - All)","White")
  race_vector <- NULL
  
  ##get minorities##
  for(i in 1:3){
    race_vector[i] <- fbad_reachestimate(targeting_spec = list(
      geo_locations = list(countries = 'US'),
      publisher_platforms = "instagram",
      flexible_spec = list(
        list(interests = data.frame(
          id = id_vector,
          name = name_vector
        )),
        list(behaviors = data.frame(
          id = race_ids[i],
          name = race_names[i]
        ))
      )
    ))$users
    print(paste(race_names[i]," Retrieved", " for ", name_vector,sep = ""))
  }
  ##get whites
  race_vector[4] <- fbad_reachestimate(targeting_spec = list(
    geo_locations = list(countries = 'US'),
    publisher_platforms = "instagram",
    flexible_spec = list(
      list(interests = data.frame(
        id = as.character(id_vector),
        name = as.character(name_vector)
      ))),
    exclusions  = list(behaviors = data.frame(
      id = as.character(race_ids),
      name =as.character(race_vector)
    ))
  )
  )$users
  print(paste("Whites retrieved for ",name_vector, sep = ""))
  race_data_frame <- as.data.frame(cbind(race_names, race_vector))
  colnames(race_data_frame) <- c("Ethnic/Cultural Group","Count")
  race_data_frame$Count <- as.numeric(race_data_frame$Count)
  race_data_frame$percent <- race_data_frame$Count/sum(race_data_frame$Count)
  race_data_frame <- race_data_frame[c(4,2,3,1),]
  return(race_data_frame)
}


fb_get_all <- function(id_vector, name_vector, file_name){
  options(stringsAsFactors = FALSE)
  options(scipen = 999)
  incomes <- read_excel("/Users/harrocyranka/Desktop/code/facebook_api_marketing/income_distribution_fb_ads.xlsx", sheet = 1)
  states <- read.csv("/Users/harrocyranka/Desktop/code/facebook_api_marketing/state_codes_for_fb_ads.csv")
  age <- read_excel("/Users/harrocyranka/Desktop/code/facebook_api_marketing/age_for_fb_ads.xlsx", sheet = 1)
  
  
  z <- fb_ad_income(id_vector = id_vector, name_vector = name_vector)
  
  x <- fb_ad_age(id_vector = id_vector, name_vector = name_vector)
  
  v <- fb_ad_state(id_vector = id_vector, name_vector = name_vector)
  
  k <- fb_ad_race(id_vector = id_vector, name_vector = name_vector)
  
  l <- fb_ad_gender(id_vector = id_vector, name_vector = name_vector)
  
  a <- fb_ad_ideology(id_vector = id_vector, name_vector = name_vector)
  
  a_2 <- fb_ad_industries(id_vector = id_vector, name_vector = name_vector)
  
  a_3 <- fb_ad_education(id_vector = id_vector, name_vector = name_vector)
  
  write.xlsx(z, file = paste(file_name,".xlsx",sep = ""), sheetName = "income", append=FALSE, row.names = FALSE)
  write.xlsx(x, file = paste(file_name,".xlsx",sep = ""), sheetName = "age", append=TRUE, row.names = FALSE)
  write.xlsx(v, file = paste(file_name,".xlsx",sep = ""), sheetName = "state", append=TRUE, row.names = FALSE)
  write.xlsx(k, file = paste(file_name,".xlsx",sep = ""), sheetName = "ethnicity", append=TRUE, row.names = FALSE)
  write.xlsx(l, file = paste(file_name,".xlsx",sep = ""), sheetName = "gender", append=TRUE, row.names = FALSE)
  write.xlsx(a, file = paste(file_name,".xlsx",sep = ""), sheetName = "ideology", append=TRUE, row.names = FALSE)
  write.xlsx(a_2, file = paste(file_name,".xlsx",sep = ""), sheetName = "industries", append=TRUE, row.names = FALSE)
  write.xlsx(a_3, file = paste(file_name,".xlsx",sep = ""), sheetName = "education", append=TRUE, row.names = FALSE)

  my_list <- list(z,x,v,l,a,a_2,a_3)
  return(my_list)
}