remove(list = ls())
library(httr)
library(fbRads)
library(data.table)
library(jsonlite)

app <- oauth_app('querying_ads_attempt', '1045624065519288', 'ff93f7d28d956c381a7b61b0149fe41a')
Sys.setenv('HTTR_SERVER_PORT' = '1410/')
tkn <- oauth2.0_token(
  oauth_endpoints('facebook'), app, scope = 'ads_management',
  type  = 'application/x-www-form-urlencoded', cache = FALSE)
tkn <- tkn$credentials$access_token

p <- fbad_init(accountid = "319640814", token = tkn, version = '2.6')


##Searching for Interests
honest <- fbad_get_search(q = 'Honest Company', type = "adinterest")

fbad_reachestimate(targeting_spec = list(
  genders = 2,
  geo_locations = list(countries = 'US'),
  publisher_platforms = 'instagram',
  flexible_spec = list(
    list(interests = data.frame(
      id = '922288374458630',
      name = 'The Honest Company'))
  ))
)$users
