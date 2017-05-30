create_public_df_private_links <- function(input_file){
  source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")
  x <- colnames_insta(read.csv(input_file))
  public <- filter(x, following != "Private Account")
  
  #public <- public[-grep("[^0-9]", public$following), ]

  public[,7:9] <- apply(public[,7:9],2,as.numeric)
  
  public <- public[complete.cases(public$following),]
  
  write.csv(public, "public_accounts.csv", row.names = FALSE)
  
  ##Private Accounts##
  private <- filter(x, following == "Private Account")
  links <- as.data.frame(paste("https://www.instagram.com/",private$username,"/", sep = ""))
  colnames(links) <- "link"
  
  links$rows <- 1:nrow(private)
  write.csv(private, "private_accounts.csv", row.names = FALSE)
  write.csv(links, "list_of_private_links.csv", row.names = FALSE)
}


get_location_audience_estimates <- function(public_accounts_file, private_buckets_file, location_file, sample_size){
  source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")
  
  x <- read.csv(public_accounts_file, header = TRUE)
  #filter <- grep("[^0-9]", x$following)
  #x <- x[-filter,]
  x[,7:9] <- apply(x[,7:9], 2, as.numeric)
  
  ##Followers
  public_follow <- select(x, username,followers)
  public_follow$buckets <- follower_numbers_2(public_follow$followers)
  public_follow$type <- follower_numbers_1(public_follow$followers)
  
  ##Get Sample for descriptions##
  set.seed(123)
  filter <- sample(1:nrow(x),sample_size)
  
  public_descriptions <- x[filter, ]
  public_descriptions <- select(public_descriptions, description)
  public_descriptions$rows <- 1:nrow(public_descriptions)
  
  write.csv(public_descriptions, "public_descriptions_sample.csv", row.names = FALSE)
  
  
  #Joining Buckets#
  public_buckets <- get_counts_as_df(public_follow$buckets)
  public_buckets <- public_buckets[c(1,2,3,4,5,7,6),]
  private_buckets <- read_excel(private_buckets_file)
  private_buckets <- select(private_buckets,vector, estimate)
  colnames(private_buckets) <- colnames(public_buckets)
  
  all_buckets <- as.data.frame(rbind.fill(private_buckets, public_buckets))
  all_buckets <- sqldf("SELECT vector as 'Bucket', SUM(Freq) as 'Count'
                       FROM all_buckets
                       GROUP BY 1")
  write.xlsx(all_buckets, "buckets_following_estimate.xlsx", row.names = FALSE)
  
  ##Get Location
  filter <- which(x$last_post_location != "Never posted.")
  with_location <- x[filter,]
  with_location <- filter(with_location, last_post_latitude != "No location given.")
  
  with_location$influencer <- follower_numbers_1(with_location$followers)
  
  with_location[,c(12:13)] <- apply(as.matrix(with_location[,c(12:13)]),2,as.numeric)
  loc <- with_location
  
  us <- sqldf("SELECT loc.* FROM loc
              WHERE last_post_latitude BETWEEN 24.29 AND 49.24
              AND last_post_longitude BETWEEN -124.46 AND -66.57")
  write.csv(us, location_file, row.names = FALSE)
  
}

get_nearest_dma <- function(location_file, positions_file, last_picture_location_file){
  library(FNN)
  source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")
  
  ##US Frame
  us <- read.csv(location_file, header = TRUE)
  dma <- read.csv("/Users/harrocyranka/Desktop/code/dmas_coordinates2.csv")
  dma2 <- as.matrix(select(dma, latitude, longitude))
  row.names(dma2) <- dma$dma1
  
  
  pics <- select(us, last_post_latitude, last_post_longitude)
  
  pics <- as.matrix(pics)
  colnames(pics) <- c("latitude", "longitude")
  
  ##
  test <- as.data.frame(knnx.index(data = dma2, query = pics, k= 1))
  colnames(test) <- "dma"
  
  pics <- as.data.frame(cbind(pics, test$dma))
  colnames(pics) <- c("latitude", "longitude", "dma_number")
  
  to_match <- as.data.frame(cbind(row.names(dma),dma$dma1))
  colnames(to_match) <- c("n", "dma")
  
  
  geo <- sqldf("SELECT pics.*,to_match.dma
               FROM pics JOIN to_match ON pics.dma_number = to_match.n")
  
  
  positions <- get_counts_as_df(geo$dma)
  
  
  positions$quintiles <- as.character(rev(assign_quintiles(1:nrow(positions))))
  
  geo <- sqldf("SELECT geo.*,positions.*
               FROM geo LEFT JOIN positions ON geo.dma=positions.vector")
  
  
  write.xlsx(positions, positions_file, row.names = FALSE)
  write.xlsx(geo, last_picture_location_file, row.names = FALSE)
}

private_accounts_estimate <- function(private_accounts_file){
  library(gtools)
  library(RJSONIO)
  
  source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")
  
  my_files <- mixedsort(list.files())
  
  followers_count <- NULL
  usernames <- NULL
  full_name <- NULL
  bio <- NULL
  for(i in 1:length(my_files)){
    y <- fromJSON(my_files[i])
    followers_count <- append(followers_count,y$entry_data$ProfilePage[[1]]$user$followed_by[[1]])
    bio <- append(bio,y$entry_data$ProfilePage[[1]]$user$biography)
    usernames <- append(usernames,y$entry_data$ProfilePage[[1]]$user$username)
    full_name <- append(full_name, y$entry_data$ProfilePage[[1]]$user$full_name)
    print(i)
  }
  remove(i)
  
  ##
  get_followers <- as.data.frame(cbind(usernames,followers_count))
  get_followers$followers_count <- as.numeric(as.character(get_followers$followers_count))
  
  get_followers$type <- follower_numbers_1(get_followers$followers_count)
  
  
  ###Description##
  descrip <- as.data.frame(bio)
  colnames(descrip) <- "description"
  
  setwd("..//")
  
  
  get_followers$buckets <- follower_numbers_2(get_followers$followers_count)
  buckets <- get_counts_as_df(get_followers$buckets)
  buckets$percent <- buckets$Freq/sum(buckets$Freq)
  total_account <- nrow(filter(colnames_insta(read.csv(private_accounts_file)),description == "Private Account"))
  buckets$estimate <- round(buckets$percent*total_account,0)

  write.xlsx(buckets,"buckets_private_accounts.xlsx", row.names = FALSE)
  write.csv(descrip, "instagram_private_descriptions.csv", row.names = FALSE)
}