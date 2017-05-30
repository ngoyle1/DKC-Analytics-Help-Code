remove(list = ls())

library(RCurl)
source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")

x <- getURL("https://gist.githubusercontent.com/erichurst/7882666/raw/5bdc46db47d9515269ab12ed6fb2850377fd869e/US%2520Zip%2520Codes%2520from%25202013%2520Government%2520Data")

y <- read.csv(text = x)

z <- read_excel("/Users/harrocyranka/Desktop/code/zip_code_database.xlsx", sheet=1)
z <- filter(z, LocationType == "PRIMARY")

##
y <- sqldf("SELECT y.*,z.State
           FROM y JOIN z on y.ZIP = z.Zipcode")

##List of Regions
r <- read_excel("/Users/harrocyranka/Desktop/code/list_of_regions.xlsx", sheet = 3)

y <- sqldf("SELECT y.*, r.State as 'full_name', r.Region 
           FROM y JOIN r ON y.State = r.Abbreviation")

colnames(y) <- c("zip","latitude","longitude","abbreviation","state","region")
y <- select(y, state, abbreviation, region, zip, latitude, longitude)
y$zip <- ifelse(nchar(y$zip) == 3, paste("00",y$zip, sep = ""),
                ifelse(nchar(y$zip) == 4, paste("0",y$zip, sep =""),y$zip))
write.csv(y,"zip_code_state_region.csv", row.names = FALSE)
