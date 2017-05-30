remove(list = ls())
library(tuber)
library(ggplot2)
library(dplyr)
setwd("/Users/harrocyranka/Desktop/Research_and_Projects/dead_projects/sephora/")
x <- yt_oauth("581635630807-7gieutqu6arntl03n1ccjg439dgsea1h.apps.googleusercontent.com",
         "2qbnUR_tcrCtRxLvesYEUXJy","ssl","https://www.googleapis.com/oauth2/v1/certs")

##
i <- get_stats(video_id="Mh6Ez72lPf0")
j <- get_video_details(video_id="r_SsxVqQbYI")

##
sephora_channel_id <- "UC9YX5x_VU8gfe0Oui0TaLJg"

##
##Channel Stats
channel_stats <- get_channel_stats(sephora_channel_id) ##Basic Stats


####

a <- list_channel_resources(filter = c(channel_id = sephora_channel_id), part="contentDetails")

# Uploaded playlists:
playlist_id <- a$items[[1]]$contentDetails$relatedPlaylists$uploads

# Get videos on the playlist
vids <- get_playlist_items(filter= c(playlist_id=playlist_id)) 

vid_ids <- NULL

for(i in 1:length(vids$items)){
    vid_ids[i] <- vids$items[[i]]$contentDetails$videoId
    print(i)
}
remove(i)

##Get List of Stats##
res <- list()
for (i in 1:length(vid_ids)) {
  
  temp <- get_stats(video_id = vid_ids[i])
  res[[i]]  <- temp
}
remove(i)

##
vidStats <- data.frame()
for(i in 1:length(res)){
  first <- as.data.frame(res[[i]])
  vidStats <- rbind(vidStats,first)
}
remove(first,i)

###
j <- get_video_details(video_id="avz6uoXL7H0")

##Get Video Names
video_names <- NULL
for(i in 1:nrow(vidStats)){
  first <- get_video_details(video_id = vidStats$id[i])
  video_title <- first$title
  video_names[i] <- video_title
  print(video_title)
}
remove(first, video_title)

####
vidStats$video_title <- video_names

###
vidStats$video_number <- nrow(vidStats):1
vidStats[,2:6] <- apply(vidStats[,2:6],2,as.numeric)

g1 <- ggplot(vidStats, aes(x = video_number, y = viewCount)) + geom_line()
g2 <- g1 + theme_bw() + labs(x = "Time", y = "View Count", title = "Videos Published Between February 15, 2017 and April 4, 2017") + geom_abline(intercept = median(median(vidStats$viewCount)),linetype = 2, color = "red1")
g2 + theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) + geom_abline(intercept = median(mean(vidStats$viewCount)),linetype = 2, color = "green4")
####
comments <- get_comment_threads(c(video_id="D7orfV2Jt8o"))

vidStats$polarity <- round(vidStats$likeCount/(vidStats$likeCount + vidStats$dislikeCount)*100,2)

##
z1 <- ggplot(vidStats, aes(x = video_number, y = polarity)) + geom_line()
z2 <- z1 + theme_bw() + labs(x = "Time", y = "% Positive Evaluations", title = "Videos Published Between February 15, 2017 and April 4, 2017")+ ylim(45,100)
z3 <- z2 + theme(axis.text.x=element_blank(),
                    axis.ticks.x=element_blank())
z3 + geom_hline(yintercept = median(vidStats$polarity),linetype = 2, color = "red1") + geom_hline(yintercept = mean(vidStats$polarity),linetype = 2, color = "green4")

##
polarity <- arrange(vidStats, desc(polarity))

##
names(j)
j