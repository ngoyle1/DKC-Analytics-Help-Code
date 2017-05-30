library(httr)
library(fbRads)
library(data.table)
library(jsonlite)
library(readxl)
library(xlsx)

app <- oauth_app('querying_ads_attempt', '1045624065519288', 'ff93f7d28d956c381a7b61b0149fe41a')
Sys.setenv('HTTR_SERVER_PORT' = '1410/')
tkn <- oauth2.0_token(
  oauth_endpoints('facebook'), app, scope = 'ads_management',
  type  = 'application/x-www-form-urlencoded', cache = FALSE)
tkn <- tkn$credentials$access_token

fbad_init(accountid = "319640814", token = tkn, version = '2.7')

fb_ad_income <- function(id_vector,name_vector){
  suppressMessages(library(readxl))
  incomes <- read_excel("/Users/harrocyranka/Desktop/code/facebook_api_marketing/income_distribution_fb_ads.xlsx", sheet = 1)
  colnames(incomes) <- c("key", "name")
  
  income_vector <- NULL
for(i in 1:nrow(incomes)){
    income_vector[i] <- fbad_reachestimate(targeting_spec = list(
      geo_locations = list(countries = 'US'),
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
  return(income_vector)
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
  return(age_vector)
  
}


fb_ad_state <- function(id_vector, name_vector){
  suppressMessages(library(readxl))
  states <- read.csv("/Users/harrocyranka/Desktop/code/facebook_api_marketing/state_codes_for_fb_ads.csv")
  states_vector <- NULL
  for(i in 1:nrow(states)){
    states_vector[i] <- fbad_reachestimate(targeting_spec = list(
    geo_locations = list(regions =data.frame(key = as.character(states$key[i]))),
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
  return(states_vector)
}

fb_ad_race <- function(id_vector, name_vector){
    suppressMessages(library(readxl))
    options(stringsAsFactors = FALSE)
    options(scipen = 999)
    ethnic_groups <- read_excel("/Users/harrocyranka/Desktop/code/facebook_api_marketing/race_for_fb_ads.xlsx", sheet = 1)
    race_vector <- NULL
    
    ##This gets all minorities
    for(i in 1:nrow(ethnic_groups)){
        race_vector[i] <- fbad_reachestimate(targeting_spec = list(
            geo_locations = list(countries = 'US'),
            flexible_spec = list(
                list(interests = data.frame(
                    id = as.character(id_vector),
                    name = as.character(name_vector)
                )),
                list(ethnic_affinity = data.frame(
                    id = ethnic_groups$id[i],
                    name = ethnic_groups$Name[i]
                ))
            )
        ))$users
        print(paste(ethnic_groups$Name[i], " Retrieved", " for ", name_vector,sep = ""))
        Sys.sleep(3)
    }
    race_vector[4] <- fbad_reachestimate(targeting_spec = list(
        geo_locations = list(countries = 'US'),
        flexible_spec = list(
            list(interests = data.frame(
                id = as.character(id_vector),
                name = as.character(name_vector)
            ))),
        exclusions  = list(ethnic_affinity = data.frame(
                id = as.character(ethnic_groups$id),
                name = ethnic_groups$Name
            ))
        )
    )$users
    print(paste("Whites retrieved for ",name_vector, sep = ""))
    race_data_frame <- as.data.frame(cbind(c(ethnic_groups$Name,"Whites"),race_vector))
    colnames(race_data_frame) <- c("Ethnicity", "Count")
    race_data_frame$Count <- as.numeric(race_data_frame$Count)
    race_data_frame$Ethnicity <- ifelse(race_data_frame$Ethnicity == "Hispanic (US - All)",
                                        "Hispanics",ifelse(race_data_frame$Ethnicity == "African American (US)",
                                                          "Af. Americans",
                                                          ifelse(race_data_frame$Ethnicity == "Asian American (US)","Asians",
                                                                 "Whites")))
    return(race_data_frame)
}




fb_get_all <- function(id_vector, name_vector){
  options(stringsAsFactors = FALSE)
  options(scipen = 999)
  incomes <- read_excel("/Users/harrocyranka/Desktop/code/facebook_api_marketing/income_distribution_fb_ads.xlsx", sheet = 1)
  states <- read.csv("/Users/harrocyranka/Desktop/code/facebook_api_marketing/state_codes_for_fb_ads.csv")
  age <- read_excel("/Users/harrocyranka/Desktop/code/facebook_api_marketing/age_for_fb_ads.xlsx", sheet = 1)
  
	my_list <- list()
	income_1 <- fb_ad_income(id_vector, name_vector)
	age_1 <- fb_ad_age(id_vector, name_vector)
	state_1 <- fb_ad_state(id_vector, name_vector)
	income_data_frame <- as.data.frame(cbind(incomes$name,income_1))
	age_data_frame <- as.data.frame(cbind(age$Category, age_1))
	state_data_frame <- as.data.frame(cbind(states$name,state_1))
	my_list[[1]] <- income_data_frame
	my_list[[2]] <- age_data_frame
	my_list[[3]] <- state_data_frame
	return(my_list)
	
	
}