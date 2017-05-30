remove(list = ls())
library(httr)
library(fbRads)
library(data.table)

app <- oauth_app('querying_ads_attempt', '1045624065519288', 'ff93f7d28d956c381a7b61b0149fe41a')
Sys.setenv('HTTR_SERVER_PORT' = '1410/')
tkn <- oauth2.0_token(
    oauth_endpoints('facebook'), app, scope = 'ads_management',
    type  = 'application/x-www-form-urlencoded', cache = FALSE)
tkn <- tkn$credentials$access_token

fbad_init(accountid = "319640814", token = tkn, version = '2.6')


##Searching for Interests
new_york <- fbad_get_search(q = 'New York', type = "adgeolocation")
fbr <- fbad_get_search(q = 'New York Islanders', type = "adinterest")

##Searching in one country

fbad_reachestimate(targeting_spec = list(
    geo_locations = list(countries = 'US'),
    flexible_spec = list(list(
        interests = data.frame(
            id = '6003061809928',
            name = 'New York Islanders'
        )
    ))
))$users

##Searching in one State
fbad_reachestimate(targeting_spec = list(
    geo_locations = list(regions =data.frame(key = '3875')),
    flexible_spec = list(list(
        interests = data.frame(
            id = '6003061809928',
            name = 'New York Islanders'
        )
    ))
))$users


###Searching for Ken Burns##

burns <- fbad_get_search(q = 'Ken Burns', type = "adinterest")

##Searching in Multiple States
fbad_reachestimate(targeting_spec = list(
    geo_locations = list(regions =data.frame(key = c('3875','3847','3852'))),
    flexible_spec = list(list(
        interests = data.frame(
            id = '6003359300604',
            name = 'Ken Burns'
        )
    ))
))$users

##Searching for multiple Interests##

#This first code searches for people that liked Ken Burns OR PBS#
pbs <- fbad_get_search(q = "PBS", type = "adinterest")
burns <- fbad_get_search(q = 'Ken Burns', type = "adinterest")

table <- as.data.frame(rbind(pbs[1,], burns[1,]))


fbad_reachestimate(targeting_spec = list(
    geo_locations = list(countries = 'US'),
    flexible_spec = list(list(
        interests = data.frame(
            id = table$id,
            name = table$name
        )
    ))
))$users

##This code searches for people that like KEN Burns AND PBS##

fbad_reachestimate(targeting_spec = list(
    geo_locations = list(countries = 'US'), 
    flexible_spec = list(
        list(interests = data.frame(
            id = table$id[1],
            name = table$id[1])),
        list(interests = data.frame(
            id = table$id[2],
            name = table$id[2]
            ))
)))$users


