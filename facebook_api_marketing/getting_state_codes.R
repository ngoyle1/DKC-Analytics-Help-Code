library(sqldf)
library(dplyr)
library(httr)
library(fbRads)
library(data.table)
library(plyr)
options(stringsAsFactors = FALSE)
options(scipen = 999)
app <- oauth_app('querying_ads_attempt', '1045624065519288', 'ff93f7d28d956c381a7b61b0149fe41a')
Sys.setenv('HTTR_SERVER_PORT' = '1410/')
tkn <- oauth2.0_token(
    oauth_endpoints('facebook'), app, scope = 'ads_management',
    type  = 'application/x-www-form-urlencoded', cache = FALSE)
tkn <- tkn$credentials$access_token

fbad_init(accountid = "319640814", token = tkn, version = '2.6')
setwd("/Users/francisco06121988/Desktop/dkc/facebook_api_marketing")

x <- read.csv("regions_states.csv", header = TRUE)
states <- as.character(x[,2])

##Now we get all 50 states##
list_of_states <- list()

for(i in 1:length(states)){
    list_of_states[[i]] <- fbad_get_search(q = states[i], type = "adgeolocation")
}

master_frame <- ldply(list_of_states, data.frame)

master_frame <- unique(subset(master_frame, master_frame$type == "region" &
                       master_frame$country_code == "US"))

to_write <- select(master_frame, key,name)

write.csv(to_write, "state_codes_for_fb_ads.csv", row.names = FALSE)
##Gettting DC##
dc <- fbad_get_search(q = "Washington, DC", type = "adgeolocation")
