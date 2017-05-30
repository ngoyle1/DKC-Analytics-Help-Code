remove(list = ls())
options(stringsAsFactors = FALSE)
options(scipen = 999)

source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")
source("/Users/harrocyranka/Desktop/code/twitter_info_analysis_3.R")

##Naya Health#
#naya_1 <- getUser("nayahealthco")
#naya_2 <- as.data.frame(naya_1$getFollowerIDs())

colnames(naya_2) <- "ids"

#naya_3 <- get_users_api_direct(naya_2,0)

##Babyation#
baby_1 <- getUser("Babyation")
baby_2 <- as.data.frame(baby_1$getFollowerIDs())
colnames(baby_2) <- "ids"

baby_3 <- get_users_api_direct(baby_2,0)

##Johnson's Baby
jj_1 <- getUser("johnsonsbaby")
jj_2 <- as.data.frame(jj_1$getFollowerIDs())
colnames(jj_2) <- "ids"

jj_3 <- get_users_api_direct(jj_2,0)

##Gerber
gerber <- getUser("GerberLife")
gerber_2 <- as.data.frame(gerber$getFollowerIDs())
colnames(gerber_2) <- "ids"

gerber_3 <- get_users_api_direct(gerber_2, 0)

##Medela
medela <- getUser("Medela_US")
medela_2 <- as.data.frame(medela$getFollowerIDs())
colnames(medela_2) <- "ids"

medela_3 <- get_users_api_direct(medela_2,0)


##Honest Company Attempt
honest <- get_first_followers("Honest", "-1")
honest_2 <- get_users_api_direct(honest, 0)

honest_estimate <- get_counts_as_df(follower_numbers_1(honest_2$followersCount))
hn <- getUser("Honest")

#write.xlsx(honest_estimate, "honest_estimate.xlsx", row.names = FALSE)
#dir.create("Desktop/breast_pump_twitter_competitors")
setwd("Desktop/breast_pump_twitter_competitors/")

write.csv(baby_3, "babyation_twitter.csv", row.names = FALSE)
write.csv(gerber_3, "gerber_twitter.csv", row.names = FALSE)
write.csv(honest_2,"honest_company_twitter.csv", row.names = FALSE)
write.csv(jj_3, "johson_and_johnson_baby.csv", row.names = FALSE)
write.csv(medela_3, "medela_twitter.csv", row.names = FALSE)
write.csv(naya_3, "naya_health.csv", row.names = FALSE)

